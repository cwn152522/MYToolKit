//
//  NSObject+InitData.h
//  GuDaShi
//
//  Created by LOLITA on 2017/8/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (InitData)

// !!!!: 模型初始化
/**
 模型初始化
 @param moduleDic 模型字典
 @param hintDic 映射字典
 */
+(instancetype)objectWithModuleDic:(NSDictionary*)moduleDic hintDic:(NSDictionary*)hintDic;

// !!!!: 追加一些属性（覆盖）
/**
 追加一些属性（覆盖）
 @param propertyDic 属性字典
 @param hintDic 映射字典
 */
-(void)appendPropertyFromDic:(NSDictionary*)propertyDic hintDic:(NSDictionary*)hintDic;

// !!!!: 从模型中追加一些属性（覆盖）
/**
 从模型中追加一些属性（覆盖）
 @param model 来源模型
 @param hintDic 映射字典
 */
-(void)appendPropertyFromModel:(NSObject*)model hintDic:(NSDictionary*)hintDic;

// !!!!: 模型转字典
/**
 模型转字典
 @param hintDic 映射字典，如果不需要则nil
 */
-(NSDictionary*)changeToDictionaryWithHintDic:(NSDictionary*)hintDic;

// !!!!: 模型转json
/**
 模型转json
 @param hintDic 映射字典
 */
-(NSString*)changeToJsonStringWithHintDic:(NSDictionary*)hintDic;

// !!!!: 输出当前模型里的信息
/**
 输出当前模型里的信息
 */
-(NSDictionary*)descriptionInfo;

@end

