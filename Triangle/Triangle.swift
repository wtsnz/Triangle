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
    var context: triangulateio

    init() {
        context = triangulateio()
        context.edgelist = nil
        context.edgemarkerlist = nil
        context.holelist = nil
        context.neighborlist = nil
        context.normlist = nil
        context.numberofcorners = 0
        context.numberofedges = 0
        context.numberofholes = 0
        context.numberofpointattributes = 0
        context.numberofpoints = 0
        context.numberofregions = 0
        context.numberofsegments = 0
        context.numberoftriangleattributes = 0
        context.numberoftriangles = 0
        context.pointattributelist = nil
        context.pointlist = nil
        context.pointmarkerlist = nil
        context.regionlist = nil
        context.segmentlist = nil
        context.segmentmarkerlist = nil
        context.trianglearealist = nil
        context.triangleattributelist = nil
        context.trianglelist = nil
    }

    deinit {
//        context
    }

    var points: [[Double]] = []

    func setPoints(points: [[Double]]) {
        self.points = points

        context.pointlist = UnsafeMutablePointer(&self.points[0])
        context.numberofpoints = Int32(points.count)
    }
}

public class Triangle {

    static func Delaunay(points: [Double], segments: [Int], holes: [Int]) {


//        var inputs = triangulateio()
//        memset(&inputs, 0, MemoryLayout<triangulateio>.size)

//        var outputs = triangulateio()
//        memset(&outputs, 0, MemoryLayout<triangulateio>.size)


//        t.ct.pointlist = (*C.double)(unsafe.Pointer(&pts[0]))
//        t.ct.numberofpoints = C.int(len(pts))

//        let po = UnsafeMutablePointer<Double>(points[0][0])

        var points = points
        let segments = segments.map({ Int32($0) })
        var holes = holes.map({ Int32($0) })

//        var inputs = triangulateio(
//            pointlist: nil,
//            pointattributelist: nil,
//            pointmarkerlist: nil,
//            numberofpoints: 0,
//            numberofpointattributes: 0,
//            trianglelist: nil,
//            triangleattributelist: nil,
//            trianglearealist: nil,
//            neighborlist: nil,
//            numberoftriangles: 0,
//            numberofcorners: 0,
//            numberoftriangleattributes: 0,
//            segmentlist: nil,
//            segmentmarkerlist: nil,
//            numberofsegments: 0,
//            holelist: nil,
//            numberofholes: 0,
//            regionlist: nil,
//            numberofregions: 0,
//            edgelist: nil,
//            edgemarkerlist: nil,
//            normlist: nil,
//            numberofedges: 0
//        )

//        inputs.edgelist = nil
//        inputs.edgemarkerlist = nil
//        inputs.holelist = nil
//        inputs.neighborlist = nil
//        inputs.normlist = nil
//        inputs.numberofcorners = 0
//        inputs.numberofedges = 0
//        inputs.numberofholes = 0
//        inputs.numberofpointattributes = 0
//        inputs.numberofpoints = 0
//        inputs.numberofregions = 0
//        inputs.numberofsegments = 0
//        inputs.numberoftriangleattributes = 0
//        inputs.numberoftriangles = 0
//        inputs.pointattributelist = nil
//        inputs.pointlist = nil
//        inputs.pointmarkerlist = nil
//        inputs.regionlist = nil
//        inputs.segmentlist = nil
//        inputs.segmentmarkerlist = nil
//        inputs.trianglearealist = nil
//        inputs.triangleattributelist = nil
//        inputs.trianglelist = nil
//
//
//        var marskers = Array<Int32>.init(repeating: 0, count: points.count)
//
//        inputs.pointlist = UnsafeMutablePointer(&points[0])
//        inputs.numberofpoints = Int32(points.count)
//        inputs.pointattributelist = nil

//        let markers = Array<Int32>.init(repeating: 0, count: points.count)
//        inputs.pointmarkerlist = UnsafeMutablePointer(markers[0])
//            t.ct.pointmarkerlist = (*C.int)(unsafe.Pointer(&markers[0]))

//        inputs.pointmarkerlist = nil
//        inputs.segmentmarkerlist = nil
//        inputs.edgelist = nil
//        inputs.regionlist = nil
//        inputs.trianglelist = nil
//        inputs.holelist = nil
//        inputs.neighborlist = nil
//        inputs.normlist = nil
//        inputs.numberoftriangles = 0
//        inputs.numberofsegments = 0



//        var input = UnsafeMutablePointer(&inputs)

//        input.pointee.pointlist = UnsafeMutablePointer(&points[0])
//        input.pointee.numberofpoints = Int32(points.count)

//        input.pointee.segmentlist = UnsafeMutablePointer(&segments)
//        input.pointee.numberofsegments = Int32(segments.count)

//        var outputs = triangulateio(
//            pointlist: nil,
//            pointattributelist: nil,
//            pointmarkerlist: nil,
//            numberofpoints: 0,
//            numberofpointattributes: 0,
//            trianglelist: nil,
//            triangleattributelist: nil,
//            trianglearealist: nil,
//            neighborlist: nil,
//            numberoftriangles: 0,
//            numberofcorners: 0,
//            numberoftriangleattributes: 0,
//            segmentlist: nil,
//            segmentmarkerlist: nil,
//            numberofsegments: 0,
//            holelist: nil,
//            numberofholes: 0,
//            regionlist: nil,
//            numberofregions: 0,
//            edgelist: nil,
//            edgemarkerlist: nil,
//            normlist: nil,
//            numberofedges: 0
//        )

//        outputs.edgelist = nil
//        outputs.edgemarkerlist = nil
//        outputs.holelist = nil
//        outputs.neighborlist = nil
//        outputs.normlist = nil
//        outputs.numberofcorners = 0
//        outputs.numberofedges = 0
//        outputs.numberofholes = 0
//        outputs.numberofpointattributes = 0
//        outputs.numberofpoints = 0
//        outputs.numberofregions = 0
//        outputs.numberofsegments = 0
//        outputs.numberoftriangleattributes = 0
//        outputs.numberoftriangles = 0
//        outputs.pointattributelist = nil
//        outputs.pointlist = nil
//        outputs.pointmarkerlist = nil
//        outputs.regionlist = nil
//        outputs.segmentlist = nil
//        outputs.segmentmarkerlist = nil
//        outputs.trianglearealist = nil
//        outputs.triangleattributelist = nil
//        outputs.trianglelist = nil

//        var output = UnsafeMutablePointer<triangulateio>(&outputs)

        let test = CString("Qz")

        var a = UnsafeMutablePointer<triangulateio>.allocate(capacity: 1)
        a.initialize(to: triangulateio())

        // Set points

        var pointser = UnsafeMutablePointer<Double>.allocate(capacity: points.count)
        pointser.initialize(from: points, count: points.count)

//        let pointsPointer = UnsafeMutablePointer<Double>(points[0][0])
        a.pointee.pointlist = pointser
        a.pointee.numberofpoints = Int32(points.count / 2)


        var markers = Array<Int32>.init(repeating: 0, count: points.count / 2)
        a.pointee.pointmarkerlist = UnsafeMutablePointer(&markers[0])

//        points.withUnsafeMutableBufferPointer { (points) -> () in
//            points
//        }
//        a.pointee.pointlist = UnsafeMutableBufferPointer

        var b = UnsafeMutablePointer<triangulateio>.allocate(capacity: 1)
        b.initialize(to: triangulateio())


        triangulate(test.buffer, a, b, nil)

//        let numberOfTriangles = output.pointee.numberoftriangles

        dump(b.pointee.numberoftriangles)

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
        buffer.deallocate(capacity: _len)
    }
}
