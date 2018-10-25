//
//  Triangle.swift
//  Triangle
//
//  Created by Will Townsend on 2018-10-24.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import Foundation
import LibTriangle

private class TriangulateIO {
    fileprivate let context: UnsafeMutablePointer<triangulateio>

    init() {
        context = UnsafeMutablePointer<triangulateio>.allocate(capacity: 1)
        context.initialize(to: triangulateio())
    }

    deinit {
        context.deinitialize(count: 1)
        context.deallocate()
    }

    func setPoints(points: [Double]) {
        let pointsPointer = UnsafeMutablePointer<Double>.allocate(capacity: points.count)
        pointsPointer.initialize(from: points, count: points.count)
        context.pointee.pointlist = pointsPointer
        context.pointee.numberofpoints = Int32(points.count / 2)
    }

    func setSegments(segments: [Int32]) {
        // Indexes of the points
        let pointer = UnsafeMutablePointer<Int32>.allocate(capacity: segments.count)
        pointer.initialize(from: segments, count: segments.count)
        context.pointee.segmentlist = pointer
        context.pointee.numberofsegments = Int32(segments.count / 2)
    }

    func setHoles(holes: [Double]) {
        // holes are points that lie in a triangle that indicate holes
        // [x1, y1, x2, y2]

        let pointer = UnsafeMutablePointer<Double>.allocate(capacity: holes.count)
        pointer.initialize(from: holes, count: holes.count)
        context.pointee.holelist = pointer
        context.pointee.numberofholes = Int32(holes.count / 2)
    }

    var triangles: [Int32] {
        let numberOfTriangles = Int(context.pointee.numberoftriangles) * 3
        let triangles = Array(UnsafeBufferPointer(start: context.pointee.trianglelist, count: numberOfTriangles))
        return triangles
    }
}

public class Triangle {

    static func Delaunay(points: [Double]) {

        let a = TriangulateIO()
        a.setPoints(points: points)

        let b = TriangulateIO()

        let arguments = CString("Qz")
        triangulate(arguments.buffer, a.context, b.context, nil)
        dump(b.triangles)
    }

    static func ConstrainedDelaunay(points: [Double], segments: [Int], holes: [Double]) {

        let points = points
        let segments = segments.map({ Int32($0) })
        let holes = holes

        let a = TriangulateIO()
        a.setPoints(points: points)
        a.setSegments(segments: segments)
        a.setHoles(holes: holes)

        let b = TriangulateIO()

        let arguments = CString("Qzp")
        triangulate(arguments.buffer, a.context, b.context, nil)
        dump(b.triangles)
    }

}

class CString {
    private let _len: Int
    let buffer: UnsafeMutablePointer<Int8>

    init(_ string: String) {
        (_len, buffer) = string.withCString {
            let len = Int(strlen($0) + 1)
            let dst = strcpy(UnsafeMutablePointer<Int8>.allocate(capacity: len), $0)
            return (len, dst!)
        }
    }

    deinit {
        buffer.deallocate()
    }
}
