//
//  UIView+Layout.swift
//  IOSAudioRemoteControl
//
//  Created by wangxiangzhao on 2021/9/2.
//  Copyright © 2021 huangyibiao. All rights reserved.
//

import Foundation

protocol UIScreenScaleReferenceStandard {
    static var widthStandard: CGFloat { get }
    static var heightStandard: CGFloat { get }
}

extension UIScreenScaleReferenceStandard {
    static var widthStandard: CGFloat { 375 }
    static var heightStandard: CGFloat { 812 }
}

extension UIView {
    //y坐标
    var y: CGFloat {
        set { frame.origin.y = newValue }
        get { frame.minY }
    }
    
    //y坐标
    var x: CGFloat {
        set { frame.origin.x = newValue }
        get { frame.minX }
    }
    
    //宽
    var width: CGFloat {
        set { frame.size.width = newValue }
        get { frame.width }
    }
    
    //高
    var height: CGFloat {
        set { frame.size.height = newValue }
        get { frame.height }
    }
}

extension UIScreen: UIScreenScaleReferenceStandard {
    //屏幕的宽度
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    //屏幕的高度
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }
    
    //底部安全区域高度
    static var safeAreaBottom: CGFloat {
        guard let window = UIWindow.current else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    //顶部安全区域高度
    static var safeAreaTop: CGFloat {
        guard let window = UIWindow.current else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    //导航栏高度  large状态下时 96 + safeTopHeight
    static func navHeight(isLarge: Bool) -> CGFloat {
        (isLarge ? 96 : 44) + safeAreaTop
    }
    
    //tabbar高度
    static var tabbarHeight: CGFloat {
        safeAreaTop + 49
    }
    
    //屏幕宽度缩放比例 375
    static var ws: CGFloat {
        width / widthStandard
    }
    
    //屏幕高度度缩放比例 812
    static var hs: CGFloat {
        height / heightStandard
    }
}

extension Float {
    //等比例适配宽度
    var w: CGFloat {
        CGFloat(self) * UIScreen.ws
    }
    //等比例适配高度
    var h: CGFloat {
        CGFloat(self) * UIScreen.hs
    }
}

extension CGFloat {
    //等比例适配宽度
    var w: CGFloat {
        self * UIScreen.ws
    }
    //等比例适配高度
    var h: CGFloat {
        self * UIScreen.hs
    }
}

extension Double {
    //等比例适配宽度
    var w: CGFloat {
        CGFloat(self) * UIScreen.ws
    }
    //等比例适配高度
    var h: CGFloat {
        CGFloat(self) * UIScreen.hs
    }
}

extension Int {
    //等比例适配宽度
    var w: CGFloat {
        CGFloat(self) * UIScreen.ws
    }
    //等比例适配高度
    var h: CGFloat {
        CGFloat(self) * UIScreen.hs
    }
}

extension UInt {
    //等比例适配宽度
    var w: CGFloat {
        CGFloat(self) * UIScreen.ws
    }
    //等比例适配高度
    var h: CGFloat {
        CGFloat(self) * UIScreen.hs
    }
}

extension UIWindow {
    static var current: UIWindow? {
        if #available(iOS 13.0, *) {
            let windowScene: UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            if window != nil {
                return window
            }
        }
        let window = UIApplication.shared.keyWindow
        if window != nil {
            return window
        }
        return UIApplication.shared.windows.first
    }
    
    //上层控制器
    var topController: UIViewController? {
        var top = rootViewController
        while top?.presentedViewController != nil {
            top = top?.presentedViewController
        }
        return top
    }
    
    //当前的控制器
    var currentController: UIViewController? {
        guard var current = topController else {
            return nil
        }
        while true {
            if current.isKind(of: UINavigationController.self) {
                let nav = current as! UINavigationController
                if nav.topViewController != nil {
                    current = nav.topViewController!
                }
            } else if current.isKind(of: UITabBarController.self) {
                let tab = current as! UITabBarController
                if tab.selectedViewController != nil {
                    current = tab.selectedViewController!
                }
            } else if current.isKind(of: UISplitViewController.self) {
                let split = current as! UISplitViewController
                if split.viewControllers.last != nil {
                    current = split.viewControllers.last!
                }
            } else {
                break
            }
        }
        return current
    }
}
