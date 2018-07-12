//
//  MDMXcrunTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMXcrunTool.h"
#import "MDMTaskTool.h"
#import "MDMStringFormatTool.h"

#pragma mark - 一些参数

///xcrun命令所在位置
static NSString * const kMDMXcrunCommandPath = @"/usr/bin/xcrun";

///simctl参数
static NSString * const kMDMXcrunSimctlArgument = @"simctl";


#pragma mark - MDMXcrunTool

@implementation MDMXcrunTool

///获取所有模拟器信息
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)getAllSimulatorInfo {
    
    //xcrun simctl list 列出所有设备（同时会列出支持的机型和系统），devices代表只展示设备
    NSString *taskResult = [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"list", @"devices"]];
    
    //解析字符串
    NSDictionary *analyzeResult = [MDMStringFormatTool analyzeSimulatorInfoString:taskResult];
    
    return analyzeResult;
}

///获取App沙盒路径
+ (NSString *)getSandboxPathWithSimulatorIdentifier:(NSString *)simulatorIdentifier appIdentifier:(NSString *)appIdentifier; {
    if (simulatorIdentifier == nil || [simulatorIdentifier isEqualToString:@""] ||
        appIdentifier == nil || [appIdentifier isEqualToString:@""]) {
        return nil;
    }
    
    NSString *resultSandboxPath = nil;
    
    //xcrun simctl appinfo simidentifier appidentifier
    NSString *taskResult = [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"appinfo", simulatorIdentifier, appIdentifier]];
    //解析字符串
    NSDictionary *analyzeResult = [MDMStringFormatTool analyzeAppInfoString:taskResult];\
    
    if ([analyzeResult objectForKey:@"DataContainer"] &&
        ![[analyzeResult objectForKey:@"DataContainer"] isEqualToString:@""]) {
        //通过xcrun simctl获取没有启动的模拟器上的app信息时，会返回错误并返回为空
        resultSandboxPath = [analyzeResult objectForKey:@"DataContainer"];
    } else {
        //通过遍历Application目录下每个app文件夹，获取元数据进行bundle比较获取对应沙盒路径
        
        //拼接模拟器下data的Application目录路径
        NSString *applicationPath = [NSString stringWithFormat:@"%@/Library/Developer/CoreSimulator/Devices/%@/data/Containers/Data/Application", [self getHomeDirectory], simulatorIdentifier];
        //获取模拟器所属所有app的沙盒文件夹
        NSArray *sandboxPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:applicationPath error:nil];

        for (NSString *sandboxPath in sandboxPaths) {
            //拼接完整路径
            NSString *realSandboxPath = [applicationPath stringByAppendingPathComponent:sandboxPath];
            //拼接元数据文件路径
            NSString *metaDataPath = [realSandboxPath stringByAppendingPathComponent:@".com.apple.mobile_container_manager.metadata.plist"];
            //读取plist中bundleid
            NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:metaDataPath];
            if ([plistDic valueForKeyPath:@"MCMMetadataIdentifier"] &&
                [[plistDic valueForKeyPath:@"MCMMetadataIdentifier"] isEqualToString:appIdentifier]){
                resultSandboxPath = sandboxPath;
                break;
            }
        }
    }
    
    return resultSandboxPath;
}

///获取机器的顶层目录
+ (NSString *)getHomeDirectory {
    NSString *homeDirectory = NSHomeDirectory();
    //分割路径
    NSArray<NSString *> *pathArray = [homeDirectory componentsSeparatedByString:@"/"];
    NSString *realHomeDirectory;
    if (pathArray.count > 2) {
        realHomeDirectory = [NSString stringWithFormat:@"/%@/%@", [pathArray objectAtIndex:1], [pathArray objectAtIndex:2]];
    }
    return realHomeDirectory;
}

@end
