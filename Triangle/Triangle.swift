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
        let count = Int(context.pointee.numberoftriangles) * 3
        let values = Array(UnsafeBufferPointer(start: context.pointee.trianglelist, count: count))
        return values
    }

    var points: [Double] {
        let count = Int(context.pointee.numberofpoints) * 2
        let values = Array(UnsafeBufferPointer(start: context.pointee.pointlist, count: count))
        return values
    }

    var points2: [CGPoint] {
        let count = Int(context.pointee.numberofpoints) * 2
        let values = Array(UnsafeBufferPointer(start: context.pointee.pointlist, count: count))

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


import Foundation
import CoreGraphics
import UIKit

extension Array where Element == CGPoint {

    var bounds: CGRect {

        guard !isEmpty else {
            return .zero
        }

        guard count > 1 else {
            let first = self.first!
            return CGRect(x: first.x, y: first.y, width: 0, height: 0)
        }

        var lowX = CGFloat(Double.greatestFiniteMagnitude)
        var lowY = CGFloat(Double.greatestFiniteMagnitude)

        var highX = CGFloat(Double.leastNormalMagnitude)
        var highY = CGFloat(Double.leastNormalMagnitude)

        for point in self {
            lowX = Swift.min(lowX, point.x)
            lowY = Swift.min(lowY, point.y)
            highX = Swift.max(highX, point.x)
            highY = Swift.max(highY, point.y)
        }

        return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
    }
}


private func DebugTriangulation(points: [Double], trianglesIndices: [Int], scaleFactor: CGFloat = CGFloat(20.0)) {

    var allPoints = [CGPoint]()
    for index in stride(from: 0, to: points.count, by: 2) {
        let x = CGFloat(points[index])
        let y = CGFloat(points[index + 1])

        let point = CGPoint(x: x * scaleFactor, y: -y * scaleFactor)
        allPoints.append(point)
    }

    /// The bounds of this polygon.
    let bounds = allPoints.bounds

    allPoints = allPoints.map { CGPoint(x: $0.x + bounds.width / 2, y: $0.y + bounds.height) }

    // Debug the points. Generate an image of each vertex and figure out why it's not working.
    let size = CGSize(width: bounds.width * 2, height: bounds.height * 2)

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(1.0)
    UIColor.blue.withAlphaComponent(0.6).setStroke()
    UIColor.blue.withAlphaComponent(0.6).setFill()

    for index in stride(from: 0, to: trianglesIndices.count, by: 3) {

        let pointIndexA = trianglesIndices[index]
        let pointIndexB = trianglesIndices[index + 1]
        let pointIndexC = trianglesIndices[index + 2]

        let pointA = allPoints[pointIndexA]
        let pointB = allPoints[pointIndexB]
        let pointC = allPoints[pointIndexC]

        let bezierPath = UIBezierPath()
        bezierPath.miterLimit = 0
        bezierPath.usesEvenOddFillRule = true
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointA)
        bezierPath.close()

        UIColor.blue.withAlphaComponent(0.4).setFill()
        UIColor.blue.withAlphaComponent(0.8).setStroke()

        bezierPath.fill()
        bezierPath.stroke()
    }

    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    if let data = img?.pngData() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "sds" + "-triangles.png")
        print(url)
        dump(url)
        try? data.write(to: url)
    }

}

func DebugTriangulation(triangles: [Triangle], scaleFactor: CGFloat = CGFloat(20.0)) -> UIImage? {

    var allPoints = triangles.flatMap({ [$0.a, $0.b, $0.c] })
        .map { CGPoint(x: $0.x * scaleFactor, y: -$0.y * scaleFactor) }

    /// The bounds of this polygon.
    let bounds = allPoints.bounds

    allPoints = allPoints.map { CGPoint(x: $0.x + bounds.width / 2, y: $0.y + bounds.height * 1.5) }

    // Debug the points. Generate an image of each vertex and figure out why it's not working.
    let size = CGSize(width: bounds.width * 2, height: bounds.height * 2)

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(1.0)
    UIColor.white.withAlphaComponent(0.3).setStroke()
    UIColor.blue.withAlphaComponent(0.6).setFill()

    for index in stride(from: 0, to: allPoints.count, by: 3) {

        let pointA = allPoints[index]
        let pointB = allPoints[index + 1]
        let pointC = allPoints[index + 2]

        let bezierPath = UIBezierPath()
        bezierPath.miterLimit = 0
        bezierPath.usesEvenOddFillRule = true
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointA)
        bezierPath.close()

        bezierPath.fill()
        bezierPath.stroke()
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}


