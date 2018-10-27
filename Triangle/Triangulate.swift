//
//  Triangulate.swift
//  Triangle
//
//  Created by Will Townsend on 2018-10-27.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import Foundation
import LibTriangle

public class Triangulate {

    // MARK: - Delaunay

    /// Perform a Delaunay trianglulation on a flat array of points.
    ///
    /// - Parameters:
    ///    - points: The points to triangulate. They should be in the format matching [x1, y1, x2, y2, ...]
    ///
    /// - Returns:
    ///   An array of indicies that represent triangles based on the input points array. The triangles are in CCW order.
    public static func Delaunay(points: [Double]) -> [Int] {

        let input = TriangulateIO()
        input.setPoints(points: points)

        let output = TriangulateIO()
        let arguments = CString("Qz")

        triangulate(arguments.buffer, input.context, output.context, nil)

        return output.triangles.map({ Int($0) })
    }

    /// Perform a Delaunay trianglulation on an array of points.
    ///
    /// - Parameters:
    ///    - points: The points to triangulate.
    ///
    /// - Returns:
    ///   An array of triangles based on the input points array.
    public static func Delaunay(points: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let triangleIndices = Delaunay(points: flattenedPoints)
        return ConvertPointsToTriangles(with: points, triangleIndices: triangleIndices)
    }

    // MARK: - Constrained Delaunay

    /// Perform a Constrained Delaunay trianglulation on an array of points.
    ///
    /// ConstrainedDelaunay computes the constrained Delaunay triangulation
    /// of a planar straight line graph with the given vertices, edges and holes.
    /// The given segments are retained as such in the traingulation, hence
    /// not all triangles are Delaunay.
    ///
    /// - Parameters:
    ///    - points: The points to triangulate.
    ///    - segments: The segments to be constrained.
    ///    - holes: Points where holes are desired.
    ///
    /// - Returns:
    ///   An array of triangles.
    public static func ConstrainedDelaunay(points: [CGPoint], segments: [Int], holes: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let flattenedHoles = holes
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let (points, triangleIndices) = ConstrainedDelaunay(points: flattenedPoints, segments: segments, holes: flattenedHoles)

        return ConvertFlatPointsToTriangles(with: points, triangleIndices: triangleIndices)
    }

    /// Perform a Constrained Delaunay trianglulation on a flat array of points.
    ///
    /// ConstrainedDelaunay computes the constrained Delaunay triangulation
    /// of a planar straight line graph with the given vertices, edges and holes.
    /// The given segments are retained as such in the traingulation, hence
    /// not all triangles are Delaunay.
    ///
    /// - Parameters:
    ///    - points: The flattened points to triangulate ([x1, y1, x2, y2, ...])
    ///    - segments: The segments to be constrained.
    ///    - holes: The flattened points where holes are desired ([x1, y1, x2, y2, ...])
    ///
    /// - Returns:
    ///   An array of flattened points ([x1, y1, x2, y2, ...]) and the indicies of points
    ///   to make up the triangles.
    public static func ConstrainedDelaunay(points: [Double], segments: [Int], holes: [Double]) -> (points: [Double], triangles: [Int]) {

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

        return (points: output.flatPoints, triangles: triangles)
    }

    // MARK: - Conforming Delaunay

    /// Perform a Conforming Delaunay trianglulation on an array of points.
    ///
    /// Conforming Delaunay computes the true Delaunay triangulation of a planar
    /// straight line graph with the given vertices, edges and holes.
    /// New vertices (Steiner points) may be inserted to ensure that the resulting
    /// triangles are all Delaunay.
    ///
    /// - Parameters:
    ///    - points: The points to triangulate.
    ///    - segments: The segments to be constrained.
    ///    - holes: Points where holes are desired.
    ///
    /// - Returns:
    ///   An array of triangles.
    public static func ConformingDelaunay(points: [CGPoint], segments: [Int], holes: [CGPoint]) -> [Triangle] {

        let flattenedPoints = points
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let flattenedHoles = holes
            .flatMap({ [$0.x, $0.y] })
            .map({ Double($0) })

        let (points, triangleIndices) = ConformingDelaunay(points: flattenedPoints, segments: segments, holes: flattenedHoles)

        return ConvertFlatPointsToTriangles(with: points, triangleIndices: triangleIndices)
    }

    /// Perform a Conforming Delaunay trianglulation on a flat array of points.
    ///
    /// Conforming Delaunay computes the true Delaunay triangulation of a planar
    /// straight line graph with the given vertices, edges and holes.
    /// New vertices (Steiner points) may be inserted to ensure that the resulting
    /// triangles are all Delaunay.
    ///
    /// - Parameters:
    ///    - points: The flattened points to triangulate ([x1, y1, x2, y2, ...])
    ///    - segments: The segments to be constrained.
    ///    - holes: The flattened points where holes are desired ([x1, y1, x2, y2, ...])
    ///
    /// - Returns:
    ///   An array of flattened points ([x1, y1, x2, y2, ...]) and the indicies of points
    ///   to make up the triangles.
    public static func ConformingDelaunay(points: [Double], segments: [Int], holes: [Double]) -> (points: [Double], triangles: [Int]) {

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
        return (points: output.flatPoints, triangles: triangles)
    }

    // MARK: - Helper Functions

    public static func ConvertFlatPointsToTriangles(with points: [Double], triangleIndices: [Int]) -> [Triangle] {

        var allPoints = [CGPoint]()
        for index in stride(from: 0, to: points.count, by: 2) {
            let x = CGFloat(points[index])
            let y = CGFloat(points[index + 1])

            let point = CGPoint(x: x, y: y)
            allPoints.append(point)
        }

        return ConvertPointsToTriangles(with: allPoints, triangleIndices: triangleIndices)
    }

    public static func ConvertPointsToTriangles(with points: [CGPoint], triangleIndices: [Int]) -> [Triangle] {

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
