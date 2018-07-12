//
//  MDMXcrunTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//  xcrun 命令相关

#import <Foundation/Foundation.h>

@interface MDMXcrunTool : NSObject

/**
 获取所有模拟器信息
 @return 符合条件的模拟器信息，按运行系统分组
 */
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)getAllSimulatorInfo;

/**
 获取App沙盒路径
 @param simulatorIdentifier 所属模拟器identifier
 @param appIdentifier app的identifier
 
 @return app沙盒路径
 */
+ (NSString *)getSandboxPathWithSimulatorIdentifier:(NSString *)simulatorIdentifier appIdentifier:(NSString *)appIdentifier;

/**
 获取机器的顶层目录
 
 @return 机器顶层目录
 */
+ (NSString *)getHomeDirectory;

@end
