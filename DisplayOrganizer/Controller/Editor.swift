//
//  Editor.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 25/03/2021.
//

import Foundation

class Editor: ObservableObject {
    
    enum PresentedSheet: Identifiable {
        case profileEdit(Profile)
        
        var id: String {
            let mirror = Mirror(reflecting: self)
            if let label = mirror.children.first?.label {
                return label
            } else {
                return "\(self)"
            }
        }
    }
    
    @Published public var presentedSheet: PresentedSheet?
    
    // User interactions
    @Published public var showActive = true
    @Published public var selected: Display?
    
    // Environment
    @Published public private(set) var scale: CGFloat = 10
    @Published public private(set) var xOffset: CGFloat = 0
    @Published public private(set) var yOffset: CGFloat = 0
    @Published public var changed = false
    @Published public var moving = false
    
//    @Published public private(set) var scaleRatio: CGFloat = 1
    
    /// Displays in the in the current editing session
    @Published public private(set) var displaysEditing: [Display] = []
    
    /// Displays in the current active configuration of the device
    @Published public private(set) var displaysActive: [Display] = []
    
    @Published public private(set) var width: CGFloat = 500
    @Published public private(set) var height: CGFloat = 400
    
    @Published public var mouse: NSPoint?
    
    private var profile: Profile?
    
    public func refresh() {
        guard let pointer = currentProfile() else { return }
        let strings: [String] = String(cString: pointer).trimmingCharacters(in: .newlines).components(separatedBy: "\n")
        displaysActive = strings.compactMap(Display.init)
    }
    
    public func reset() {
        if let profile = profile {
            displaysEditing = profile.displays
        } else {
            displaysEditing = displaysActive.compactMap { Display($0.configuration) }
        }
        selected = nil
        changed = false
    }
    
    public func reposition() {
        xOffset = 0
        yOffset = 0
        scale = CGFloat(displaysEditing.width) / width + 2
//        scaleRatio = CGFloat(displaysEditing.width) / 3046
        for display in displaysEditing {
            let x = display.position.x
            let y = display.position.y
            if CGFloat(x) < -xOffset {
                xOffset = CGFloat(-x)
            }
            if CGFloat(y) < -yOffset {
                yOffset = CGFloat(-y)
            }
        }
    }
    
    public func loadActive() {
        profile = nil
        refresh()
        reset()
    }
    
    public func loadProfile(_ profile: Profile) {
        self.profile = profile
        reset()
    }
    
}
