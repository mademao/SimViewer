//
//  MDMMenuTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"
#import "MDMMenuSimulatorItem.h"
#import "MDMMenuActionItem.h"
#import "MDMMenuAppItem.h"
#import <Cocoa/Cocoa.h>

@interface MDMMenuTool : MDMBaseModel

///所需操作的NSStatusItem
@property (nonatomic, strong) NSStatusItem *statusItem;

///单例
+ (instancetype)sharedMenuTool;

/**
 生成此刻所需展示列表
 @return 生成的列表
 */
- (NSMenu *)createMenuList;

/**
 异步生成此刻所需展示列表
 @param block 异步生成回调
 */
- (void)asyncCreateMenuListWithBlock:(void(^)(NSMenu *))block;

@end
