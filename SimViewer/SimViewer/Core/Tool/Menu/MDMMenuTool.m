//
//  MDMMenuTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuTool.h"
#import "MDMThreadTool.h"
#import "MDMSimulatorTool.h"

@implementation MDMMenuTool

#pragma mark - public methods

///单例
static MDMMenuTool *tool = nil;
+ (instancetype)sharedMenuTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[MDMMenuTool alloc] init];
    });
    return tool;
}

///生成此刻所需展示列表
- (NSMenu *)createMenuList {
    NSMenu *menu = [[NSMenu alloc] init];
    
    //获取此刻活动的模拟器
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroup = [MDMSimulatorTool getAllSimulatorGroupWithBooted:YES];
    
    //临时操作条目变量
    __block MDMMenuSimulatorItem *menuSimulatorItem = nil;
    
    //遍历模拟器分组
    [allSimulatorGroup enumerateObjectsUsingBlock:^(MDMSimulatorGroupModel * _Nonnull simulatorGroupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //遍历模拟器
        [simulatorGroupModel.simulatorArray enumerateObjectsUsingBlock:^(MDMSimulatorModel * _Nonnull simulatorModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            menuSimulatorItem = [[MDMMenuSimulatorItem alloc] initWithSimulatorModel:simulatorModel];
            menuSimulatorItem.title = [NSString stringWithFormat:@"%@ (%@)", simulatorModel.name, simulatorGroupModel.os];
            
            
            [menu addItem:menuSimulatorItem];
        }];
    }];
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    return menu;
}

///异步生成此刻所需展示列表
- (void)asyncCreateMenuListWithBlock:(void(^)(NSMenu *))block {
    dispatch_queue_t queue = [self p_defaultQueue];
    dispatch_async(queue, ^{
        NSMenu *menu = [self createMenuList];
        MDMAsyncOnMainQueue(^{
            block(menu);
        });
    });
}


#pragma mark - private methods

///为MDMMenuSimulatorItem增加操作
- (void)p_addActionItemForMenuSimulatorItem:(MDMMenuSimulatorItem *)menuSimulatorItem {
    menuSimulatorItem.submenu = [[NSMenu alloc] init];
    
    //临时操作条目变量
    MDMMenuActionItem *menuActionItem = nil;
    
    //增加Finder打开沙盒
    menuActionItem = [[MDMMenuActionItem alloc] initWithSimulatorModel:menuSimulatorItem.simulatorModel];
    menuActionItem.title = @"Open sandbox in Finder";
    menuActionItem.target = self;
    menuActionItem.action = @selector(openSandboxInFinder:);
    menuActionItem.keyEquivalent = @"F";
    [menuSimulatorItem.submenu addItem:menuActionItem];
}

static dispatch_queue_t queue = NULL;
///生成默认队列
- (dispatch_queue_t)p_defaultQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.pluto.MenuTool", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}


#pragma mark - MenuActionItem action

- (void)openSandboxInFinder:(MDMMenuActionItem *)menuActionItem {
    
}

@end
