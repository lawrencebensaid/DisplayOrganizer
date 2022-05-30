//
//  Array.extension.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 24/03/2021.
//

import Foundation

extension Array where Element == Display {
    
    subscript(id: UUID) -> Display? {
        get {
            for display in self {
                if display.id == id {
                    return display
                }
            }
            return nil
        }
        set {
            guard let newValue = newValue else { return }
            for i in 0..<self.count {
                if self[i].id == id {
                    self[i] = newValue
                }
            }
        }
    }
    
    var configuration: String { self.map(\.configuration).joined(separator: ";") }
    
    var width: Int {
        var lowest = 0
        for display in self {
            if display.position.x < lowest {
                lowest = display.position.x
            }
        }
        var highest = 0
        for display in self {
            let sum = display.position.x + display.resolution.width
            if sum > highest {
                highest = sum
            }
        }
        return highest - lowest
    }
    
    var height: Int {
        var lowest = 0
        for display in self {
            if display.position.y < lowest {
                lowest = display.position.y
            }
        }
        var highest = 0
        for display in self {
            let sum = display.position.y + display.resolution.height
            if sum > highest {
                highest = sum
            }
        }
        return highest - lowest
    }
    
}
