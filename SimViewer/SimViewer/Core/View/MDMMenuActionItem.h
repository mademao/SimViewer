//
//  MDMMenuActionItem.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMMenuAppItem.h"

@interface MDMMenuActionItem : NSMenuItem

///当前条目所属的AppItem
@property (nonatomic, weak) MDMMenuAppItem *appItem;

- (instancetype)initWithAppItem:(MDMMenuAppItem *)appItem;
+ (instancetype)menuActionItemWithAppItem:(MDMMenuAppItem *)appItem;

@end
