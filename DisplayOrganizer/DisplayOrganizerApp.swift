//
//  DisplayOrganizerApp.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 25/01/2021.
//

import SwiftUI

@main
struct DisplayOrganizerApp: App {
    
    private let dataContainer = PersistenceController.shared.container
    
    @ObservedObject private var editor = Editor()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ProfilesList()
                    .environmentObject(editor)
                    .environment(\.managedObjectContext, dataContainer.viewContext)
                ProgressView()
                    .font(.title)
            }
            .frame(minWidth: 700, idealWidth: 800, minHeight: 400, idealHeight: 500, alignment: .center)
            .sheet(item: $editor.presentedSheet) {
                switch $0 {
                case .profileEdit(let profile):
                    ProfileEditView(profile)
                        .environment(\.managedObjectContext, dataContainer.viewContext)
                }
            }
        }
        .commands {
            let multiplier = 20
            CommandGroup(after: .saveItem) {
                Button("Save profile as...") {
                    let profile = Profile(context: dataContainer.viewContext)
                    profile.configuration = editor.displaysEditing.configuration
                    editor.presentedSheet = .profileEdit(profile)
                }
                .keyboardShortcut("s")
                .disabled(!editor.changed)
            }
            CommandGroup(after: .textEditing) {
                Button("Move display up") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.move(to: .up, by: multiplier)
                }
                .keyboardShortcut(.upArrow, modifiers: [])
                .disabled(editor.selected == nil)
                Button("Move display down") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.move(to: .down, by: multiplier)
                }
                .keyboardShortcut(.downArrow, modifiers: [])
                .disabled(editor.selected == nil)
                Button("Move display left") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.move(to: .left, by: multiplier)
                }
                .keyboardShortcut(.leftArrow, modifiers: [])
                .disabled(editor.selected == nil)
                Button("Move display right") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.move(to: .right, by: multiplier)
                }
                .keyboardShortcut(.rightArrow, modifiers: [])
                .disabled(editor.selected == nil)
                Button("Rotate display left") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.rotate(to: .left)
                }
                .keyboardShortcut(.leftArrow)
                .disabled(editor.selected == nil)
                Button("Rotate display right") {
                    guard let display = editor.selected else { return }
                    editor.displaysEditing[display.id]?.rotate(to: .right)
                }
                .keyboardShortcut(.rightArrow)
                .disabled(editor.selected == nil)
            }
            CommandGroup(after: .toolbar) {
                Button("\(editor.showActive ? "Hide" : "Show") active displays") {
                    editor.showActive.toggle()
                }
                .keyboardShortcut("a", modifiers: [.command, .shift])
                Button("Reset working profile") {
                    editor.reset()
                    editor.reposition()
                }
                .keyboardShortcut(.delete)
                .disabled(!editor.changed)
                Button("Refresh") {
                    editor.refresh()
                }
                .keyboardShortcut("r")
            }
        }
    }
    
}
