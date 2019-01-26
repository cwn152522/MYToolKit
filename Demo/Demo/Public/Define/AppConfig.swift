//
//  AppConfig.swift
//  Demo
//
//  Created by cwn on 2019/1/25.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

//MARK: ********************** 应用配置 **************************
public class AppConfig: NSObject {
    //FIXME: 1、域名
    public static var yuMing: String = {
        return "http://123.207.65.130"
    }()
    public static func yuMingAnd(path: String) -> String{
        return yuMing + path
    }
    
    //FIXME: 2、颜色
    public static var Color: UIColor.Type{
        //MARK: 颜色类型
        return UIColor.self
    }
    public static var GlobalColor: UIColor{
        //MARK: 全局色
        return self.Color.hexColor(color: "#ff5a5a")
    }
}



//MARK: - UIColor扩展
public extension UIColor {
    //FIXME: 十六进制颜色
    public static func hexColor(color: String) -> UIColor{
        var color_Str = color.lowercased()
        
        guard color_Str.contains("0x") || color_Str.hasPrefix("#") else {
            return UIColor.clear;
        }
        
        color_Str = color_Str.replacingOccurrences(of: "0x", with: "")
        color_Str = color_Str.replacingOccurrences(of: "#", with: "")

        if color_Str.count < 6{
            return UIColor.clear;
        }
        
        //此时color的长度必为6位
        var rgbValue:UInt32 = 0
        Scanner(string: color_Str).scanHexInt32(&rgbValue)

        return self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                         alpha: 1)
    }
}



//MARK: ********************** 全局配置 **************************
//FIXME: 1、日志输出
public func DLog(_ items: Any...){
    #if DEBUG
    for item in items {
        print(item, separator: "", terminator: " ")
    }
    print("")
    #endif
}
public func echo(_ items: Any...){
    #if DEBUG
    for item in items {
        print(item, separator: "", terminator: " ")
    }
    print("")
    #endif
}

