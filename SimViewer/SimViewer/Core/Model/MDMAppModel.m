//
//  MDMAppModel.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/3.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMAppModel.h"

@implementation MDMAppModel

- (instancetype)init {
    NSAssert(NO, @"please use -initWithOwnSimulatorModel: or +appModelWithOwnSimulatorModel:");
    return nil;
}

- (instancetype)initWithOwnSimulatorModel:(MDMSimulatorModel *)ownSimulatorModel {
    if (self = [super init]) {
        self.ownSimulatorModel = ownSimulatorModel;
    }
    return self;
}

+ (instancetype)appModelWithOwnSimulatorModel:(MDMSimulatorModel *)ownSimulatorModel {
    return [[self alloc] initWithOwnSimulatorModel:ownSimulatorModel];
}

- (NSString *)displayName {
    if (_displayName == nil || [_displayName isEqualToString:@""]) {
        return self.bundleName;
    }
    return _displayName;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"CFBundleDisplayName"]) {
        self.displayName = value;
    } else if ([key isEqualToString:@"CFBundleName"]) {
        self.bundleName = value;
    } else if ([key isEqualToString:@"CFBundleIdentifier"]) {
        self.bundleIdentifier = value;
    }
}

@end
