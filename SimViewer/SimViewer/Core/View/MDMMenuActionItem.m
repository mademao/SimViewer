//
//  MDMMenuActionItem.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuActionItem.h"

@implementation MDMMenuActionItem

- (instancetype)init {
    NSAssert(YES, @"please use -initWithSimulatorModel: or +menuActionItemWithSimulatorModel:");
    return nil;
}

- (instancetype)initWithSimulatorModel:(MDMSimulatorModel *)simulatorModel {
    if (self = [super init]) {
        self.simulatorModel = simulatorModel;
    }
    return self;
}

+ (instancetype)menuActionItemWithSimulatorModel:(MDMSimulatorModel *)simlatorModel {
    return [[self alloc] initWithSimulatorModel:simlatorModel];
}

@end
