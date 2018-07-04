//
//  MDMSimulatorModel.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMSimulatorModel.h"

@implementation MDMSimulatorModel

- (instancetype)init {
    NSAssert(NO, @"please use -initWithOwnSimulatorGroupModel: or +simulatorModelWithOwnSimulatorGroupModel:");
    return nil;
}

- (instancetype)initWithOwnSimulatorGroupModel:(MDMSimulatorGroupModel *)ownSimulatorGroupModel {
    if (self = [super init]) {
        self.ownSimulatorGroupModel = ownSimulatorGroupModel;
    }
    return self;
}

+ (instancetype)simulatorModelWithOwnSimulatorGroupModel:(MDMSimulatorGroupModel *)ownSimulatorGroupModel {
    return [[self alloc] initWithOwnSimulatorGroupModel:ownSimulatorGroupModel];
}

@end
