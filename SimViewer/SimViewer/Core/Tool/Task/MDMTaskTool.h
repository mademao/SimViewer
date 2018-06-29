//
//  MDMTaskTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//  Task工具类

#import <Foundation/Foundation.h>

@interface MDMTaskTool : NSObject

/**
 执行命令
 @param commandPath 命令工具所在位置
 @param arguments 命令参数
 @return 执行命令返回结果
 */
+ (NSString *)excute:(NSString *)commandPath arguments:(NSArray<NSString *> *)arguments;

@end
