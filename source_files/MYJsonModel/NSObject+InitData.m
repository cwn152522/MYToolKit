//
//  NSObject+InitData.m
//  GuDaShi
//
//  Created by LOLITA on 2017/8/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "NSObject+InitData.h"
#import <objc/runtime.h>
#import "NSDictionary+Utility.h"
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
@implementation NSObject (InitData)

// !!!!: 模型初始化
+(instancetype)objectWithModuleDic:(NSDictionary *)moduleDic hintDic:(NSDictionary *)hintDic{
    NSObject *instance = [[[self class] alloc] init];
    [instance appendPropertyFromDic:moduleDic hintDic:hintDic];
    return instance;
}

// !!!!: 追加一些属性（覆盖）
-(void)appendPropertyFromDic:(NSDictionary *)propertyDic hintDic:(NSDictionary *)hintDic{
    unsigned int numIvars; // 成员变量
    Ivar *vars = class_copyIvarList(self.class, &numIvars);
    NSString* key = nil;
    NSString *key_property = nil;  // 属性
    for (int i=0; i<numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];   // 获取成员变量的名称
        key = [key hasPrefix:@"_"]?[key substringFromIndex:1]:key;  // 去掉成员变量的头部下划线
        key_property = key;
        
        // 映射字典,转换key
        if (hintDic) {
            key = [hintDic objectForKey:key]?[hintDic objectForKey:key]:key;
        }
        
        id value = [propertyDic objectForKeyNotNull:key];
        //(避免定义字符串，接收的却是Number的优化，待测试)
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];//获取变量类型
        if(value){
            if([type containsString:@"NSString"]){
                [self setValue:[NSString stringWithFormat:@"%@", value] forKey:key_property];
            }else
                [self setValue:value forKey:key_property];
        }
    }
    free(vars);
}

// !!!!: 从模型中追加一些属性（覆盖）
-(void)appendPropertyFromModel:(NSObject *)model hintDic:(NSDictionary *)hintDic{
    NSDictionary* propertyDic = [model changeToDictionaryWithHintDic:nil];
    [self appendPropertyFromDic:propertyDic hintDic:hintDic];
}

// !!!!: 模型转字典
-(NSDictionary *)changeToDictionaryWithHintDic:(NSDictionary *)hintDic{
    NSMutableDictionary *resDic = [NSMutableDictionary dictionary];
    unsigned int numIvars; // 成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  // 获取成员变量的名字
        key = [key hasPrefix:@"_"]?[key substringFromIndex:1]:key;
        id value = [self valueForKey:key];
        if (value!=nil) {
            // 映射字典,转换key
            if (hintDic) {
                key = [hintDic objectForKey:key]?[hintDic objectForKey:key]:key;
            }
            [resDic setValue:value forKey:key];
        }
    }
    free(vars);
    return resDic;
}

// !!!!: 模型转josn
-(NSString *)changeToJsonStringWithHintDic:(NSDictionary *)hintDic{
    NSDictionary *resDic = [self changeToDictionaryWithHintDic:hintDic];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resDic options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

// !!!!: 输出当前模型里的信息
-(NSDictionary *)descriptionInfo{
    NSDictionary *dic = [self changeToDictionaryWithHintDic:nil];
    NSLog(@"%@",dic);
    return dic;
}

@end

