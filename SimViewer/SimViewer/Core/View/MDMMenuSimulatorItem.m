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
    NSAssert(YES, @"please use -initWithSimulatorGroupModel:simulatorModel: or +menuSimulatorItemWithSimulatorGroupModel:simulatorModel:");
    return nil;
}

- (instancetype)initWithSimulatorGroupModel:(MDMSimulatorGroupModel *)simulatorGroupModel simulatorModel:(MDMSimulatorModel *)simulatorModel {
    if (self = [super init]) {
        self.simulatorGroupModel = simulatorGroupModel;
        self.simulatorModel = simulatorModel;
    }
    return self;
}

+ (instancetype)menuSimulatorItemWithSimulatorGroupModel:(MDMSimulatorGroupModel *)simlatorGroupModel simulatorModel:(MDMSimulatorModel *)simulatorModel {
    return [[self alloc] initWithSimulatorGroupModel:simlatorGroupModel simulatorModel:simulatorModel];
}

@end
