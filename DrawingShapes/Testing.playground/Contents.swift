import Foundation
import DrawingShapes
/*
 - find perimeter points
 - draw bezier curves
 - points that make up the perimeter (if point is encapsulated within the overall graphic, it is not part of the set)
 - radial gradient
 - apply options enum
 */
print("Hello")
let gradient = Gradient.argon

Gradient.alihossein



//var shape = Shape(components: .moveTo(0, 0), .p(100, 0), .p(100, 100), .p(0, 100), .p(0, 0)).prism().scaled(by: 1.25)
//shape.fill = .gradient(.ibizaSunset)
let cube = Shape().to(0, 0).to(0, 100).to(100, 100).to(100, 0).closed().prism().scaled(by: 1.25).applyingOptions(.fill(.argon), .showPoints)


//var tri = Shape(components: .moveTo(50, 0), .p(100, 100), .p(0, 100), .p(50, 0)).scaled(by: 2).prism(offsetByX: 70, y: 20)
//tri.fill = .gradient(.alihossein)
let triangularPrism = Shape().to(0, 100).to(100,100).to(50, 0).closed().scaled(by: 1.25).prism(offsetByX: 70, y: 20).applyingOptions(.fill(.alihossein), .lineWidth(3), .showPoints)
Gradient.alihossein.colors.averageColor()


//var pyramid = Shape(components: .moveTo(0, 100), .p(100, 100), .p(125, 75), .p(25, 75), .p(0, 100), .p(60, -30), .p(100, 100), .moveTo(25, 75), .p(60, -30), .p(125, 75))
//pyramid.fill = .gradient(.martini )
let squareBasedPyramid = Shape().to(0, 100).to(100, 100).to(125, 75).to(25, 75).closed().joinedAt(x: 60, y: -30).applyingOptions(.fill(.netflix), .showPoints)





let randomShape = Shape.random(in: 1...250, numberOfPoints: 20).scaled(by: 1.25).withFill(.rainbowBlue).showingPoints()

let s = Shape(components: .point(0, 0)).to(100, 0).to(100, 100).to(0, 100).closed().scaled(by: 1.4).showingPoints()
let s2 = s.prism().applyingOptions(.fill(.backToEarth), .showPoints, .pointFill(.relativeToBackground)) + s.translatedBy(x: 12.5, y: -12.5)


let squareBipyramid = Shape().to(0, 100).to(100, 100).to(125, 75).to(25, 75).closed().joinedAt(points: (60, -30), (65, 205)).withFill(.wireTap, angle: 225).showingPoints()
squareBipyramid.rotated(by: 45).showingPoints(withFill: .relativeToBackground)

var tetrahedron = Shape().to(0, 100).to(100, 100).to(50, 65).closed().joinedAt(x: 50, y: -30).scaled(by: 2).showingPoints()


var joiningSquares = Shape().to(0, 0).to(0, 100).to(100, 100).to(100, 0).closed().to(50, 50).to(150, 50).to(150, 150).to(50, 150).closed().withFill(.instagram)

joiningSquares.options.fillInShape = true
joiningSquares

var diamond = Shape().to(0, 0).to(100, 0).to(100, 100).to(0, 100).closed()
let d = diamond + diamond.transformed { CGPoint(x: $0.x + 20, y: $0.y + 20) }
d.showingPoints()
diamond.prism().rotated(by: 45)

diamond.applyingOptions(.fillAngle(45))
//diamond.applyingOptions(.fillAngle(22.5)).fill.image(withFrame: diamond.bounds)



let pyramid = Shape().to(0, 100).to(100, 100).to(125, 75).to(25, 75).closed().joinedAt(x: 60, y: -50).withFill(.martini)
pyramid.withFill(.superman, angle: 22.5) + pyramid.reflected(over: .bottom).flipped(.vertically).translatedBy(x: 0, y: -25)



var p = pyramid.withFill(.mello) + pyramid.reflected(over: .bottom).flipped(.vertically).translatedBy(x: 0, y: 75)

p += p.rotated(by: 90).flipped(.horizontally)


p = p.rotated(by: 45).scaled(by: 1.2) + p.scaled(by: 1.2)

p.applyOption(.showPoints)

var trigonalPlanar = Shape().to(50, 0).breaking().to(0, 100).breaking().to(100, 100).breaking().joinedAt(x: 50, y: 50)



//extension UIColor {
//    var r: [CGFloat]? {
//        return self.cgColor.components
//    }
//}

var arrow = Shape().to(100, 0).joinedAt(points: (0, 0), (80, -10), (80, 10)).scaled(by: 2.5).rotated(by: -45)
arrow.rotate(by: 180)
arrow.reflected(over: .topLeftToBottomRight)




var polygon = Shape.regularPolygon(n: 7, sideLength: 100).prism()
polygon.applyOptions(.fill(.electricViolet), .showPoints)
//polygon = polygon.joinedAt(points: polygon.points)


polygon

Gradient.allGradients

Shape.crossStar(numberOfPoints: 34, distanceBetweenPoints: 100).applyingOptions(.fill(.random), .showPoints)


let newStar = Shape.crossStar(numberOfPoints: 51).applyingOptions(.fill(.timber), .lineWidth(1.0)).scaled(by: 3)


print("Hello")
