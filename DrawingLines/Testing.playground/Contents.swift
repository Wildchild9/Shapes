import Foundation
import DrawingLines

/*
 - scale points from a single point
 - find perimeter points
 - rotate an array of points
 - flip points horizontally and vertically
 - draw bezier curves
 - don't store bezier path
 */

var breeze = Gradient.argon

breeze.angle = 180

Gradient.alihossein

var shape = Shape(components: .moveTo(0, 0), .p(100, 0), .p(100, 100), .p(0, 100), .p(0, 0)).prism().scaled(by: 1.25).rotated(by: 45)
shape.fill = .gradient(.ibizaSunset)


var tri = Shape(components: .moveTo(50, 0), .p(100, 100), .p(0, 100), .p(50, 0)).scaled(by: 2).prism(offsetByX: 70, y: 20).rotated(by: 90)
tri.fill = .gradient(.alihossein)

var pyramid = Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75))
pyramid.fill = .gradient(.martini )


var bipyramid = Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75)) + Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75)).rotated(by: 180).translatedBy(x: 125, y: 175)
bipyramid.fill = .gradient(.wireTap)
bipyramid.fill.angle = 225
bipyramid


var randomShape = Shape.random(in: 1...250, numberOfPoints: 15).scaled(by: 1.25)
randomShape.fill = .gradient(.rainbowBlue)


