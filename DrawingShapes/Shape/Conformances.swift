//
//  Shape+Conformances.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Equatable Conformance
extension Shape.Component: Equatable {
    
    public static func == (lhs: Shape.Component, rhs: Shape.Component) -> Bool {
        switch (lhs, rhs) {
        case (.break, .break), (.close, .close):
            return true
        case let (.point(ax, ay), .point(bx, by)):
            return ax == bx && ay == by
        default:
            return false
        }
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Drawable Comformance
extension Shape: Drawable {
    
    public func draw() -> UIView {
        
        // Constant declarations
        let view = UIView()
        let shapePath = path
        let bounds = self.bounds
        
        // Add padding to view
        let shapeLayer = CAShapeLayer()
        view.frame.size.width = bounds.size.width + extendedPadding * 2
        view.frame.size.height = bounds.size.height + extendedPadding * 2
        view.frame.origin = .zero
        
        // Adjustment translation
        let adjustmentTranslation = CGAffineTransform(translationX: extendedPadding - bounds.minX, y: extendedPadding - bounds.minY)
        
        shapeLayer.frame = view.frame

        shapePath.apply(adjustmentTranslation)
        // Set path and line properties
        shapeLayer.path = shapePath.cgPath
        shapeLayer.lineWidth = options.lineWidth
        shapeLayer.lineCap = options.lineCap
        shapeLayer.lineJoin = options.lineJoin
        
        // Fill in shape
        if options.fillInShape {
            shapeLayer.strokeColor = .clear
            shapeLayer.fillColor = fill.uiColor(forFrame: view.frame).cgColor
        } else  {
            shapeLayer.strokeColor = fill.uiColor(forFrame: view.frame).cgColor
            shapeLayer.fillColor = .clear
        }
        
        // Setup backgroundlayer
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = shapePath.cgPath
        
        // Set line attributes
        backgroundLayer.lineWidth = options.lineWidth
        backgroundLayer.lineCap = options.lineCap
        backgroundLayer.lineJoin = options.lineJoin
        
        // Add shadow to background layer
        backgroundLayer.shadowColor = options.shadowColor.cgColor
        backgroundLayer.shadowOpacity = options.shadowOpacity
        backgroundLayer.shadowRadius = options.shadowRadius
        backgroundLayer.shadowOffset = options.shadowOffset
        
        // Fill in shape
        if options.fillInShape {
            backgroundLayer.strokeColor = .clear
            backgroundLayer.fillColor = fill.uiColor(forFrame: view.frame).cgColor
        } else  {
            backgroundLayer.strokeColor = fill.uiColor(forFrame: view.frame).cgColor
            backgroundLayer.fillColor = .clear
        }
        
        
        // Set gradient layer to shape
        let gradientLayer = fill.caGradientLayer
        gradientLayer.frame = view.frame
        gradientLayer.mask = shapeLayer
        
        // Add shape to view
        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(gradientLayer)
    
        // Add points to shape
        pointAdding: if options.displayPoints {
            
            var pointLayers = [CAShapeLayer]()
            
            var pointColors = [UIColor]()

            for (var point, pointPath) in _pointsAndPaths {
                
                point = point.applying(adjustmentTranslation)
                
                let pointLayer = CAShapeLayer()
                pointPath.apply(adjustmentTranslation)
                
                pointLayer.path = pointPath.cgPath
                
                
                switch options.pointFill {
                case .black:
                    pointLayer.fillColor = .black
                    
                case .white:
                    pointLayer.fillColor = .white
                    
                case .color(let c):
                    pointLayer.fillColor = c.cgColor
                    
                
                case .relativeToBackground:
                    pointLayer.fillColor = gradientLayer.color(at: point).adjustBrightness(by: -30).cgColor
                    
                case .default:
                    pointColors.append(gradientLayer.color(at: point))
                }
                
                
                if options.usePointShadow {
                    pointLayer.shadowColor = .black
                    pointLayer.shadowOpacity = 0.3
                    pointLayer.shadowRadius = 3
                    pointLayer.shadowOffset = .zero
                }
                
                pointLayers.append(pointLayer)
                
            }
            
            if case .default = options.pointFill {
                
                let avgColor = pointColors.averageColor()
                
                let luminance = 0.299 * avgColor.rgbaComponents.red + 0.587 * avgColor.rgbaComponents.green + 0.114 * avgColor.rgbaComponents.blue
                let pointColor: CGColor = luminance > 0.5 ? .black : .white
                
                for pointLayer in pointLayers {
                    let layer = pointLayer
                    layer.fillColor = pointColor
                    view.layer.addSublayer(layer)
                }
                break pointAdding
            }
            
            pointLayers.forEach { view.layer.addSublayer($0) }
        
        }
        
        return view
    }
}

/*
 
 view.layer.cornerRadius = 6
 let blurSubview = UIVisualEffectView()
 let blurEffect = UIBlurEffect(style: .dark)
 blurSubview.frame = view.frame
 blurSubview.effect = blurEffect
 blurSubview.translatesAutoresizingMaskIntoConstraints = false
 blurSubview.layer.masksToBounds = true
 blurSubview.layer.cornerRadius = view.layer.cornerRadius
 view.insertSubview(blurSubview, at: 0)
 
 */


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Component CustomStringConvertible Conformance
extension Shape.Component: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .point(x, y): return ".point(\(x), \(y))"
        case .break: return ".break"
        case .close: return ".close"
        }
    }
}

