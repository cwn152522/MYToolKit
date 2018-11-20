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
    static func cwn_makModel<T>(_ type:T.Type, jsonDic: [String: Any]?, hintDic:[String:Any]?) throws -> T where T: Decodable{
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
    
    
    static func transform(dic:[String: Any], hintDic:[String: Any]?) -> [String: Any]{
        var transfrom_dic = dic
        
        for obj in hintDic! {
            if obj.value is String {//如果是string，直接替换
                let value = dic[obj.value as! String]
                transfrom_dic.removeValue(forKey: obj.value as! String)
                transfrom_dic[obj.key as String] = value
            }else if obj.value is [String:String] {
                let value = self.transform(dic:transfrom_dic[obj.key as String] as! [String : Any], hintDic: obj.value as? [String: Any] )
                transfrom_dic[obj.key as String] = value
            }
        }

        return transfrom_dic
    }
}
