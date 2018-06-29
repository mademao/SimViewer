//
//  MDMMenuTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMMenuTool.h"

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
    //TODO: 06.29
    return menu;
}

@end
