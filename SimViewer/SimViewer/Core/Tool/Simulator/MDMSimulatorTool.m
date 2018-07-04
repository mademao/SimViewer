//
//  MDMSimulatorTool.m
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMSimulatorTool.h"
#import "MDMXcrunTool.h"

@implementation MDMSimulatorTool

#pragma mark - public methods

///获取满足条件的所有模拟器
+ (NSArray<MDMSimulatorGroupModel *> *)getAllSimulatorGroupWithBooted:(BOOL)booted {
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroupArray = [self p_getAllSimulatorGroup];
    if (booted == NO) {
        return allSimulatorGroupArray;
    }
    
    //筛选启动的模拟器
    NSMutableArray<MDMSimulatorGroupModel *> *simulatorGroupArray = [NSMutableArray array];
    
    for (MDMSimulatorGroupModel *simulatorGroupModel in allSimulatorGroupArray) {
        NSMutableArray *bootedSimulatorArray = [NSMutableArray arrayWithCapacity:simulatorGroupModel.simulatorArray.count];
        for (MDMSimulatorModel *simulatorModel in simulatorGroupModel.simulatorArray) {
            if (simulatorModel.booted == YES) {
                [bootedSimulatorArray addObject:simulatorModel];
            }
        }
        
        //如果分组存在启动的模拟器，则构建并返回
        if (bootedSimulatorArray.count > 0) {
            MDMSimulatorGroupModel *newSimulatorGroupModel = [[MDMSimulatorGroupModel alloc] init];
            newSimulatorGroupModel.os = simulatorGroupModel.os;
            newSimulatorGroupModel.simulatorArray = [bootedSimulatorArray copy];
            
            [simulatorGroupArray addObject:newSimulatorGroupModel];
        }
    }
    
    return [simulatorGroupArray copy];
}

///获取模拟器下的APP
+ (NSArray<MDMAppModel *> *)getAllAppWithSimulatorModel:(MDMSimulatorModel *)simulatorModel {
    NSMutableArray<MDMAppModel *> *appsArray = [NSMutableArray array];
    //拼接模拟器下Application目录路径
    NSString *applicationPath = [NSString stringWithFormat:@"%@/Library/Developer/CoreSimulator/Devices/%@/data/Containers/Bundle/Application", [self p_getHomeDirectory], simulatorModel.identifier];
    
    //获取模拟器下所有App所处的文件夹
    NSArray<NSURL *> *appPathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:applicationPath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *appPath in appPathArray) {
        //生成对应App
        MDMAppModel *appModel = [self p_createAppModelWithAppPath:appPath.absoluteString];
        if (appModel) {
            [appsArray addObject:appModel];
        }
    }
    
    return [appsArray copy];
}


#pragma mark - private methods

///获得所有模拟器分类
+ (NSArray<MDMSimulatorGroupModel *> *)p_getAllSimulatorGroup {
    //获取模拟器分组字典信息
    NSDictionary<NSString *, NSArray<NSString *> *> *simulatorDic = [MDMXcrunTool getAllSimulatorInfo];
    
    NSMutableArray *simulatorGroupArray = [NSMutableArray array];
    
    //解析返回信息
    for (NSString *osKey in simulatorDic) {
        //模拟器分类模型
        MDMSimulatorGroupModel *simulatorGroupModel = [[MDMSimulatorGroupModel alloc] init];
        simulatorGroupModel.os = osKey;
        
        //解析分类中包含的模拟器
        NSArray<NSString *> *simulatorStringArray = [simulatorDic objectForKey:osKey];
        NSMutableArray *simulatorArray = [NSMutableArray arrayWithCapacity:simulatorStringArray.count];
        for (NSString *string in simulatorStringArray) {
            MDMSimulatorModel *simulatorModel = [self p_createSimulatorModelWithString:string];
            if (simulatorModel) {
                //读取模拟器中所有App
                simulatorModel.appArray = [self getAllAppWithSimulatorModel:simulatorModel];
                
                [simulatorArray addObject:simulatorModel];
            }
        }
        simulatorGroupModel.simulatorArray = [simulatorArray copy];
        
        //添加模拟器分组模型
        [simulatorGroupArray addObject:simulatorGroupModel];
    }
    
    //排序
    [simulatorGroupArray sortUsingComparator:^NSComparisonResult(MDMSimulatorGroupModel *obj1, MDMSimulatorGroupModel *obj2) {
        return (obj1.os.length > obj2.os.length) ? YES : NO;
    }];
    
    return [simulatorGroupArray copy];
}

/**
 根据字符串解析出对应的模拟器模型
 iPhone 5s (7C1AAA12-7A9E-4077-B2B5-632C047C1F11) (Shutdown)
 */
+ (MDMSimulatorModel *)p_createSimulatorModelWithString:(NSString *)string {
    NSArray *stringArray = [string componentsSeparatedByString:@" ("];
    if (stringArray.count < 3) {
        return nil;
    }
    
    MDMSimulatorModel *simulatorModel = [[MDMSimulatorModel alloc] init];
    simulatorModel.name = [stringArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    simulatorModel.identifier = [stringArray[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
    simulatorModel.booted = [[stringArray[2] lowercaseString] containsString:@"booted"];
    
    return simulatorModel;
}

///获取机器的顶层目录
+ (NSString *)p_getHomeDirectory {
    NSString *homeDirectory = NSHomeDirectory();
    //分割路径
    NSArray<NSString *> *pathArray = [homeDirectory componentsSeparatedByString:@"/"];
    NSString *realHomeDirectory;
    if (pathArray.count > 2) {
        realHomeDirectory = [NSString stringWithFormat:@"/%@/%@", [pathArray objectAtIndex:1], [pathArray objectAtIndex:2]];
    }
    return realHomeDirectory;
}

///根据App所在目录生成App信息
+ (MDMAppModel *)p_createAppModelWithAppPath:(NSString *)appPath {
    MDMAppModel *appModel = nil;
    
    //获取App目录下的所有文件
    NSArray<NSURL *> *filePathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:appPath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for (NSURL *filePath in filePathArray) {
        //进入.app文件中读取Info.plist
        if ([filePath.absoluteString hasSuffix:@".app"] ||
            [filePath.absoluteString hasSuffix:@".app/"]) {
            NSURL *appInfoPlistPath = [filePath URLByAppendingPathComponent:@"Info.plist"];
            NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfURL:appInfoPlistPath];
            
            appModel = [[MDMAppModel alloc] init];
            [appModel setValuesForKeysWithDictionary:infoDict];
        }
    }
    return appModel;
}

@end
