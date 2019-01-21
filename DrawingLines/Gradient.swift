//
//  Gradient.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public struct Gradient {
    
    public var colors: [UIColor]
    public var angle: CGFloat = 0.0 {
        didSet {
            if !(angle > -360 && angle < 360) {
                angle = angle.truncatingRemainder(dividingBy: 360)
            }
            updatePoints()
        }
    }
    
    public private(set) var startPoint: CGPoint = .zero
    public private(set) var endPoint: CGPoint = .zero
    
    public init (of colors: [UIColor], angle: CGFloat = 0.0) {
        self.colors = colors
        self.angle = angle > -360 && angle < 360 ? angle : angle.truncatingRemainder(dividingBy: 360)
        updatePoints()
    }
    public init (of colors: UIColor..., angle: CGFloat = 0.0) {
        self.init(of: colors, angle: angle)
    }

    private mutating func updatePoints() {
        var angle = self.angle
        if !(angle > -360 && angle < 360) {
            angle = angle.truncatingRemainder(dividingBy: 360)
        }
        if angle < 0 { angle = 360 + angle }
        
        let tanx = { tan($0 * CGFloat.pi / 180) }
        
        let n: CGFloat = 0.5
        
        switch angle {
        case 0...45, 315...360:
            startPoint = CGPoint(x: 0, y: n * tanx(angle) + n)
            endPoint = CGPoint(x: 1, y: n * tanx(-angle) + n)
            
        case 45...135:
            startPoint = CGPoint(x: n * tanx(angle - 90) + n, y: 1)
            endPoint = CGPoint(x: n * tanx(-angle - 90) + n, y: 0)
            
        case 135...225:
            startPoint = CGPoint(x: 1, y: n * tanx(-angle) + n)
            endPoint = CGPoint(x: 0, y: n * tanx(angle) + n)
            
        case 225...315:
            startPoint = CGPoint(x: n * tanx(-angle - 90) + n, y: 0)
            endPoint = CGPoint(x: n * tanx(angle - 90) + n, y: 1)
            
        default:
            startPoint = CGPoint(x: 0, y: n)
            endPoint = CGPoint(x: 1, y: n)
        }
    }
    
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Conversion
public extension Gradient {
    
    public func uiColor(forFrame frame: CGRect) -> UIColor {
        
        guard !colors.isEmpty else { return .clear }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = frame
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.colors = colors.map { $0.cgColor }
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image!)

    }
    
    public var caGradientLayer: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.colors = colors.map { $0.cgColor }
        
        return gradientLayer
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Defaults
public extension Gradient {
    public static let cosmicFusion = Gradient(of: #colorLiteral(red: 1, green: 0, blue: 0.8, alpha: 1), #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1))
    public static let sunrise = Gradient(of: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    public static let spring = Gradient(of: #colorLiteral(red: 0.1882352941, green: 0.137254902, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.3254901961, green: 0.6274509804, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.7058823529, green: 0.9254901961, blue: 0.3176470588, alpha: 1))
    public static let wireTap = Gradient(of: #colorLiteral(red: 0.5411764706, green: 0.137254902, blue: 0.5294117647, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.4431372549, blue: 0.1294117647, alpha: 1))
    public static let sublime = Gradient(of: #colorLiteral(red: 0.9882352941, green: 0.2745098039, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.2470588235, green: 0.368627451, blue: 0.9843137255, alpha: 1))
    public static let rainbowBlue = Gradient(of: #colorLiteral(red: 0, green: 0.9490196078, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.01960784314, green: 0.4588235294, blue: 0.9019607843, alpha: 1))
    public static let argon = Gradient(of: #colorLiteral(red: 0.01176470588, green: 0, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0.4509803922, green: 0.01176470588, blue: 0.7529411765, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.2196078431, blue: 0.737254902, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.937254902, blue: 0.9764705882, alpha: 1))
    public static let purpink = Gradient(of: #colorLiteral(red: 0.4980392157, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0, blue: 1, alpha: 1))
    public static let mello = Gradient(of: #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1), #colorLiteral(red: 0.5568627451, green: 0.2666666667, blue: 0.6784313725, alpha: 1))
    public static let ibizaSunset = Gradient(of: #colorLiteral(red: 0.9333333333, green: 0.03529411765, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 1, green: 0.4156862745, blue: 0, alpha: 1))
    public static let alihossein = Gradient(of: #colorLiteral(red: 0.968627451, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.8588235294, green: 0.2117647059, blue: 0.6431372549, alpha: 1))
    public static let superman = Gradient(of: #colorLiteral(red: 0, green: 0.6, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.09019607843, blue: 0.07058823529, alpha: 1))
    public static let timber = Gradient(of: #colorLiteral(red: 0.9882352941, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.8588235294, blue: 0.8705882353, alpha: 1))
    public static let instagram = Gradient(of: #colorLiteral(red: 0.5137254902, green: 0.2274509804, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.1137254902, blue: 0.1137254902, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.6901960784, blue: 0.2705882353, alpha: 1))
    public static let martini = Gradient(of: #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.2784313725, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.9960784314, blue: 0.2549019608, alpha: 1))
    public static let danceToForget = Gradient(of: #colorLiteral(red: 1, green: 0.3058823529, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.137254902, alpha: 1))
    public static let electricViolet = Gradient(of: #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.5568627451, green: 0.3294117647, blue: 0.9137254902, alpha: 1))
    public static let backToEarth = Gradient(of: #colorLiteral(red: 0, green: 0.7882352941, blue: 1, alpha: 1), #colorLiteral(red: 0.5725490196, green: 0.9960784314, blue: 0.6156862745, alpha: 1))
    public static let shahabi = Gradient(of: #colorLiteral(red: 0.6588235294, green: 0, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 0.4, green: 1, blue: 0, alpha: 1))
//    public static let <#Name#> = Gradient(of: <#UIColor...#>)
//    public static let <#Name#> = Gradient(of: <#UIColor...#>)
//    public static let <#Name#> = Gradient(of: <#UIColor...#>)

}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Other Functions
public extension Gradient {
    public func angled(_ x: CGFloat) -> Gradient {
        var gradient = self
        gradient.angle = x
        return gradient
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - CustomPlaygroundDisplayConvertible Conformance

extension Gradient: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 71))
        
        let gradientLayer = caGradientLayer
        gradientLayer.frame = view.frame
        
        gradientLayer.cornerRadius = 6
        gradientLayer.masksToBounds = true
        
        view.layer.addSublayer(gradientLayer)
        
        return view
    }
}


