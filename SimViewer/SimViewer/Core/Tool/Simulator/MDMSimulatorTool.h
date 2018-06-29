//
//  MDMSimulatorTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//  

#import <Foundation/Foundation.h>

@class MDMSimulatorGroupModel;

@interface MDMSimulatorTool : NSObject

/**
 获取满足条件的所有模拟器
 @param booted 是否是正在运行的
 @return 符合条件的模拟器数组
 */
+ (NSArray<MDMSimulatorGroupModel *> *)getAllSimulatorGroupWithBooted:(BOOL)booted;

@end
