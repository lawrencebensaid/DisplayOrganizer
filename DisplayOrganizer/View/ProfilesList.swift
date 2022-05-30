//
//  ProfilesList.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 25/03/2021.
//

import SwiftUI

struct ProfilesList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject private var editor: Editor
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Profile.timestamp, ascending: true)], animation: .default)
    private var profiles: FetchedResults<Profile>
    
    @State private var selected: UUID?
    
    private let activeId = UUID()
    
    public init() {
        _selected = State(initialValue: activeId)
    }
    
    var body: some View {
        List(selection: $selected) {
            NavigationLink(
                destination: EditorView()
                    .environmentObject(editor)
                    .onAppear {
                        editor.loadActive()
                        editor.reposition()
                    }
            ) {
                Label("Active", systemImage: "rectangle.3.group.fill")
            }
            .tag(activeId)
            Section {
                ForEach(profiles) { profile in
                    NavigationLink(
                        destination: EditorView(profile)
                            .environmentObject(editor)
                            .onAppear {
                                editor.loadProfile(profile)
                                editor.reposition()
                            }
                    ) {
                        Label(profile.name, systemImage: "rectangle.3.group")
                    }
                    .tag(profile.id)
                    .contextMenu {
                        Button {
                            viewContext.delete(profile)
                            try? viewContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            } header: {
                Text("Profiles")
            }
        }
//        .onAppear {
//            print("Load")
//            selected = activeId
//        }
    }
    
}

struct ProfilesList_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesList()
//            .environmentObject(ProfileContext())
    }
}
