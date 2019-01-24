//
//  NSObject+RNJsonModel.h
//  MYJsonModel
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019年 mac. All rights reserved.
//《基于RunTime实现的json-model转化类》

#import <Foundation/Foundation.h>

@interface NSObject(RunTimeJsonModel)
/**
 json字典转模型
 @param jsonDic json字典
 @param hintDic 映射字典
 @note 映射规则：key是模型的key，value是json字典的key
 */
+ (instancetype)initWithJsonDic:(NSDictionary*)jsonDic hintDic:(NSDictionary *)hintDic;


/**
 模型转json字典
 @param hintDic 映射字典
 @note 映射规则：key是模型的key，value是json字典的key
 */
- (NSDictionary *)toJsonDicWithHintDic:(NSDictionary*)hintDic;

/**
 模型转json字符串
 @param hintDic 映射字典
 @note 映射规则：key是模型的key，value是json字符串的key
 */
- (NSString *)toJsonStrWithHintDic:(NSDictionary *)hintDic;

/**
 模型转模型
 @param jsonDic json字典
 @param hintDic 映射字典
 @note 映射规则：1.key是旧模型的key，value是新模型的key(属性间映射)
                                 2.key是新模型的key，value是json字典的key(新模型新属性映射)
 */
- (instancetype)toModel:(Class)class appendJsonDic:(NSDictionary *)jsonDic hintDic:(NSDictionary *)hintDic;
@end
