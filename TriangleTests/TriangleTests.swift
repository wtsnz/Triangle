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

    func testA() {
        let points = [
            0.200000, -0.776400,
            0.220000, -0.773200,
            0.245600, -0.756400,
            0.277600, -0.702000,
            0.488800, -0.207600,
            0.504800, -0.207600,
            0.740800, -0.7396,
            0.756000, -0.761200,
            0.774400, -0.7724,
            0.800000, -0.776400,
            0.800000, -0.792400,
            0.579200, -0.792400,
            0.579200, -0.776400,
            0.621600, -0.771600,
            0.633600, -0.762800,
            0.639200, -0.744400,
            0.620800, -0.684400,
            0.587200, -0.604400,
            0.360800, -0.604400,
            0.319200, -0.706800,
            0.312000, -0.739600,
            0.318400, -0.761200,
            0.334400, -0.771600,
            0.371200, -0.776400,
            0.371200, -0.792400,
            0.374400, -0.570000,
            0.574400, -0.5700,
            0.473600, -0.330800,
            0.200000, -0.792400
        ]

        let segments = [
            28, 0,
            0, 1,
            1, 2,
            2, 3,
            3, 4,
            4, 5,
            5, 6,
            6, 7,
            7, 8,
            8, 9,
            9, 10,
            10, 11,
            11, 12,
            12, 13,
            13, 14,
            14, 15,
            15, 16,
            16, 17,
            17, 18,
            18, 19,
            19, 20,
            20, 21,
            21, 22,
            22, 23,
            23, 24,
            24, 28,
            25, 26,
            26, 27,
            27, 25
        ]

        let holes = [
            0.47, -0.5,
        ]

        let (trianglePoints, triangleIndicies) = Triangulate.ConstrainedDelaunay(points: points, segments: segments, holes: holes)

        let triangles = Triangulate.ConvertFlatPointsToTriangles(with: trianglePoints, triangleIndices: triangleIndicies)

        XCTAssertEqual(triangles.count, 29)

    }

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
