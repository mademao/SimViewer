//
//  main.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/28.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    //本项目旨在创建一个状态条常驻功能，不需要任何window，所以无需设置启动storyboard（即设置Main Interface为空）。
    //为了保证在没有启动storyboard的同时能正常运行项目，需要在此设置代理来保证启动
    NSApplication *application = [NSApplication sharedApplication];
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    application.delegate = appDelegate;
    
    //若要程序不在Dock中出现的话，需在Info.plist中设置 Application is agent (UIElement) 为 YES
    
    return NSApplicationMain(argc, argv);
}
