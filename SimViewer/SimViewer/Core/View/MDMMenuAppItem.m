//
//  MDMMenuAppItem.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/4.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuAppItem.h"

@implementation MDMMenuAppItem

- (instancetype)init {
    NSAssert(NO, @"please use -initWithAppModel: or +menuAppItemWithAppModel:");
    return nil;
}

- (instancetype)initWithAppModel:(MDMAppModel *)appModel {
    if (self = [super init]) {
        self.appModel = appModel;
        self.title = [NSString stringWithFormat:@"%@", appModel.displayName];
    }
    return self;
}

+ (instancetype)menuAppItemWithAppModel:(MDMAppModel *)appModel {
    return [[self alloc] initWithAppModel:appModel];
}

@end
