//
//  DisplayTests.swift
//  DisplayOrganiserTests
//
//  Created by Lawrence Bensaid on 5/30/22.
//

import XCTest
@testable import DisplayOrganiser

class DisplayTests: XCTestCase {
    
    func testInRange() throws {
        let d1 = Display(resolution: .fullHD, position: Display.Position(x: 0, y: 0))
        let d2 = Display(resolution: .hd, position: Display.Position(x: 800, y: 800))
        let d3 = Display(resolution: .hd, position: Display.Position(x: 1921, y: 800))
        XCTAssertTrue(d1.inRange(d2.position.toNSPoint))
        XCTAssertFalse(d1.inRange(d3.position.toNSPoint))
    }
    
}
