//
//  AppDelegate.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/28.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

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
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
