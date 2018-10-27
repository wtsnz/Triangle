//
//  Other.swift
//  Triangle
//
//  Created by Will Townsend on 2018-10-27.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import Foundation

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

public func DebugTriangulation(triangles: [Triangle], scaleFactor: CGFloat = CGFloat(20.0)) -> UIImage? {

    var allPoints = triangles.flatMap({ [$0.a, $0.b, $0.c] })
        .map { CGPoint(x: $0.x * scaleFactor, y: $0.y * scaleFactor) }

    /// The bounds of this polygon.
    let bounds = allPoints.bounds

    allPoints = allPoints.map {
        CGPoint(
            x: $0.x - bounds.minX,
            y: bounds.height - ($0.y - bounds.minY)
        )
    }

    let size = CGSize(width: bounds.width, height: bounds.height)

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
