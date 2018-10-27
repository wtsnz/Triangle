//
//  Triangle.swift
//  Triangle
//
//  Created by Will Townsend on 2018-10-24.
//  Copyright © 2018 Will Townsend. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

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
