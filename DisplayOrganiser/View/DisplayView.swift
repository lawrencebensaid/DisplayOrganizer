//
//  DisplayView.swift
//  DisplayOrganiser
//
//  Created by Lawrence Bensaid on 24/03/2021.
//

import SwiftUI

struct DisplayView: View {
    
    private let display: Display
    private let placeholder: Bool
    private let mouse: Bool
    
    init(_ display: Display, placeholder: Bool = false, mouse: Bool = false) {
        self.display = display
        self.placeholder = placeholder
        self.mouse = mouse
    }
    
    var body: some View {
        ZStack {
            if placeholder {
                Color(.systemGray)
            } else {
                Color(.sRGB, red: 99/255, green: 157/255, blue: 214/255, opacity: 1)
            }
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(display.position.x), \(display.position.y)")
                        .padding(2)
                        .scaleEffect(0.7)
                    Spacer()
                    if mouse {
                        Image(systemName: "cursorarrow")
                            .padding(5)
                            .help("Mouse cursor is currently positioned inside this display")
                    }
                }
                Spacer()
            }
            VStack(spacing: 8) {
                Text("\(display.resolution.description)")
                    .bold()
                Text("\(display.orientation.rawValue)°")
                    .bold()
            }
        }
        .foregroundColor(.white)
        .border(.black, width: 2)
        .opacity(placeholder ? 0.7 : 1)
    }
    
}
