//
//  UIExtension.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/10.
//

import SwiftUI

// 字体大小枚举
enum NotoSansSC: String {
    case regular = "NotoSansSC-Regular"
    case black = "NotoSansSC-Black"
    case bold = "NotoSansSC-Bold"
    case medium = "NotoSansSC-Medium"
    case light = "NotoSansSC-Light"
}

extension Font {
    // 自定义字体样式
    static func customfont(_ font: NotoSansSC, fontSize: CGFloat) -> Font {
        custom(font.rawValue, size: fontSize)
    }
}

// MARK: - 获取屏幕尺寸拓展
extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    // 百分比屏幕尺寸显示
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
        // 375 * 0.8
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
        // 680 * 0.8
    }
    
    static var topInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top
        }
        return 0.0
    }
    
    static var bottomInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
    
    static var horizontalInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.left + keyWindow.safeAreaInsets.right
        }
        return 0.0
    }
    
    static var verticalInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top + keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
}

// MARK: - App 颜色拓展
extension Color {
    
//    static var primaryApp: Color {
//        return Color(hex: "3674B5")
//    }
    
    static var focus: Color {
        return Color(hex: "3674B5")
    }
    
    static var unfocused: Color {
        return Color(hex: "A1E3F9")
    }
    
    static var focusStart: Color {
        return Color(hex: "D1F8EF")
    }
    static var secondaryStart: Color {
        return primaryApp
    }
    static var secondaryEnd: Color {
        return Color(hex: "A6F1E0")
    }
    static var org: Color {
        return Color(hex: "73C7C7")
    }
    
    static var primaryText: Color {
        return Color.white
    }
    
    static var primaryText80: Color {
        return Color.white.opacity(0.8)
    }
    static var primaryText60: Color {
        return Color.white.opacity(0.6)
    }
    static var primaryText35: Color {
        return Color.white.opacity(0.35)
    }
    static var primaryText28: Color {
        return Color.white.opacity(0.28)
    }
    
    static var primaryText10: Color {
        return Color.white.opacity(0.1)
    }
    
    static var secondaryText: Color {
        return Color(hex: "585A66")
    }
    
    static var primaryG: [Color] {
        return [focusStart, focus]
    }
    
    static var secondaryG: [Color] {
        return [secondaryStart, secondaryEnd]
    }
//    // 背景色
//    static var bg: Color {
//        return Color(hex: "40514e")
//    }
//    // 稍微浅一点的背景
//    static var bg_light: Color {
//        return Color(hex: "43676b")
//    }
    
    static var darkGray: Color {
        return Color(hex: "9AA6B2")
    }
    static var lightGray: Color {
        return Color(hex: "F8FAFC")
    }
    
    // 实现读取16位颜色
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB(12 -bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255 // 透明度
        )
    }
}

extension View {
    func cornerRadicus(_ radius: CGFloat, corner: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corner: corner))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corner: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 统一尺寸规范（基于你的 widthPer/heightPer 逻辑）
extension CGFloat {
    static let playerArtworkSize: CGFloat = .widthPer(per: 0.8) // 封面尺寸
    static let controlButtonSize: CGFloat = 44 // 控制按钮统一尺寸
}

// 系统颜色设置
extension Color {
    // 主色系调整建议（保持你的主题色系，但增强对比度）
    static var primaryApp: Color { Color(hex: "3674B5") } // 保持主色不变
    static var bg: Color { Color(hex: "40514e") } // 背景色
    static var bg_light: Color { Color(hex: "43676b") } // 浅背景
    
    // 新增播放器专用色
    static var playerControl: Color { Color(hex: "73C7C7") } // 控制按钮色
    static var progressTrack: Color { Color.primaryText28 } // 进度条轨道
    static var progressThumb: Color { Color.org } // 进度条滑块
}

// MARK: -侧滑返回逻辑拓展
/**
 Navigation View 导航视图的底层逻辑是UIKit中的UI Navigation，故需要对底层的UINavigaitonViewController类进行拓展。
 对UIGestureRecognizerDelegate协议的拓展控制，用于控制交互式弹出手势识别器的行为。
 */
extension UINavigationController:  UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self // 将该对象赋值为self，确定是否应该识别弹出的手势。
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
