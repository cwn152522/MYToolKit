//
//  JSONModel.swift
//  Demo
//
//  Created by cwn on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

enum JSONModelError:Error {//定义异常枚举
    case message(String)
}

class JSONModel{
    /**
     字典转模型
     */
    static func cwn_makeModel<T>(_ type:T.Type, jsonDic: [String: Any]?, hintDic:[String:Any]?) throws -> T where T: Decodable{
        guard jsonDic != nil else {
            throw JSONModelError.message("json字典不能为空")
        }
        
        var transformDic = jsonDic
        if hintDic != nil && jsonDic != nil {//有映射字典，替换key为正确的key
            transformDic = self.transform(dic: jsonDic!, hintDic: hintDic)
        }
        
        //最终字典转data
        guard let data = try?JSONSerialization.data(withJSONObject: transformDic!, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            throw JSONModelError.message("dic-data转换失败")
        }
        //data转model
        let decoder = JSONDecoder.init()
        guard let obj = try? decoder.decode(type, from: data) else {
            throw JSONModelError.message("data-model转换失败")
        }
        return obj
    }
    
    
    /**
     data转模型
     */
    static func cwn_makeModel<T>(_ type:T.Type, jsonData: Data?, hintDic:[String:Any]?)throws -> T where T: Decodable{
        let dic = (try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String:Any]
        return try self.cwn_makeModel(type, jsonDic: dic, hintDic: hintDic)
    }
    
    
    
    
    
    
    
    //MARK:- 递归替换所有的映射key
    static func transform(dic:[String: Any]?, hintDic:[String: Any]?) -> [String: Any]?{
        //⚠️ 参数、返回都建议是可选值，否则由于服务端请求回来的json格式变化，可能导致此方法内!导致崩溃。
        //   应该能做到任何情况都不崩，大不了不替换key，转换出来的模型少些值而已。
        var transfrom_dic = dic
        
        for obj in hintDic! {
            if obj.value is String {//如果是string，直接替换
                let value = dic?[obj.value as! String]
                transfrom_dic?.removeValue(forKey: obj.value as! String)
                transfrom_dic?[obj.key as String] = value
            }else if obj.value is [String:String] {//如果是字典，递归转换，最后替换字典
                let value = self.transform(dic:transfrom_dic?[obj.key as String] as? [String : Any], hintDic: obj.value as? [String: Any] )
                transfrom_dic?[obj.key as String] = value
            }else if obj.value is [[String:Any]] {//如果是数组，遍历每一项，递归转换，最后替换数组
                let arr_item = (obj.value as! [[String:Any]]).first
                var new_Arr:[[String:Any]]?
                for item in (transfrom_dic?[obj.key as String] as? [[String: Any]]) ?? [] {
                    if let value = self.transform(dic:item, hintDic: arr_item){
                        new_Arr!.append(value)
                    }
                }
                transfrom_dic?[obj.key as String] = new_Arr
            }
        }
        return transfrom_dic
    }
}
