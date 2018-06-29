//
//  MDMStringFormatTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMStringFormatTool.h"

@implementation MDMStringFormatTool

/*
 == Devices ==
 -- iOS 8.1 --
 iPhone 6 (25A783BF-E357-4954-AE6D-BF7095461E7C) (Booted)
 -- iOS 9.2 --
 -- iOS 10.1 --
 iPhone 5 (BCEBEFD8-92C7-4DF5-97CB-D544B423C935) (Shutdown)
 -- iOS 11.4 --
 iPhone 5s (7C1AAA12-7A9E-4077-B2B5-632C047C1F11) (Shutdown)
 -- tvOS 11.4 --
 Apple TV (0CFFA32C-48E1-4465-89D2-A73E66BCD11D) (Shutdown)
 -- watchOS 4.3 --
 Apple Watch - 38mm (4D2FD58C-A998-417A-AF55-57C33639A236) (Shutdown)
 -- Unavailable: com.apple.CoreSimulator.SimRuntime.iOS-11-3 --
 iPhone 5s (697B2589-6B3A-4FCB-8571-E5AE0DA49F56) (Shutdown) (unavailable, runtime profile not found)
 */
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)analyzeSimulatorInfoString:(NSString *)string {
    NSMutableDictionary *simulatorInfoDic = [NSMutableDictionary dictionary];
    
    //保存拆分结果
    NSArray *componentResult = nil;
    
    //去除 == Devices ==
    string = [string stringByReplacingOccurrencesOfString:@"== Devices ==\n" withString:@""];
    
    //去除 -- Unavailable 之后内容
    componentResult = [string componentsSeparatedByString:@"-- Unavailable"];
    if (componentResult.count < 1) {
        return simulatorInfoDic;
    }
    string = [componentResult firstObject];
    
    //以 "--" 进行拆分
    componentResult = [string componentsSeparatedByString:@"--"];
    
    NSString *osKey = nil;
    for (int i = 0; i < componentResult.count; i++) {
        NSString *componentString = [componentResult objectAtIndex:i];
        //componentResult第一个item为空字符串
        if (i % 2 == 1) {   //对应为运行系统
            componentString = [componentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            osKey = componentString;
            NSMutableArray *deviceArray = [NSMutableArray array];
            [simulatorInfoDic setObject:deviceArray forKey:osKey];
        } else {    //对应为设备
            NSMutableArray *deviceArray = [simulatorInfoDic objectForKey:osKey];
            NSArray *deviceStringArray = [componentString componentsSeparatedByString:@"\n"];
            for (NSString *deviceString in deviceStringArray) {
                if (deviceString.length > 0) {
                    [deviceArray addObject:deviceString];
                }
            }
        }
    }
    
    return simulatorInfoDic;
}

@end
