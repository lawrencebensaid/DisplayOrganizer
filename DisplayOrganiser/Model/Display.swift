//
//  Display.swift
//  DisplayOrganiser
//
//  Created by Lawrence Bensaid on 24/03/2021.
//

import Foundation

class Display: Identifiable {
    
    public var configuration: String {
        var hzString = ""
        if let hz = refreshRate {
            hzString = " h:\(hz)"
        }
        return "i:\(id.uuidString) r:\(resolution)\(hzString) c:\(colorDepth) s:\(scaling ? "on" : "off") o:\(position) d:\(orientation.rawValue)"
    }
    
    enum MoveDirection { case left, right, up, down }
    enum RotateDirection { case left, right }
    
    struct Position: CustomStringConvertible {
        
        public static let zero = Position(x: 0, y: 0)
        
        public var description: String { "\(x),\(y)" }
        
        public var toNSPoint: NSPoint { .init(x: x, y: y) }
        
        public let x: Int
        public let y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        public init?(_ string: String) {
            let values: [String] = string.components(separatedBy: ",")
            guard values.count == 2, let x = Int(values[0]), let y = Int(values[1]) else { return nil }
            self.init(x: x, y: y)
        }
        
    }
    
    struct Resolution: Equatable, CustomStringConvertible {
        
        public static let hd = Resolution(width: 1280, height: 720)
        public static let hdLite1280 = Resolution(width: 1280, height: 1080)
        public static let hdLite1440 = Resolution(width: 1440, height: 1080)
        public static let fullHD = Resolution(width: 1920, height: 1080)
        public static let ultraHD4K = Resolution(width: 3840, height: 2160)
        public static let ultraHD8K = Resolution(width: 7680, height: 4320)
        
        public var width: Int
        public var height: Int
        
        public var description: String { "\(width)x\(height)" }
        
        static func +=(lhs: inout Resolution, rhs: Resolution) {
            lhs = lhs + rhs
        }
        
        static func +(lhs: Resolution, rhs: Resolution) -> Resolution {
            return Resolution(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
        }
        
        static func -(lhs: Resolution, rhs: Resolution) -> Resolution {
            return Resolution(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
        }
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
        
        public init?(_ string: String) {
            let values: [String] = string.components(separatedBy: "x")
            guard values.count == 2, let width = Int(values[0]), let height = Int(values[1]) else { return nil }
            self.init(width: width, height: height)
        }
        
        public func flipped() -> Resolution {
            Resolution(width: height, height: width)
        }
        
    }
    
    enum Orientation: Int {
        case landscape = 0
        case portrait = 90
        case landscapeFlipped = 180
        case portraitFlipped = 270
        
        var description: String {
            switch self {
            case .landscape: return "Landscape"
            case .portrait: return "Portrait"
            case .landscapeFlipped: return "Landscape flipped"
            case .portraitFlipped: return "Portrait flipped"
            }
        }
    }
    
    public let id: UUID
    public private(set) var position: Position
    public private(set) var resolution: Resolution
    public private(set) var orientation: Orientation
    public private(set) var refreshRate: Int?
    public private(set) var colorDepth: Int
    public private(set) var scaling: Bool
    
    public init(id: UUID = UUID(), resolution: Resolution = .fullHD, position: Position = .zero, orientation: Orientation = .landscape, refreshRate: Int? = nil, colorDepth: Int = 0, scaling: Bool = true) {
        self.id = id
        self.resolution = resolution
        self.refreshRate = refreshRate
        self.colorDepth = colorDepth
        self.scaling = scaling
        self.position = position
        self.orientation = orientation
    }
    
    public convenience init?(_ string: String) {
        var properties: [String: String] = [:]
        let attributes: [String] = string.components(separatedBy: " ")
        for attribute in attributes {
            let keyvalue: [String] = attribute.components(separatedBy: ":")
            if keyvalue.count == 2 {
                properties[keyvalue[0]] = keyvalue[1]
            }
        }
        guard
            let id = UUID(uuidString: properties["i"] ?? ""),
            let resolution = Resolution(properties["r"] ?? ""),
            let colorDepth = Int(properties["c"] ?? ""),
            let scaling = properties["s"],
            let position = Position(properties["o"] ?? ""),
            let degrees = Int(properties["d"] ?? ""),
            let orientation = Orientation(rawValue: degrees)
        else { print("Parse failure: \"\(string)\""); return nil }
        self.init(id: id, resolution: resolution, position: position, orientation: orientation, refreshRate: Int(properties["h"] ?? ""), colorDepth: colorDepth, scaling: scaling != "off")
    }
    
    public func inRange(_ point: NSPoint) -> Bool {
        let xIn = point.x >= CGFloat(position.x) && point.x <= CGFloat(position.x + resolution.width)
        let yIn = point.y >= CGFloat(position.y) && point.y <= CGFloat(position.y + resolution.height)
        return xIn && yIn
    }
    
    public func rotate(to direction: RotateDirection) {
        switch direction {
        case .left:
            if let orientation = Orientation(rawValue: (orientation.rawValue - 90) %% 360) {
                self.orientation = orientation
                resolution = resolution.flipped()
            }
        case .right:
            if let orientation = Orientation(rawValue: (orientation.rawValue + 90) %% 360) {
                self.orientation = orientation
                resolution = resolution.flipped()
            }
        }
    }
    
    public func move(to direction: MoveDirection, by units: Int) {
        switch direction {
        case .left:
            position = Position(x: position.x - units, y: position.y)
        case .right:
            position = Position(x: position.x + units, y: position.y)
        case .up:
            position = Position(x: position.x, y: position.y - units)
        case .down:
            position = Position(x: position.x, y: position.y + units)
        }
    }
    
    public func move(to position: Position) {
        self.position = position
    }
    
    // MARK: - Preview
    
    public static let preview = Display()
    
}

extension Display: CustomStringConvertible {
    
    public var description: String {
        "id:\(id) resolution:\(resolution) position:\(position)"
    }
    
}

extension Display: Equatable {
    
    static func == (lhs: Display, rhs: Display) -> Bool {
        lhs.configuration == rhs.configuration
    }
    
}
