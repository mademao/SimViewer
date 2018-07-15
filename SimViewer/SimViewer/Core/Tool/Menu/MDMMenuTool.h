//
//  MDMMenuTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"
#import "MDMMenuSimulatorItem.h"
#import "MDMMenuAppActionItem.h"
#import "MDMMenuAppItem.h"
#import "MDMUserDefaultsTool.h"
#import <Cocoa/Cocoa.h>

@protocol MDMMenuToolDelegate <NSObject>

///条目发生变化
- (void)menuListDidChangedWithNewMenuList:(NSArray<NSMenuItem *> *)menuList;

@end

@interface MDMMenuTool : MDMBaseModel

///所需操作的NSStatusItem
@property (nonatomic, strong) NSStatusItem *statusItem;

///单例
+ (instancetype)sharedMenuTool;

///增加为代理
- (void)addDelegate:(id<MDMMenuToolDelegate>)delegate;

/**
 生成此刻所需展示列表
 @return 生成的列表
 */
- (NSArray<NSMenuItem *> *)createMenuList;

/**
 异步生成此刻所需展示列表
 @param block 异步生成回调
 */
- (void)asyncCreateMenuListWithBlock:(void(^)(NSArray<NSMenuItem *> *))block;

@end
