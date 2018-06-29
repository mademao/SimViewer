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

@end
