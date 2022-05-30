//
//  ContentView.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 25/01/2021.
//

import SwiftUI
import CoreData

struct EditorView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject private var editor: Editor
    
    @State private var xMoved: CGFloat = 0
    @State private var yMoved: CGFloat = 0
    
    private let profile: Profile?
    
    public init(_ profile: Profile? = nil) {
        self.profile = profile
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { proxy in
                let center = NSPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                if editor.showActive {
                    ForEach(editor.displaysActive) { display in
                        DisplayItemView(display, center: center, placeholder: true)
                    }
                }
                ForEach(editor.displaysEditing) { display in
                    DisplayItemView(display, center: center)
                }
            }
            .environmentObject(editor)
            .animation(.easeInOut, value: editor.showActive)
            .animation(.easeInOut, value: editor.displaysActive)
            .animation(.easeInOut, value: editor.displaysEditing)
            HStack {
                VStack(alignment: .leading) {
                    Toggle(isOn: $editor.showActive) {
                        Text("Show active displays")
                            .font(.system(size: 12))
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Button {
                        editor.reset()
                        editor.reposition()
                    } label: {
                        Text("Reset")
                    }
                    .disabled(!editor.changed)
                    Spacer()
                    let displayCount = editor.displaysActive.count
                    Label("\(displayCount) display\(displayCount == 1 ? "" : "s") connected", systemImage: "link")
                }
                .controlSize(.small)
            }
            .padding()
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { event in
                guard let position = NSApp.windows.first?.convertPoint(toScreen: NSPoint(x: 0, y: 0)) else { return nil }
                editor.mouse = event.locationInWindow + position
                return nil
            }
            NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
                guard let position = NSApp.windows.first?.convertPoint(toScreen: NSPoint(x: 0, y: 0)) else { return }
                editor.mouse = event.locationInWindow + position
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard let selected = editor.selected else { return }
                    editor.moving = true
                    let xMove = value.translation.width - xMoved
                    let yMove = value.translation.height - yMoved
                    selected.move(to: Display.Position(x: Int(CGFloat(selected.position.x) + xMove * editor.scale), y: Int(CGFloat(selected.position.y) + yMove * editor.scale)))
                    //                    editor.width = proxy.size.width
                    //                    editor.height = proxy.size.height
                    //                        //                            withAnimation(.spring()) {
                    xMoved = value.translation.width
                    yMoved = value.translation.height
                    //                            }
                }
                .onEnded { value in
                    //                    editor.width = proxy.size.width
                    //                                        editor.height = proxy.size.height
                    xMoved = 0
                    yMoved = 0
                    withAnimation(.spring()) {
                        editor.reposition()
                    }
                    editor.moving = false
                    editor.changed = true
                }
        )
        .navigationTitle("Display Organizer")
        .navigationSubtitle(profile?.name ?? "Active")
        .toolbar {
            Button {
                let items = editor.displaysEditing.map(\.configuration)
                var cargs = items.map { UnsafeMutablePointer<Int8>(strdup($0)) }
                setDisplays(Int32(items.count), &cargs)
                editor.reset()
                editor.reposition()
            } label: {
                Label("Apply profile", systemImage: "checkmark.rectangle")
            }
            .help("Apply working profile to device")
            Button {
                guard let display = editor.selected else { return }
                editor.displaysEditing[display.id]?.rotate(to: .left)
                editor.changed = true
            } label: {
                Label("-90°", systemImage: "rotate.left.fill")
            }
            .disabled(editor.selected == nil)
            .help("Rotate 90° to the left")
            Button {
                guard let display = editor.selected else { return }
                editor.displaysEditing[display.id]?.rotate(to: .right)
                editor.changed = true
            } label: {
                Label("+90°", systemImage: "rotate.right.fill")
            }
            .disabled(editor.selected == nil)
            .help("Rotate 90° to the right")
            MenuButton(label: Label("More", systemImage: "ellipsis.circle")) {
                Button {
                    profile?.configuration = editor.displaysEditing.configuration
                    try? viewContext.save()
                } label: {
                    Label("Save profile", systemImage: "square.and.arrow.down")
                }
                .disabled(!editor.changed || profile == nil)
                .help("Save changes to existing profile")
                Button {
                    let profile = Profile(context: viewContext)
                    profile.configuration = editor.displaysEditing.configuration
                    editor.presentedSheet = .profileEdit(profile)
                } label: {
                    Label("Save profile as...", systemImage: "square.and.arrow.down")
                }
                .disabled(!editor.changed)
                .help("Save changes to new profile")
                Divider()
                Button {
                    if let profile = profile {
                        viewContext.delete(profile)
                        try? viewContext.save()
                    }
                } label: {
                    Label("Delete profile", systemImage: "trash")
                }
                .disabled(profile == nil)
                .help("Delete profile")
            }
        }
    }
    
}
