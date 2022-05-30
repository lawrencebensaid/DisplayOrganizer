//
//  Int.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 5/29/22.
//

import Foundation

infix operator %%

extension Int {
    
    static  func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
    
}
