//
//  DisplayDetailView.swift
//  DisplayOrganiser
//
//  Created by Lawrence Bensaid on 5/29/22.
//

import SwiftUI

struct DisplayDetailView: View {
    
    private let display: Display
    
    public init(_ display: Display) {
        self.display = display
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(display.resolution.description)
            Text("\(display.orientation.description) (\(display.orientation.rawValue)°)")
            if let refreshRate = display.refreshRate {
                Text("\(refreshRate)hz")
            }
        }
    }
    
}

struct DisplayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayDetailView(.preview)
    }
}
