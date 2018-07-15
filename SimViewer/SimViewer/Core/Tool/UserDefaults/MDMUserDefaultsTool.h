//
//  MDMUserDefaultsTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/15.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMUserDefaultsTool : NSObject

/**
 获取此时是否只加载启动模拟器，默认YES
 
 @return 返回状态
 */
+ (BOOL)getOnlyLoadBootedSimulatorStatus;

/**
 设置是否只加载
 @param status 状态
 */
+ (void)setOnlyLoadBootedSimulatorStatue:(BOOL)status;

@end
