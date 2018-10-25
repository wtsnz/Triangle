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
            10, 0,
            10, 10,
            5, 10,
            5, 5,
            0, 5,
            0, 0
        ]

        let segments: [Int] = [
            0, 1,
            1, 2,
            3, 4,
            4, 5,
            5, 6,
            6, 0
        ]

        for i in 0...1000 {
            Triangle.ConstrainedDelaunay(points: points, segments: segments, holes: [1.5, 2.3])
        }

        XCTAssertTrue(true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testExamplsse() {

        let points: [Double] = [
            0, 0,
            10, 0,
            10, 10,
            5, 10,
            5, 5,
            0, 5,
            0, 0
        ]

        let segments: [Int] = [
            0,
            1,
            2,
            3,
        ]

        for i in 0...1000 {
            Triangle.Delaunay(points: points)
        }

        XCTAssertTrue(true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
