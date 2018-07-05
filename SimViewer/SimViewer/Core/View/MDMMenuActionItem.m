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
    NSAssert(NO, @"please use -initWithAppItem: or +menuActionItemWithAppItem:");
    return nil;
}

- (instancetype)initWithAppItem:(MDMMenuAppItem *)appItem {
    if (self = [super init]) {
        self.appItem = appItem;
    }
    return self;
}

+ (instancetype)menuActionItemWithAppItem:(MDMMenuAppItem *)appItem {
    return [[self alloc] initWithAppItem:appItem];
}

@end
