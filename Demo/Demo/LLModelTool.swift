//
//  LLModelTool.swift
//  JSONToModelSwift
//
//  Created by 骆亮 on 2018/9/16.
//  Copyright © 2018年 LOLITA0164. All rights reserved.
//

import Foundation

enum LLModelToolError: Error {
    case message(String)
}

struct LLModelTool {
    
    /// 字典 转 模型
    static func decode<T>(_ type: T.Type, resDic: [String:Any] , hintDic:[String:Any]?) throws -> T where T: Decodable {
        // 将映射字典转换成模型所需的字典
        var transformDic = resDic
        if (hintDic != nil) {
            transformDic = self.setUpResourceDic(resDic: resDic, hintDic: hintDic!)
        }
        guard let jsonData = self.getJsonData(param: transformDic) else {
            throw LLModelToolError.message("转成 Data 时出错!!!")
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData)
            else {
            throw LLModelToolError.message("转成 数据模型 时出错!!!")
        }
        return model
    }
    
    
    /// json 转模型
    static func decode<T>(_ type: T.Type, jsonData: Data , hintDic:[String:Any]?) throws -> T where T: Decodable {
        guard let resDic: [String:Any] = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any] else {
            throw LLModelToolError.message("转成 字典 时出错!!!")
        }
        return try! self.decode(type, resDic: resDic, hintDic: hintDic)
    }
    
    // 模型转字典
    static func reflectToDict<T>(model: T) -> [String:Any] {
        let mirro = Mirror(reflecting: model)
        var dict = [String:Any]()
        for case let (key?, value) in mirro.children {
            dict[key] = value
        }
        return dict
    }
    
    
    
    /// 获取 json 数据，data类型
    static func getJsonData(param: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }


    /// 根据映射字典设置当前字典内容
    private static func setUpResourceDic(resDic: [String:Any] , hintDic:[String:Any]) -> [String:Any]{
        var transformDic = resDic
        for (key,value) in hintDic {
            let valueNew: AnyObject = value as AnyObject
            if valueNew.classForCoder == NSDictionary.classForCoder(){      // 模型映射
                let res_value = resDic[key] as AnyObject    // 为了获取数据类型
                if res_value.classForCoder == NSArray.classForCoder(){  // 数据类型为数组（模型数组）
                    let res_value_array = res_value as! [[String:Any]]
                    var resArray: [Any] = []
                    for item in res_value_array {
                        // 递归调用，寻找子模型
                        let res = self.setUpResourceDic(resDic: item , hintDic: valueNew as! [String : Any])
                        resArray.append(res)
                    }
                    let realKey = self.getRealKey(key: key, dic: hintDic)
                    transformDic[realKey] = resArray
                    // 移除旧的数据
                    if realKey != key {
                        transformDic.removeValue(forKey: key)
                    }
                }
                else if res_value.classForCoder == NSDictionary.classForCoder(){    // 数据类型为字典（模型）
                    // 递归调用，寻找子模型
                    let res = self.setUpResourceDic(resDic: res_value as! [String : Any] , hintDic: valueNew as! [String : Any])
                    let realKey = self.getRealKey(key: key, dic: hintDic)
                    transformDic[realKey] = res
                    // 移除旧的数据
                    if realKey != key {
                        transformDic.removeValue(forKey: key)
                    }
                }
            }else if valueNew.classForCoder == NSString.classForCoder(){    // 普通映射
                // 去掉
                if !hintDic.keys.contains(valueNew as! String){
                    transformDic[key] = resDic[valueNew as! String]
                }
                // 移除旧的数据
                if key != valueNew as! String {
                    transformDic.removeValue(forKey: valueNew as! String)
                }
            }
        }
        return transformDic
    }
    
    
    /// 从映射字典中获取到模型中对应的key
    private static func getRealKey(key:String, dic:[String:Any]) -> String {
        for (k,v) in dic {
            let value: AnyObject = v as AnyObject
            if value.classForCoder == NSString.classForCoder(){
                let valueNew = value as! String
                if valueNew == key{
                    return k
                }
            }
        }
        return key
    }

}

