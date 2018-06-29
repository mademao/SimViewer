//
//  MDMTaskTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMTaskTool.h"

@implementation MDMTaskTool

#pragma mark - public methods

///执行命令，如果要执行沙盒之外的命令，需要在Capabilities中关闭App Sandbox选项
+ (NSString *)excute:(NSString *)commandPath arguments:(NSArray<NSString *> *)arguments {
    //初始化task
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:commandPath];
    [task setArguments:arguments];
    
    //设置输出参数
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    //设置读取句柄
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    
    //执行task
    [task launch];
    
    //读取数据
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return dataString;
}

@end
