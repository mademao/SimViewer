//
//  MDMAppModel.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/3.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMAppModel.h"
#import "MDMXcrunTool.h"
#import "MDMSimulatorModel.h"

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

- (NSDictionary *)otherInfo {
    if (_otherInfo == nil) {
        _otherInfo = [MDMXcrunTool getSandboxPathWithSimulatorIdentifier:self.ownSimulatorModel.identifier appIdentifier:self.bundleIdentifier];
    }
    return _otherInfo;
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
