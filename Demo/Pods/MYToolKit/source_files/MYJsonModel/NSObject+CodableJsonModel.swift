//
//  JSONTool.swift
//  MYJsonModel
//
//  Created by mac on 2019/1/21.
//  Copyright © 2019年 mac. All rights reserved.
//《基于Codable协议实现的json-model转化类》

import Foundation

public class MYJSONTool{
    //MARK:json字典转模型
    /**
     json字典转模型
     @param type 模型类型Class.self
     @param jsonDic json字典
     @param hintDic 映射字典
     @note 映射规则：key是模型的key，value是json字典的key
     */
    public static func jsonToModel<T: Codable>(type: T.Type, jsonDic: Any?, hintDic: [String: Any]?) -> T? {
        guard jsonDic is [String: Any] else {
            return nil
        }
        
        var json = jsonDic as! [String: Any]
        if  hintDic != nil {//非nil
            json = self.filterJsonDic(jsonDic: json, hintDic: hintDic!)
        }
        
        let decoder = JSONDecoder.init()
        let obj = try? decoder.decode(type, from: JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted))
        return obj
    }
    
    //MARK:模型转json字典
    /**
     模型转json字典
     */
    public static func changeToJsonDic<T: Codable>(type: T.Type, obj:T)->[String: Any]?{
        var dic:[String: Any]? = nil
        let encoder = JSONEncoder.init()
        if let data:Data = try? encoder.encode(obj){
            dic = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves)) as? [String: Any]
        }
        return dic
    }
    
    
    //MARK:- 私有方法
    //MARK:递归替换为正确的jsonDic
    static func filterJsonDic(jsonDic:[String: Any], hintDic: [String: Any]) -> [String: Any]{
        var changedJsonDic = jsonDic
        for obj in hintDic {
            if obj.value is [[String: Any]] {//MARK: 1.数组
                if let nextHintDic = (obj.value as? [[String: Any]])?.first{//(1)取nextHintDic
                    if let nextJsonDicArr = changedJsonDic[obj.key] as? [[String: Any]] {
                        var arr = [[String: Any]].init()
                        for var nextJsonDic: [String: Any] in  nextJsonDicArr{//(2)取nextJsonDic
                            nextJsonDic = self.filterJsonDic(jsonDic: nextJsonDic, hintDic: nextHintDic)
                            arr.append(nextJsonDic)
                        }
                        changedJsonDic[obj.key] = arr
                    }
                }
            }else if obj.value is [String: Any] {//MARK: 2.字典，即(1)nextHintDic
                if var nextJsonDic = changedJsonDic[obj.key] as? [String: Any] {//(2)取nextJsonDic
                    nextJsonDic = self.filterJsonDic(jsonDic: nextJsonDic, hintDic: obj.value as! [String: Any])
                    changedJsonDic[obj.key] = nextJsonDic
                }
            }else if obj.value is String {//MARK: 3.字符串，将jsonDic的key该正确(添加新key：obj.key，删除key：obj.value)
                if var value = changedJsonDic[obj.value as! String]{
                    if value is [String: Any] {//字典
                        if let nextJsonDic = value as? [String: Any] {//(1)取nextJsonDic
                            if let nextHintDic = hintDic[obj.value as! String] as? [String: Any] {//(2)取nextHintDic
                                value = self.filterJsonDic(jsonDic: nextJsonDic, hintDic: nextHintDic )
                            }
                        }
                    }else if value is [[String: Any]]{//数组
                        if let nextHintDic = (hintDic[obj.value as! String] as? [[String: Any]])?.first{//(1)取nextHintDic
                            var arr = [[String: Any]].init()
                            for var nextJsonDic: [String: Any] in  value as! [[String: Any]]{//(2)取nextJsonDic
                                nextJsonDic = self.filterJsonDic(jsonDic: nextJsonDic, hintDic: nextHintDic)
                                arr.append(nextJsonDic)
                            }
                            value = arr
                        }
                    }
                    
                    changedJsonDic[obj.key]  = value
                    changedJsonDic.removeValue(forKey: obj.value as! String)
                }
            }
        }
        return changedJsonDic
    }
}
