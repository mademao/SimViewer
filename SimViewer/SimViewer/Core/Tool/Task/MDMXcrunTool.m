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
    NSDictionary *analyzeResult = [MDMStringFormatTool analyzeAppInfoString:taskResult];
    
    if ([analyzeResult objectForKey:@"DataContainer"] &&
        ![[analyzeResult objectForKey:@"DataContainer"] isEqualToString:@""]) {
        //通过xcrun simctl获取没有启动的模拟器上的app信息时，会返回错误并返回为空
        resultSandboxPath = [analyzeResult objectForKey:@"DataContainer"];
        //避免存在file://前缀造成的NSFileManager访问失败
        if (resultSandboxPath && [resultSandboxPath hasPrefix:@"file://"]) {
            resultSandboxPath = [resultSandboxPath substringFromIndex:6];
        }
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
                resultSandboxPath = realSandboxPath;
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

///启动App
+ (void)launchApp:(NSString *)appIdentifier onSimulator:(NSString *)simulatorIdentifier {
    if (appIdentifier == nil || [appIdentifier isEqualToString:@""] ||
        simulatorIdentifier == nil || [simulatorIdentifier isEqualToString:@""]) {
        return;
    }
    
    //先启动模拟器
    [self launchSimulator:simulatorIdentifier];
    
    //xcrun simctl launch simulatorIdentifier appIdentifier
    [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"launch", simulatorIdentifier, appIdentifier]];
}

///关闭App
+ (void)terminateApp:(NSString *)appIdentifier onSimulator:(NSString *)simulatorIdentifier {
    if (appIdentifier == nil || [appIdentifier isEqualToString:@""] ||
        simulatorIdentifier == nil || [simulatorIdentifier isEqualToString:@""]) {
        return;
    }
    
    //xcrun simctl terminate simulatorIdentifier appIdentifier
    [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"terminate", simulatorIdentifier, appIdentifier]];
}

///卸载App
+ (void)uninstallApp:(NSString *)appIdentifier fromSimulator:(NSString *)simulatorIdentifier {
    if (appIdentifier == nil || [appIdentifier isEqualToString:@""] ||
        simulatorIdentifier == nil || [simulatorIdentifier isEqualToString:@""]) {
        return;
    }
    
    //xcrun simctl uninstall simulatorIdentifier appIdentifier
    [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"uninstall", simulatorIdentifier, appIdentifier]];
}

///启动模拟器
+ (void)launchSimulator:(NSString *)simulatorIdentifier {
    if (simulatorIdentifier == nil || [simulatorIdentifier isEqualToString:@""]) {
        return;
    }
    
    //先启动Simulator.app
    [self launchSimulatorApp];
    
    //xcrun simctl boot simulatorIdentifier
    [MDMTaskTool excute:kMDMXcrunCommandPath arguments:@[kMDMXcrunSimctlArgument, @"boot", simulatorIdentifier]];
}

///启动Simulator.app
+ (void)launchSimulatorApp {
    //open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
    NSString *open = [NSString stringWithFormat:@"open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"];
    const char *str = [open UTF8String];
    system(str);
}

@end
