//
//  TriangulateIO.swift
//  Triangle
//
//  Created by Will Townsend on 2018-10-27.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import Foundation
import LibTriangle

class TriangulateIO {
    let context: UnsafeMutablePointer<triangulateio>

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
        let count = Int(context.pointee.numberoftriangles) * 3
        let values = Array(UnsafeBufferPointer(start: context.pointee.trianglelist, count: count))
        return values
    }

    var flatPoints: [Double] {
        let count = Int(context.pointee.numberofpoints) * 2
        let values = Array(UnsafeBufferPointer(start: context.pointee.pointlist, count: count))
        return values
    }

    var points: [CGPoint] {
        let values = flatPoints
        var points = [CGPoint]()
        for index in stride(from: 0, to: values.count, by: 2) {
            let x = CGFloat(values[index])
            let y = CGFloat(values[index + 1])
            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        return points
    }
}
