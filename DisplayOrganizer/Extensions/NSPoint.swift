//
//  NSPoint.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 5/29/22.
//

import Foundation

extension NSPoint {
    
    static func +(lhs: NSPoint, rhs: NSPoint) -> NSPoint {
        NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: NSPoint, rhs: NSPoint) -> NSPoint {
        NSPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
}
