//
//  ProfileEditView.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 5/29/22.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Environment(\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name = ""
    private var profile: Profile
    
    public init(_ profile: Profile) {
        self.profile = profile
    }
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("New Profile")
                    .bold()
                    .font(.title2)
                Spacer()
                TextField("Name", text: $name) {
                    print("ENTER")
                }
                .textFieldStyle(.roundedBorder)
                .controlSize(.large)
                Spacer()
            }
        }
        .padding()
        .frame(width: 250, height: 100)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    profile.timestamp = Date()
                    profile.name = name
                    do {
                        try viewContext.save()
                        presentation.wrappedValue.dismiss()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView()
//    }
//}
