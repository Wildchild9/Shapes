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

//var shape = Shape(components: .moveTo(0, 0), .p(100, 0), .p(100, 100), .p(0, 100), .p(0, 0)).prism().scaled(by: 1.25)
//shape.fill = .gradient(.ibizaSunset)
let cube = Shape2().to(0, 0).to(0, 100).to(100, 100).to(100, 0).close().prism().scaled(by: 1.25).withFill(.ibizaSunset)


//var tri = Shape(components: .moveTo(50, 0), .p(100, 100), .p(0, 100), .p(50, 0)).scaled(by: 2).prism(offsetByX: 70, y: 20)
//tri.fill = .gradient(.alihossein)
let triangularPrism = Shape2().to(0, 100).to(100,100).to(50, 0).close().scaled(by: 2).withFill(.alihossein).prism(offsetByX: 70, y: 20)

//var pyramid = Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75))
//pyramid.fill = .gradient(.martini )
let squareBasedPyramid = Shape2().to(0, 100).to(100, 100).to(125, 75).to(25, 75).close().joinedAt(x: 60, y: -30).withFill(.martini)

//var bipyramid = Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75)) + Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75)).rotated(by: 180).translatedBy(x: 125, y: 175)
//
//bipyramid.fill = .gradient(.wireTap)
//bipyramid.fill.angle = 225
//bipyramid


let randomShape = Shape2.random(in: 1...250, numberOfPoints: 15).scaled(by: 1.25).withFill(.rainbowBlue)

let s = Shape2(components: .point(0, 0)).to(100, 0).to(100, 100).to(0, 100).close().scaled(by: 1.4)
s.prism().withFill(.backToEarth) + s.translatedBy(x: 12.5, y: -12.5)

let tetrahedron = Shape2().to(0, 100).to(100, 100).to(125, 75).to(25, 75).close().joinedAt(points: (60, -30), (60, 205))
