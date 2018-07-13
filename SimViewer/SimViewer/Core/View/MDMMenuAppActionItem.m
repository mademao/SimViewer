//
//  MDMMenuActionItem.m
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuAppActionItem.h"

@implementation MDMMenuAppActionItem

- (instancetype)init {
    NSAssert(NO, @"please use -initWithAppItem: or +menuAppActionItemWithAppItem:");
    return nil;
}

- (instancetype)initWithAppItem:(MDMMenuAppItem *)appItem {
    if (self = [super init]) {
        self.appItem = appItem;
    }
    return self;
}

+ (instancetype)menuAppActionItemWithAppItem:(MDMMenuAppItem *)appItem {
    return [[self alloc] initWithAppItem:appItem];
}

@end
