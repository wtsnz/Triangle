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

    func testConformingDelaunay() {

        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 5),
            CGPoint(x: 5, y: 5),
            CGPoint(x: 5, y: 10),
            CGPoint(x: 0, y: 10),

            CGPoint(x: 1, y: 1),
            CGPoint(x: 4, y: 1),
            CGPoint(x: 4, y: 4),
            CGPoint(x: 1, y: 4),

            CGPoint(x: 6, y: 4),
            CGPoint(x: 6, y: 1),
            CGPoint(x: 9, y: 1),
            CGPoint(x: 9, y: 4),
            ]

        let segments: [Int] = [
            0, 1,
            1, 2,
            2, 3,
            3, 4,
            4, 5,
            5, 0,

            6, 7,
            7, 8,
            8, 9,
            9, 6,

            10, 11,
            11, 12,
            12, 13,
            13, 10
        ]

        let holes: [CGPoint] = [
            CGPoint(x: 2.5, y: 2.5),
            CGPoint(x: 7.5, y: 2.5),
        ]

        let triangles = Triangulate.ConformingDelaunay(points: points, segments: segments, holes: holes)

        if let image = DebugTriangulation(triangles: triangles) {
            if let data = image.pngData() {
                let url = URL(fileURLWithPath: NSTemporaryDirectory() + "ConformingDelaunay" + "-triangles.png")
                print(url)
                dump(url)
                try? data.write(to: url)
            }
        }

        XCTAssertEqual(triangles.count, 38)
    }

    func testConstrainedDelaunay() {

        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 5),
            CGPoint(x: 5, y: 5),
            CGPoint(x: 5, y: 10),
            CGPoint(x: 0, y: 10),

            CGPoint(x: 1, y: 1),
            CGPoint(x: 4, y: 1),
            CGPoint(x: 4, y: 4),
            CGPoint(x: 1, y: 4),

            CGPoint(x: 6, y: 4),
            CGPoint(x: 6, y: 1),
            CGPoint(x: 9, y: 1),
            CGPoint(x: 9, y: 4),
        ]

        let segments: [Int] = [
            0, 1,
            1, 2,
            2, 3,
            3, 4,
            4, 5,
            5, 0,

            6, 7,
            7, 8,
            8, 9,
            9, 6,

            10, 11,
            11, 12,
            12, 13,
            13, 10
        ]

        let holes: [CGPoint] = [
            CGPoint(x: 2.5, y: 2.5),
            CGPoint(x: 7.5, y: 2.5),
        ]

        let triangles = Triangulate.ConstrainedDelaunay(points: points, segments: segments, holes: holes)

        if let image = DebugTriangulation(triangles: triangles) {
            if let data = image.pngData() {
                let url = URL(fileURLWithPath: NSTemporaryDirectory() + "ConstrainedDelaunay" + "-triangles.png")
                print(url)
                dump(url)
                try? data.write(to: url)
            }
        }

        XCTAssertEqual(triangles.count, 16)
    }

    func testDelaunay() {

        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 10),
            CGPoint(x: 0, y: 10)
        ]

        let triangles = Triangulate.Delaunay(points: points)

        XCTAssertEqual(triangles.count, 2)
    }

}
