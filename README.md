# Shapes
A library for quickly and easily drawing and modifying complex shapes. 


## Try it out
To try out this project, open the DrawingShapes.xcodeproj file, then run the Testing playground. To see the outputs of the various shape statements, be sure to expand the preview on the right side of the playground.

## Examples

### Squares and Cubes
Here are a few examples of some fun quick shapes you can make with this library.

Firstly lets start off by making a square:

```swift
let square = Shape().to(0, 0).to(0, 100).to(100, 100).to(100, 0).closed().withFill(.white)
```

<img width="159" alt="Screenshot 2022-12-08 at 6 13 07 PM" src="https://user-images.githubusercontent.com/35314567/206586556-40ad9866-b6d6-4168-8eae-3df9c151f32d.png">
This can easly be made into a cube with a single method call:

```swift
let cube = square.prism()
```

<img width="164" alt="Screenshot 2022-12-08 at 6 14 35 PM" src="https://user-images.githubusercontent.com/35314567/206586705-d0fe7ccc-26b6-43ac-97ec-83c86758d753.png">

Furthermore, if we want to apply more advanced styling, we can apply a gradient and show the points of the shape.

``` swift
let styledCube = cube.withFill(.argon).showingPoints()
```

<img width="153" alt="Screenshot 2022-12-08 at 6 15 34 PM" src="https://user-images.githubusercontent.com/35314567/206586821-446d807c-61cf-4038-ac12-7e9edcc2858c.png">

-----
### Pyramids

Now let's look at some more complex shapes, such as a pyramid.
To make a pyramid, it is almost as easy as making a square but with one additional call to `joinedAt`.

```swift
let pyramid = Shape()
    .to(0, 100).to(100, 100).to(125, 75).to(25, 75).closed()
    .joinedAt(x: 60, y: -30)
    .withFill(.wireTap).showingPoints()
```
<img width="158" alt="Screenshot 2022-12-08 at 6 29 02 PM" src="https://user-images.githubusercontent.com/35314567/206588438-8c262cc8-80e7-45b0-a510-7c8dd0b7790a.png">

To make a bipyramid, we can do this in a few different ways.
The first way we can do this is by using the existing pyramid and mirroring it about its bottom axis and performing a translation.

```swift
let bipyramid = squareBipyramid + squareBipyramid.reflected(over: .bottom).flipped(.vertically).translatedBy(x: 0, y: -25)
```

<img width="159" alt="Screenshot 2022-12-08 at 6 32 21 PM" src="https://user-images.githubusercontent.com/35314567/206588820-028f7362-1c34-4cbb-9ceb-9e1bda10ad46.png">

Alternatively, we can make the new bipyramid from scratch. This can be done by adding a slight modification to the code that generates the pyramid, just by passing an additional point to the `joinedAt` method.

```swift
let bipyramid = Shape()
    .to(0, 100).to(100, 100).to(125, 75).to(25, 75).closed()
    .joinedAt(points: (60, -30), (65, 205))
    .withFill(.wireTap).showingPoints()
```
As we can see, this produces the same result:

<img width="155" alt="Screenshot 2022-12-08 at 6 35 25 PM" src="https://user-images.githubusercontent.com/35314567/206589195-42abbbdc-9c25-4708-add8-f97b44304615.png">

----

### Other fun shapes

Polygon:

```swift
var polygonalPrism = Shape.regularPolygon(n: 7, sideLength: 100).prism()
polygonalPrism.applyingOptions(.fill(.electricViolet), .showPoints)
```
<img width="267" alt="Screenshot 2022-12-08 at 6 39 19 PM" src="https://user-images.githubusercontent.com/35314567/206589609-d16e2480-d8db-4405-b33d-46c7b3744795.png">

Badge:

```swift
let badge = Shape.star(numberOfPoints: 9, radiusPercent: 0.7).withFill(.red).applyingOption(.fillInShape(true))
```

<img width="214" alt="Screenshot 2022-12-08 at 6 42 04 PM" src="https://user-images.githubusercontent.com/35314567/206589898-069d1ea2-d727-48a7-8451-1a60ff86c84c.png">

21-pointed star:

```swift
let star = Shape.crossStar(numberOfPoints: 21).applyingOptions(.fill(.timber), .lineWidth(1.0)).scaled(by: 3)
```
<img width="195" alt="Screenshot 2022-12-08 at 6 44 26 PM" src="https://user-images.githubusercontent.com/35314567/206590136-ec9089e4-99b0-41c9-bef9-ead459cb1bca.png">

## Using Shapes in Your Project

You can interact with these shapes and use them in your own project in two primary ways.
1. Extracting a `UIView` from a shape
    - This can be done by calling `shape.draw()`
  
2. Extracting a `UIBezierPath` from a shape
    - This can be done by calling `shape.path`
