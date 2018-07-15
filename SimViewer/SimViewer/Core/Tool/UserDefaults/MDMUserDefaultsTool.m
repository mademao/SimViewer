//
//  MDMUserDefaultsTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/15.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMUserDefaultsTool.h"

static NSString * const MDMOnlyLoadBootedSimulatorStatusKey = @"MDMOnlyLoadBootedSimulatorStatusKey";

@implementation MDMUserDefaultsTool

///获取此时是否只加载启动模拟器
+ (BOOL)getOnlyLoadBootedSimulatorStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:MDMOnlyLoadBootedSimulatorStatusKey]) {
        return [[userDefaults objectForKey:MDMOnlyLoadBootedSimulatorStatusKey] boolValue];
    }
    return YES;
}

///设置是否只加载
+ (void)setOnlyLoadBootedSimulatorStatue:(BOOL)status {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:status] forKey:MDMOnlyLoadBootedSimulatorStatusKey];
    [userDefaults synchronize];
}

@end
