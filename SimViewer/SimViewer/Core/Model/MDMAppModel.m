//
//  MDMAppModel.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/3.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMAppModel.h"

@implementation MDMAppModel

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
