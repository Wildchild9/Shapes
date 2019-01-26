//
//  Gradient.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public struct Gradient {
    
    public var name: String?
    public var colors: [UIColor]
    public var angle: CGFloat = 0.0 {
        didSet {
            if !(angle > -360 && angle < 360) {
                angle = angle.truncatingRemainder(dividingBy: 360)
            }
            updatePoints()
        }
    }
    
    public private(set) var startPoint = CGPoint(x: 0, y: 0.5)
    public private(set) var endPoint = CGPoint(x: 1, y: 0.5)
    
    public init (of colors: [UIColor], angle: CGFloat = 0.0, name: String? = nil) {
        self.colors = colors
        self.angle = angle > -360 && angle < 360 ? angle : angle.truncatingRemainder(dividingBy: 360)
        updatePoints()
        self.name = name
    }
    public init (of colors: UIColor..., angle: CGFloat = 0.0, name: String? = nil) {
        self.init(of: colors, angle: angle)
        self.name = name
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



//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: -  Conversion
public extension Gradient {
    
    public func uiColor(forFrame frame: CGRect) -> UIColor {
        
        guard !colors.isEmpty else { return .clear }
        guard colors.count != 1 else { return colors.first! }
        
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
    public func image(withFrame frame: CGRect) -> UIImage {
        
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
        
        return image!
        
    }
//    public func colors(at points: [CGPoint], in frame: CGRect) -> [UIColor] {
//
//        guard !colors.isEmpty else { return [.clear] }
//        guard colors.count != 1 else { return [colors.first!] }
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors
//        gradientLayer.frame = frame
//
//        gradientLayer.startPoint = startPoint
//        gradientLayer.endPoint = endPoint
//
//        gradientLayer.colors = colors.map { $0.cgColor }
//
//        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return points.map { image!.getPixelColor(pos: $0) }
//
//    }
    
    
    
    
    public var caGradientLayer: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        switch colors.count {
        case 0: gradientLayer.colors = [UIColor.clear, UIColor.clear]
        case 1: gradientLayer.colors = [colors[0], colors[0]]
        default: gradientLayer.colors = colors
        }
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.colors = colors.map { $0.cgColor }
        
        return gradientLayer
    }
}



//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: -  Defaults
public extension Gradient {
    public static let cosmicFusion = Gradient(of: #colorLiteral(red: 1, green: 0, blue: 0.8, alpha: 1), #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1), name: "Cosmic Fusion")
    public static let sunrise = Gradient(of: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), name: "Sunrise")
    public static let spring = Gradient(of: #colorLiteral(red: 0.1882352941, green: 0.137254902, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.3254901961, green: 0.6274509804, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.7058823529, green: 0.9254901961, blue: 0.3176470588, alpha: 1), name: "Spring")
    public static let wireTap = Gradient(of: #colorLiteral(red: 0.5411764706, green: 0.137254902, blue: 0.5294117647, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.2509803922, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.4431372549, blue: 0.1294117647, alpha: 1), name: "Wire Tap")
    public static let sublime = Gradient(of: #colorLiteral(red: 0.9882352941, green: 0.2745098039, blue: 0.4196078431, alpha: 1), #colorLiteral(red: 0.2470588235, green: 0.368627451, blue: 0.9843137255, alpha: 1), name: "Sublime")
    public static let rainbowBlue = Gradient(of: #colorLiteral(red: 0, green: 0.9490196078, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.01960784314, green: 0.4588235294, blue: 0.9019607843, alpha: 1), name: "Rainbow Blue")
    public static let argon = Gradient(of: #colorLiteral(red: 0.01176470588, green: 0, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0.4509803922, green: 0.01176470588, blue: 0.7529411765, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.2196078431, blue: 0.737254902, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.937254902, blue: 0.9764705882, alpha: 1), name: "Argon")
    public static let purpink = Gradient(of: #colorLiteral(red: 0.4980392157, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0, blue: 1, alpha: 1), name: "Purpink")
    public static let mello = Gradient(of: #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1), #colorLiteral(red: 0.5568627451, green: 0.2666666667, blue: 0.6784313725, alpha: 1), name: "mello")
    public static let ibizaSunset = Gradient(of: #colorLiteral(red: 0.9333333333, green: 0.03529411765, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 1, green: 0.4156862745, blue: 0, alpha: 1), name: "Ibiza Sunset")
    public static let alihossein = Gradient(of: #colorLiteral(red: 0.968627451, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.8588235294, green: 0.2117647059, blue: 0.6431372549, alpha: 1), name: "Alihossein")
    public static let superman = Gradient(of: #colorLiteral(red: 0, green: 0.6, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.09019607843, blue: 0.07058823529, alpha: 1), name: "Superman")
    public static let timber = Gradient(of: #colorLiteral(red: 0.9882352941, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.8588235294, blue: 0.8705882353, alpha: 1), name: "Timber")
    public static let instagram = Gradient(of: #colorLiteral(red: 0.5137254902, green: 0.2274509804, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.1137254902, blue: 0.1137254902, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.6901960784, blue: 0.2705882353, alpha: 1), name: "Instagram")
    public static let martini = Gradient(of: #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.2784313725, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.9960784314, blue: 0.2549019608, alpha: 1), name: "Martini")
    public static let danceToForget = Gradient(of: #colorLiteral(red: 1, green: 0.3058823529, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.137254902, alpha: 1), name: "Dance To Forget")
    public static let electricViolet = Gradient(of: #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.5568627451, green: 0.3294117647, blue: 0.9137254902, alpha: 1), name: "Electric Violet")
    public static let backToEarth = Gradient(of: #colorLiteral(red: 0, green: 0.7882352941, blue: 1, alpha: 1), #colorLiteral(red: 0.5725490196, green: 0.9960784314, blue: 0.6156862745, alpha: 1), name: "Back To Earth")
    public static let shahabi = Gradient(of: #colorLiteral(red: 0.6588235294, green: 0, blue: 0.4666666667, alpha: 1), #colorLiteral(red: 0.4, green: 1, blue: 0, alpha: 1), name: "Shahabi")
    public static let witchingHour = Gradient(of: #colorLiteral(red: 0.7647058824, green: 0.07843137255, blue: 0.1960784314, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.0431372549, blue: 0.2117647059, alpha: 1), name: "Witching Hour")
    public static let quepal = Gradient(of: #colorLiteral(red: 0.06666666667, green: 0.6, blue: 0.5568627451, alpha: 1), #colorLiteral(red: 0.2196078431, green: 0.937254902, blue: 0.4901960784, alpha: 1), name: "Quepal")
    public static let netflix = Gradient(of: #colorLiteral(red: 0.5568627451, green: 0.05490196078, blue: 0, alpha: 1), #colorLiteral(red: 0.1215686275, green: 0.1098039216, blue: 0.09411764706, alpha: 1), name: "Netflix")
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)
//    public static let <#name#> = Gradient(of: <#colors#>, name: <#name#>)


    public static let allGradients: [Gradient] = [.cosmicFusion, .sunrise, .spring, .wireTap, .sublime, .rainbowBlue, .argon, .purpink, .mello, .ibizaSunset, .alihossein, .superman, .timber, .instagram, .martini, .danceToForget, .electricViolet, .backToEarth, .shahabi, .witchingHour, .quepal, .netflix]
    
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Static Colors
public extension Gradient {
    public static let black = Gradient(of: .black, .black, name: "Black")
    public static let darkGray = Gradient(of: .darkGray, .darkGray, name: "Dark Gray")
    public static let lightGray = Gradient(of: .lightGray, .lightGray, name: "Light Gray")
    public static let white = Gradient(of: .white, .white, name: "White")
    public static let gray = Gradient(of: .gray, .gray, name: "Gray")
    public static let red = Gradient(of: .red, .red, name: "Red")
    public static let green = Gradient(of: .green, .green, name: "Green")
    public static let blue = Gradient(of: .blue, .blue, name: "Blue")
    public static let cyan = Gradient(of: .cyan, .cyan, name: "Cyan")
    public static let yellow = Gradient(of: .yellow, .yellow, name: "Yellow")
    public static let magenta = Gradient(of: .magenta, .magenta, name: "Magenta")
    public static let orange = Gradient(of: .orange, .orange, name: "Orange")
    public static let purple = Gradient(of: .purple, .purple, name: "Purple")
    public static let brown = Gradient(of: .brown, .brown, name: "Brown")
    public static let clear = Gradient(of: .clear, .clear, name: "Clear")
}



//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: -  Other Functions
public extension Gradient {
    public func withAngle(of θ: CGFloat) -> Gradient {
        var gradient = self
        gradient.angle = θ
        return gradient
    }
}



//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: -  CustomPlaygroundDisplayConvertible Conformance
extension Gradient: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 155, height: 71))
        
        if let name = name, !name.isEmpty {
            view.frame.size.height = 70
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25)) //20
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .bold)
            label.textColor = .lightText
            label.text = name.localizedCapitalized
            label.textAlignment = .center

            view.addSubview(label)
            
            let gradientLayer = caGradientLayer
            gradientLayer.frame = CGRect(x: 0,
                                         y: label.frame.origin.y + label.frame.size.height,
                                         width: view.frame.size.width,
                                         height: view.frame.size.height - label.frame.size.height)
            
            gradientLayer.cornerRadius = 6
            gradientLayer.masksToBounds = true
            
            view.layer.addSublayer(gradientLayer)
            
            return view
        } else {
            let gradientLayer = caGradientLayer
            gradientLayer.frame = view.frame
            
            gradientLayer.cornerRadius = 6
            gradientLayer.masksToBounds = true
            
            view.layer.addSublayer(gradientLayer)
            
            return view
        }
       
    }
}



