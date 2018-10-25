//
//  TriangleTests.swift
//  TriangleTests
//
//  Created by Will Townsend on 2018-10-24.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import XCTest
@testable import Triangle

class TriangleTests: XCTestCase {

    func testExample() {

        let points: [Double] = [
            0, 0,
            1, 0,
            1, 1,
            0, 1,
        ]

        let segments: [Int] = [
            0,
            1,
            2,
            3,
        ]

        for i in 0...1000 {
            Triangle.Delaunay(points: points, segments: segments, holes: [])
        }



        XCTAssertTrue(true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
