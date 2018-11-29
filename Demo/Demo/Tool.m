//
//  Tool.m/Users/cwn/Desktop/混淆工具/DaYangXian/Pods/STCObfuscator
//  Demo
//
//  Created by cwn on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "Tool.h"

@implementation Tool
+ (int)searchIBInPath:(NSString *)path pattern:(NSString *)pattern
{
    static int fileCount = 0;
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                 [self searchIBInPath:subPath pattern:pattern];
            }
        }else{
            if ([path hasSuffix:@".xib"]
                ||[path hasSuffix:@".storyboard"]) {
                if(pattern.length){
                    if([self readFileToCheckHardCodeStringWithPath:path pattern:pattern])
                        fileCount ++;
                }else{
                    fileCount ++;
                }
            } else {
                return  0;
            }
        }
    }
    return fileCount;
}

+ (BOOL)readFileToCheckHardCodeStringWithPath:(NSString *)path pattern:(NSString *)pattern;
{
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];

    if([result rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound){
        return YES;
    }
    return NO;
}
@end
