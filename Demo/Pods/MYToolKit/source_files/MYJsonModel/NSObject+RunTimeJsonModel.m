//
//  NSObject+RNJsonModel.m
//  MYJsonModel
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "NSObject+RunTimeJsonModel.h"
#import <objc/runtime.h>

@interface NSDictionary(FilterNull)
- (id)objectForKeyNotNull:(id)aKey;
@end
@implementation NSDictionary(FilterNull)
- (id)objectForKeyNotNull:(id)aKey{
    id value = [self objectForKey:aKey];
    return value == [NSNull null] ? nil : value;
}
@end


@implementation NSObject (RunTimeJsonModel)
//!!!!:json字典转模型
+ (instancetype)initWithJsonDic:(NSDictionary *)jsonDic hintDic:(NSDictionary *)hintDic{
    if(!jsonDic){
        return nil;
    }
    
    id obj = [[self alloc] init];
    [obj p_setValuesFrom:jsonDic hintDic:hintDic];
    return obj;
}

//!!!!:模型转json字典
- (NSDictionary *)toJsonDicWithHintDic:(NSDictionary *)hintDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for(int i = 0; i < count; i++){
        Ivar ivar = ivars[i];
        NSString *name =[NSString stringWithCString: ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        name = [name hasPrefix:@"_"] ? [name substringFromIndex:1] : name;
        NSString *value = [self valueForKey:name];
        
        if([hintDic.allKeys  containsObject:name]){
            name = [hintDic objectForKeyNotNull:name];
        }
        [dic setValue:value forKey:name];
    }
    return dic;
}

//!!!!:模型转json字符串
- (NSString *)toJsonStrWithHintDic:(NSDictionary *)hintDic{
    NSDictionary *dic = [self toJsonDicWithHintDic:hintDic];
    if(dic){
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    return nil;
}

//!!!!: 模型转模型
- (instancetype)toModel:(Class)class appendJsonDic:(NSDictionary *)jsonDic hintDic:(NSDictionary *)hintDic{
    NSMutableDictionary *dic = [self toJsonDicWithHintDic:hintDic].mutableCopy;//原字典
    //新数据
    [dic setValuesForKeysWithDictionary:jsonDic];
    
    id model = [[class alloc]init];
    [model p_setValuesFrom:dic hintDic:hintDic];
    return model;
}


- (void)p_setValuesFrom:(NSDictionary *)jsonDic hintDic:(NSDictionary *)hintDic{
    unsigned  int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for(int i = 0; i < count; i++){
        Ivar ivar = ivars[i];
        NSString *name =[NSString stringWithCString: ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        name = [name hasPrefix:@"_"] ? [name substringFromIndex:1] : name;
        NSString *type =[NSString stringWithCString: ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
        
        NSString *key = name;
        if([hintDic.allKeys containsObject:name]){
            key = [hintDic objectForKeyNotNull:name];
        }
        
        id value = [jsonDic objectForKeyNotNull:key];
        if(value){
            if([type containsString:@"String"]){
                value = [NSString stringWithFormat:@"%@", value];
            }
            [self setValue:value forKey:name];
        }
    }
}
@end
