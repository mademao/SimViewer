//
//  AppDelegate.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/28.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "AppDelegate.h"
#import "MDMMenuTool.h"

@interface AppDelegate () <MDMMenuToolDelegate>

//状态栏item，此变量需要强引用，否则在释放之后同时从状态栏消失
@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //创建状态栏item
    //长度使用NSVariableStatusItemLength/NSSquareStatusItemLength
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"StatusItem"];
    self.statusItem.image.template = YES;
    //是否支持高亮模式
    self.statusItem.highlightMode = YES;
    //是否可交互
    self.statusItem.enabled = YES;
    //设置操作列表
    self.statusItem.menu = [[NSMenu alloc] init];
    [[MDMMenuTool sharedMenuTool] addDelegate:self];
    NSArray<NSMenuItem *> *itemList = [[MDMMenuTool sharedMenuTool] createMenuList];
    [self updateMenuWithItemList:itemList];
    //TODO:增加定时刷新，可考虑CFRunLoopObserverRef，在runloop即将改变的时候去改变
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

///更新列表
- (void)updateMenuWithItemList:(NSArray<NSMenuItem *> *)itemList {
    [self.statusItem.menu removeAllItems];
    for (NSMenuItem *menuItem in itemList) {
        [self.statusItem.menu addItem:menuItem];
    }
}


#pragma mark - MDMMenuToolDelegate

- (void)menuListDidChangedWithNewMenuList:(NSArray<NSMenuItem *> *)menuList {
    NSLog(@"-->");
    [self updateMenuWithItemList:menuList];
}


@end
