//
//  DisplayItemView.swift
//  DisplayOrganiser
//
//  Created by Lawrence Bensaid on 5/29/22.
//

import SwiftUI

struct DisplayItemView: View {
    
    @EnvironmentObject private var editor: Editor
    
    @State private var presentDetails = false
    @State private var xMoved: CGFloat = 0
    @State private var yMoved: CGFloat = 0
    private let center: NSPoint
    private let placeholder: Bool
    private let display: Display
    
    public init(_ display: Display, center: NSPoint, placeholder: Bool = false) {
        self.display = display
        self.placeholder = placeholder
        self.center = center
    }
    
    var body: some View {
        let x = CGFloat(display.position.x)
        let y = CGFloat(display.position.y)
        let xOffs = (x + editor.xOffset) / editor.scale
        let yOffs = (y + editor.yOffset) / editor.scale
        let viewCenterX = center.x
        let viewCenterY = center.y
        let focusCenterX = CGFloat(editor.displaysEditing.width) / editor.scale / 2
        let focusCenterY = CGFloat(editor.displaysEditing.height) / editor.scale / 2
        let xCenter = viewCenterX - focusCenterX
        let yCenter = viewCenterY - focusCenterY
        let binding = Binding<Bool> { !placeholder && presentDetails && display == editor.selected } set: { if !$0 { presentDetails = false } }
        DisplayView(display, placeholder: placeholder, mouse: editor.mouse != nil && display.inRange(editor.mouse!))
            .frame(width: CGFloat(display.resolution.width) / editor.scale, height: CGFloat(display.resolution.height) / editor.scale)
            .opacity(editor.moving ? 0.7 : 1)
            .border(Color.accentColor, width: !placeholder && editor.selected?.id == display.id ? 2 : 0)
            .font(.system(size: 100 / editor.scale))
            .environmentObject(editor)
            .animation(.spring(), value: display.resolution)
            .onTapGesture {
                if editor.selected?.id == display.id {
                    presentDetails = true
                } else {
                    editor.selected = display
                }
            }
            .popover(isPresented: binding) {
                DisplayDetailView(display)
                    .padding()
            }
            .offset(x: xOffs + xCenter, y: yOffs + yCenter)
    }
    
}

//struct DisplayItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayItemView()
//    }
//}
