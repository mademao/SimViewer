//
//  MDMSimulatorTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMSimulatorTool.h"
#import "MDMXcrunTool.h"

@implementation MDMSimulatorTool

#pragma mark - public methods

///获取满足条件的所有模拟器
+ (NSArray<MDMSimulatorGroupModel *> *)getAllSimulatorGroupWithBooted:(BOOL)booted {
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroupArray = [self p_getAllSimulatorGroup];
    if (booted == NO) {
        return allSimulatorGroupArray;
    }
    
    //筛选启动的模拟器
    NSMutableArray *simulatorGroupArray = [NSMutableArray array];
    
    for (MDMSimulatorGroupModel *simulatorGroupModel in allSimulatorGroupArray) {
        NSMutableArray *bootedSimulatorArray = [NSMutableArray arrayWithCapacity:simulatorGroupModel.simulatorArray.count];
        for (MDMSimulatorModel *simulatorModel in simulatorGroupModel.simulatorArray) {
            if (simulatorModel.booted == YES) {
                [bootedSimulatorArray addObject:simulatorModel];
            }
        }
        
        //如果分组存在启动的模拟器，则构建并返回
        if (bootedSimulatorArray.count > 0) {
            MDMSimulatorGroupModel *newSimulatorGroupModel = [[MDMSimulatorGroupModel alloc] init];
            newSimulatorGroupModel.os = simulatorGroupModel.os;
            newSimulatorGroupModel.simulatorArray = [bootedSimulatorArray copy];
            
            [simulatorGroupArray addObject:newSimulatorGroupModel];
        }
    }
    
    return [simulatorGroupArray copy];
}


#pragma mark - private methods

///获得所有模拟器分类
+ (NSArray<MDMSimulatorGroupModel *> *)p_getAllSimulatorGroup {
    //获取模拟器分组字典信息
    NSDictionary<NSString *, NSArray<NSString *> *> *simulatorDic = [MDMXcrunTool getAllSimulatorInfo];
    
    NSMutableArray *simulatorGroupArray = [NSMutableArray array];
    
    //解析返回信息
    for (NSString *osKey in simulatorDic) {
        //模拟器分类模型
        MDMSimulatorGroupModel *simulatorGroupModel = [[MDMSimulatorGroupModel alloc] init];
        simulatorGroupModel.os = osKey;
        
        //接卸分类中包含的模拟器
        NSArray<NSString *> *simulatorStringArray = [simulatorDic objectForKey:osKey];
        NSMutableArray *simulatorArray = [NSMutableArray arrayWithCapacity:simulatorStringArray.count];
        for (NSString *string in simulatorStringArray) {
            MDMSimulatorModel *simulatorModel = [self p_createSimulatorModelWithString:string];
            if (simulatorModel) [simulatorArray addObject:simulatorModel];
        }
        simulatorGroupModel.simulatorArray = [simulatorArray copy];
        
        //添加模拟器分组模型
        [simulatorGroupArray addObject:simulatorGroupModel];
    }
    
    //排序
    [simulatorGroupArray sortUsingComparator:^NSComparisonResult(MDMSimulatorGroupModel *obj1, MDMSimulatorGroupModel *obj2) {
        return (obj1.os.length > obj2.os.length) ? YES : NO;
    }];
    
    return [simulatorGroupArray copy];
}

/**
 根据字符串解析出对应的模拟器模型
 iPhone 5s (7C1AAA12-7A9E-4077-B2B5-632C047C1F11) (Shutdown)
 */
+ (MDMSimulatorModel *)p_createSimulatorModelWithString:(NSString *)string {
    NSArray *stringArray = [string componentsSeparatedByString:@" ("];
    if (stringArray.count < 3) {
        return nil;
    }
    
    MDMSimulatorModel *simulatorModel = [[MDMSimulatorModel alloc] init];
    simulatorModel.name = [stringArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    simulatorModel.identifier = [stringArray[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
    simulatorModel.booted = [[stringArray[2] lowercaseString] containsString:@"booted"];
    
    return simulatorModel;
}

@end
