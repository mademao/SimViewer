//
//  MDMMenuAppItem.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/4.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuAppItem.h"

static CGFloat const MDMMenuAppItemIconLength = 20.0;

@implementation MDMMenuAppItem

- (instancetype)init {
    NSAssert(NO, @"please use -initWithAppModel:showSimulatorInfo: or +menuAppItemWithAppModel:showSimulatorInfo:");
    return nil;
}

- (instancetype)initWithAppModel:(MDMAppModel *)appModel showSimulatorInfo:(BOOL)showSimulatorInfo {
    if (self = [super init]) {
        self.appModel = appModel;
        if (showSimulatorInfo) {
            self.title = [NSString stringWithFormat:@"%@-%@ (%@-%@)", @(arc4random() % 10), appModel.displayName, appModel.ownSimulatorModel.name, appModel.ownSimulatorModel.ownSimulatorGroupModel.os];
        } else {
            self.title = [NSString stringWithFormat:@"%@", appModel.displayName];
        }
        self.image = appModel.appIconImage;
        self.image.size = NSMakeSize(MDMMenuAppItemIconLength, MDMMenuAppItemIconLength);
    }
    return self;
}

+ (instancetype)menuAppItemWithAppModel:(MDMAppModel *)appModel showSimulatorInfo:(BOOL)showSimulatorInfo {
    return [[self alloc] initWithAppModel:appModel showSimulatorInfo:showSimulatorInfo];
}

@end
