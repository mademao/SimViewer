//
//  MDMSimulatorTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMSimulatorTool.h"
#import "MDMXcrunTool.h"
#import "MDMSimulatorGroupModel.h"

@implementation MDMSimulatorTool

///获取所有模拟器
+ (NSArray<MDMSimulatorGroupModel *> *)getAllSimulatorWithBooted:(BOOL)booted {
    NSDictionary *simulatorDic = [MDMXcrunTool getAllSimulatorInfoWithBooted:booted];
    NSMutableArray *simulatorArray = [NSMutableArray array];
    for (NSString *osKey in simulatorDic) {

    }
    return [simulatorArray copy];
}

@end