public extension CALayer {
    
    func color(at point: CGPoint) -> UIColor {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.translateBy(x: -point.x, y: -point.y)
        
        self.render(in: context)
        
        
        let red   = CGFloat(pixel[0]) / 255.0
        let green = CGFloat(pixel[1]) / 255.0
        let blue  = CGFloat(pixel[2]) / 255.0
        let alpha = CGFloat(pixel[3]) / 255.0
        context.closePath()
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
public extension UIColor {
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}
public extension CGPoint {
    static prefix func -(point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
}

public extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }
            
            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
    
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}

public extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

public extension Array where Element == UIColor {
    func averageColor() -> UIColor {

        var runningRed, runningGreen, runningBlue, runningAlpha: CGFloat
        (runningRed, runningGreen, runningBlue, runningAlpha) = (0.0, 0.0, 0.0, 0.0)
        
        for color in self {
            
            var red, green, blue, alpha: CGFloat
            (red, green, blue, alpha) = (0.0, 0.0, 0.0, 0.0)
            
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            runningRed += red * red
            runningGreen += green * green
            runningBlue += blue * blue
            runningAlpha += alpha * alpha
        }
        
        let den = CGFloat(count)
        
        return UIColor(red: sqrt(runningRed/den), green: sqrt(runningGreen/den), blue: sqrt(runningBlue/den), alpha: sqrt(runningAlpha/den))
    }
}

/*
 // Fill in shape
 if options.fillInShape {
 shapeLayer.strokeColor = .clear
 shapeLayer.fillColor = .black
 } else  {
 shapeLayer.strokeColor = .black
 shapeLayer.fillColor = .clear
 }
 
 // Set gradient layer to shape
 let gradientLayer = fill.caGradientLayer
 gradientLayer.frame = view.frame
 gradientLayer.mask = shapeLayer
 gradientLayer.shadowColor = options.shadowColor.cgColor
 gradientLayer.shadowOpacity = options.shadowOpacity
 gradientLayer.shadowRadius = options.shadowRadius
 gradientLayer.shadowOffset = options.shadowOffset
 gradientLayer.shadowPath = shapePath.cgPath
 
 
 
 // Add shape to view
 view.layer.addSublayer(gradientLayer)
 //
 //        // Add points to shape
 //        if options.displayPoints {
 //            let pointLayer = CAShapeLayer()
 //            let pointPath = self.pointPath
 //
 //            pointPath.apply(adjustmentTranslation)
 //
 //            pointLayer.path = pointPath.cgPath
 //
 //            pointLayer.fillColor = options.pointColor?.cgColor ?? .white
 //
 //            // Add shadow to points
 //            if options.usePointShadow {
 //                pointLayer.shadowColor = .black
 //                pointLayer.shadowOpacity = 0.25
 //                pointLayer.shadowRadius = 1.5
 //                pointLayer.shadowOffset = .zero
 //            }
 //
 //
 //
 //            view.layer.addSublayer(pointLayer)
 //        } else {
 //            for point in points.map({ $0.applying(adjustmentTranslation) }) {
 //                let path =  UIBezierPath(ovalIn: CGRect(x: point.x - options.pointRadius,
 //                                                        y: point.y - options.pointRadius,
 //                                                        width: options.pointRadius * 2,
 //                                                        height: options.pointRadius * 2))
 //                let l = CAShapeLayer()
 //                l.path = path.cgPath
 //
 //                let color = gradientLayer.color(at: point)
 //
 //                l.fillColor = color.adjustBrightness(by: -40).cgColor
 //
 //                l.shadowColor = .black
 //                l.shadowOpacity = 0.25
 //                l.shadowRadius = 1.5
 //                l.shadowOffset = .zero
 //                view.layer.addSublayer(l)
 //                print(gradientLayer.color(at: point).cgColor.components!)
 //
 //            }
 //
 //        }
 
 */
