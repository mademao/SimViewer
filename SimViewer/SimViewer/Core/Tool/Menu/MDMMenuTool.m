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
    
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroup = [MDMSimulatorTool getAllSimulatorGroupWithBooted:YES];
    
    __block NSMenuItem *menuItem = nil;
    
    [allSimulatorGroup enumerateObjectsUsingBlock:^(MDMSimulatorGroupModel * _Nonnull simulatorGroupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [simulatorGroupModel.simulatorArray enumerateObjectsUsingBlock:^(MDMSimulatorModel * _Nonnull simulatorModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            menuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%@)", simulatorModel.name, simulatorGroupModel.os] action:nil keyEquivalent:@""];
            //TODO:7.2
            [menu addItem:menuItem];
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

static dispatch_queue_t queue = NULL;
///生成默认队列
- (dispatch_queue_t)p_defaultQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.pluto.MenuTool", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

@end
