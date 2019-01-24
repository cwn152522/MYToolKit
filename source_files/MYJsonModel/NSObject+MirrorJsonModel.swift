//
//  MRJsonModelExtension.swift
//  SwiftTest
//
//  Created by mac on 2019/1/20.
//  Copyright © 2019年 cwn. All rights reserved.
//《基于Mirror反射机制实现的json-model转化类，似乎只能作用于swift模型类？》

import Foundation
public extension NSObject{
    
    //MARK:json字典转模型
    /**
     json字典转模型
     @param jsonDic json字典
     @param hintDic 映射字典
     @note 映射规则：key是模型的key，value是json字典的key
     */
     public static func objectWith(jsonDic: Any?,  hintDic:[String: String]?) -> NSObject?{
        guard  jsonDic is [String: Any] else{
            print("jsonDic为nil或者不是字典类型")
            return nil
        }
        //jsonDic肯定是字典类型且不为nil，因此可以进行强解
        let json = jsonDic as! [String: Any]
        
        let obj = self.init()
        obj.p_setValuesFrom(jsonDic: json, hintDic: hintDic)
        return obj
    }
    

    //MARK:模型转json字典
    /**
     模型转json字典
     @param hintDic 映射字典
     @note 映射规则：key是模型的key，value是json字典的key
     */
    public func changeToJsonDic(hintDic:[String: String]?)->[String: Any]{
        var dic:[String: Any] = [String: Any].init()
        for (var key, value) in  Mirror.init(reflecting: self).children{
            let types = type(of: value)
            if hintDic?.keys.contains(key!) == true{
                key = hintDic?[key!]
            }
            if( types is String!.Type || types is String?.Type || types is String.Type){
                dic[key!] = value as? String
            }else{
                dic[key!] = value
            }
        }
        return dic
    }
    
    
    //MARK:模型转json字符串
    /**
     模型转json字符串
     @param hintDic 映射字典
     @note 映射规则：key是模型的key，value是json字符串的key
     */
    public func changeToJsonStr(hintDic:[String: String]?)->String{
        let dic:[String: Any] = self.changeToJsonDic(hintDic: hintDic)

        if let data:Data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted){
            let str: String = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            return str
        }
        return ""
    }
    
    
    //MARK:模型转模型
    /**
     模型转模型
     @param jsonDic json字典
     @param hintDic 映射字典
     @note 映射规则：1.key是旧模型的key，value是新模型的key(属性间映射)
     2.key是新模型的key，value是json字典的key(新模型新属性映射)
     */
    public func changeToModel<T:NSObject>(type:T.Type, jsonDic: Any?, hintDic:[String: String]?) -> T?{
        var dic = self.changeToJsonDic(hintDic: hintDic)//获取当前类对应的jsonDic
        
        //对新增的json数据进行解析
        if let json_new = jsonDic as? [String: Any]{
            for (key, value) in json_new {
                dic[key] = value
            }
        }
        
        let t = T.init()
        t.p_setValuesFrom(jsonDic: dic, hintDic: hintDic)
        return t
    }
    
    
    
    
    //MARK: - 私有方法
    //MARK: jsonDic转模型
     private func p_setValuesFrom(jsonDic: [String: Any], hintDic:[String: String]?){
        var result = [String: Any].init()//定义结果集
        
        //1.获取结果集(key为属性名name，value为jsonDic里的value)
        let dic = Mirror.init(reflecting: self)
        for (var key, value) in dic.children {
            let property = key
            if hintDic != nil {
                if hintDic!.keys.contains(key!){
                    key = hintDic?[key!]
                }
            }
            
            let types = type(of: value)//获取类型
            if !jsonDic.isEmpty && jsonDic.keys.contains(key!){//从jsonDic取到value
                var value = jsonDic[key!]
                if( types is String!.Type || types is String?.Type || types is String.Type){//这里为了处理定义是string，服务端却给了int变成了number导致经常闪退的bug，这点类似oc的数据模型解析
                    value = "\(value!)"//保险起见，将int也好，string也好，转为模型所定义的类型
                }
                result[property!] = value//将此key-value添加到结果集里
            }
        }
        
        //2.通过kvc进行属性赋值(一步到位)
        if !result.isEmpty {//kvc
            self.setValuesForKeys(result)
        }
    }
}
