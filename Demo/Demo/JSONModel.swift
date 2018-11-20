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
    static func cwn_makModel<T>(_ type:T.Type, jsonDic: Any?, hintDic:[String:String]?) throws -> T where T: Decodable{
//        var transformDic = self.
        if hintDic != nil {
            //将映射字典转换成模型所需的字典
//            transformDic = self.
        }
        
        guard let data = try?JSONSerialization.data(withJSONObject: jsonDic!, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            throw JSONModelError.message("data转换失败")
        }
        
        let decoder = JSONDecoder.init()
        let obj = try? decoder.decode(type, from: data)
        return obj as T
    }
    
    
    static func transform(dic:Any?, hintDic:[NSString: String]?){
        
    }
}
