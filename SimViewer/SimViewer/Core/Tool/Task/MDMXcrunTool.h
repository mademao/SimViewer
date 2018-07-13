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

/**
 启动App
 @param appIdentifier 需要启动的App bundle
 @param simulatorIdentifier 需要启动App的模拟器 bundle
 */
+ (void)launchApp:(NSString *)appIdentifier onSimulator:(NSString *)simulatorIdentifier;

/**
 卸载App
 @param appIdentifier 需要卸载的App bundle
 @param simulatorIdentifier 需要卸载App的模拟器 bundle
 */
+ (void)uninstallApp:(NSString *)appIdentifier fromSimulator:(NSString *)simulatorIdentifier;

/**
 启动模拟器
 @param simulatorIdentifier 需要启动的模拟器 bundle
*/
+ (void)launchSimulator:(NSString *)simulatorIdentifier;
@end
