//
//  MDMMenuSimulatorItem.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuSimulatorItem.h"

@implementation MDMMenuSimulatorItem

- (instancetype)init {
    NSAssert(NO, @"please use -initWithSimulatorModel: or +menuSimulatorModel:");
    return nil;
}

- (instancetype)initWithSimulatorModel:(MDMSimulatorModel *)simulatorModel {
    if (self = [super init]) {
        self.simulatorModel = simulatorModel;
    }
    return self;
}

+ (instancetype)menuSimulatorItemWithSimulatorModel:(MDMSimulatorModel *)simulatorModel {
    return [[self alloc] initWithSimulatorModel:simulatorModel];
}

@end