/// A triangle class
///
/// Points a -> b -> c are orientated in counter clockwise order.
public class Triangle {

    public let a: CGPoint
    public let b: CGPoint
    public let c: CGPoint

    init(a: CGPoint, b: CGPoint, c: CGPoint) {
        self.a = a
        self.b = b
        self.c = c
    }

}

public class Triangulate {

    /// Perform a Delaunay trianglulation on an array of points.
    ///
    /// The points are expected to be in the format of [x1, y1, x2, y2, ...]
    /// and you will receive an array of indicies that represent the triangles in CCW order.
    static func Delaunay(points: [Double]) -> [Int] {

        let input = TriangulateIO()
        input.setPoints(points: points)

        let output = TriangulateIO()
        let arguments = CString("Qz")

        triangulate(arguments.buffer, input.context, output.context, nil)

        return output.triangles.map({ Int($0) })
    }

    public static func Delaunay(points: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let triangleIndices = Delaunay(points: flattenedPoints)
        return GenerateTriangles(with: points, triangleIndices: triangleIndices)
    }

    // ConstrainedDelaunay computes the constrained Delaunay triangulation
    // of a planar straight line graph with the given vertices, edges and holes.
    // The given segments are retained as such in the traingulation, hence
    // not all triangles are Delaunay.

    public static func ConstrainedDelaunay(points: [CGPoint], segments: [Int], holes: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let flattenedHoles = holes
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let (points, triangleIndices) = ConstrainedDelaunay(points: flattenedPoints, segments: segments, holes: flattenedHoles)

        return GenerateTriangles(with: points, triangleIndices: triangleIndices)
    }

    private static func ConstrainedDelaunay(points: [Double], segments: [Int], holes: [Double]) -> (points: [Double], triangles: [Int]) {

        let points = points
        let segments = segments.map({ Int32($0) })
        let holes = holes

        let input = TriangulateIO()
        input.setPoints(points: points)
        input.setSegments(segments: segments)
        input.setHoles(holes: holes)

        let output = TriangulateIO()

        let arguments = CString("Qzp")
        triangulate(arguments.buffer, input.context, output.context, nil)

        let triangles = output.triangles.map({ Int($0) })

        return (points: output.points, triangles: triangles)
    }

    // ConformingDelaunay computes the true Delaunay triangulation of a planar
    // straight line graph with the given vertices, edges and holes.
    // New vertices (Steiner points) may be inserted to ensure that the resulting
    // triangles are all Delaunay.
    public static func ConformingDelaunay(points: [CGPoint], segments: [Int], holes: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let flattenedHoles = holes
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let (points, triangleIndices) = ConformingDelaunay(points: flattenedPoints, segments: segments, holes: flattenedHoles)

        return GenerateTriangles(with: points, triangleIndices: triangleIndices)
    }

    private static func ConformingDelaunay(points: [Double], segments: [Int], holes: [Double]) -> (points: [Double], triangles: [Int]) {

        let points = points
        let segments = segments.map({ Int32($0) })
        let holes = holes

        let input = TriangulateIO()
        input.setPoints(points: points)
        input.setSegments(segments: segments)
        input.setHoles(holes: holes)

        let output = TriangulateIO()

        let arguments = CString("QzpD")
        triangulate(arguments.buffer, input.context, output.context, nil)

        let triangles = output.triangles.map({ Int($0) })
        return (points: output.points, triangles: triangles)
    }

    // MARK: - Private Functions

    private static func GenerateTriangles(with points: [Double], triangleIndices: [Int]) -> [Triangle] {

        var allPoints = [CGPoint]()
        for index in stride(from: 0, to: points.count, by: 2) {
            let x = CGFloat(points[index])
            let y = CGFloat(points[index + 1])

            let point = CGPoint(x: x, y: y)
            allPoints.append(point)
        }

        return GenerateTriangles(with: allPoints, triangleIndices: triangleIndices)
    }

    private static func GenerateTriangles(with points: [CGPoint], triangleIndices: [Int]) -> [Triangle] {

        var triangles = [Triangle]()
        for index in stride(from: 0, to: triangleIndices.count, by: 3) {

            let pointIndexA = triangleIndices[index]
            let pointIndexB = triangleIndices[index + 1]
            let pointIndexC = triangleIndices[index + 2]

            let pointA = points[pointIndexA]
            let pointB = points[pointIndexB]
            let pointC = points[pointIndexC]

            let triangle = Triangle(a: pointA, b: pointB, c: pointC)
            triangles.append(triangle)
        }

        return triangles
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
