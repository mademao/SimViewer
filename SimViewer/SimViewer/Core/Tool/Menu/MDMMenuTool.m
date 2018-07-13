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
#import "MDMXcrunTool.h"

static const NSUInteger kMDMRecentAppCount = 5;

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
- (NSArray<NSMenuItem *> *)createMenuList {
    NSMutableArray<NSMenuItem *> *itemList = [NSMutableArray array];
    
    //获取此刻活动的模拟器
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroup = [MDMSimulatorTool getAllSimulatorGroupWithBooted:NO];
    
    //最近活跃App数组
    NSMutableArray<MDMAppModel *> *recentAppModelArray = [NSMutableArray arrayWithCapacity:kMDMRecentAppCount];
    
    //模拟器操作条目数组
    NSMutableArray<MDMMenuSimulatorItem *> *menuSimulatorItemArray = [NSMutableArray array];
    
    //临时模拟器操作条目变量
    __block MDMMenuSimulatorItem *menuSimulatorItem = nil;
    
    //遍历模拟器分组
    [allSimulatorGroup enumerateObjectsUsingBlock:^(MDMSimulatorGroupModel * _Nonnull simulatorGroupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //遍历模拟器
        [simulatorGroupModel.simulatorArray enumerateObjectsUsingBlock:^(MDMSimulatorModel * _Nonnull simulatorModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            menuSimulatorItem = [[MDMMenuSimulatorItem alloc] initWithSimulatorModel:simulatorModel];
            
            [self p_addAppItemForMenuSimulatorItem:menuSimulatorItem];
            
            [menuSimulatorItemArray addObject:menuSimulatorItem];
            
            //处理是否为最近活跃
            [simulatorModel.appArray enumerateObjectsUsingBlock:^(MDMAppModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self p_addAppModel:obj toRecentAppArray:recentAppModelArray];
            }];
        }];
    }];
    
    //生成最近使用App列表
    //临时AppItem条目变量
    MDMMenuAppItem *menuAppItem = nil;
    
    //遍历增加AppItem
    for (MDMAppModel *appModel in recentAppModelArray) {
        menuAppItem = [[MDMMenuAppItem alloc] initWithAppModel:appModel showSimulatorInfo:YES];
        
        [self p_addActionItemForMenuAppItem:menuAppItem];
        
        [itemList addObject:menuAppItem];
    }
    
    if (recentAppModelArray.count > 0) {
        [itemList addObject:[NSMenuItem separatorItem]];
    }
    
    //生成模拟器列表
    for (MDMMenuSimulatorItem *simulatorItem in menuSimulatorItemArray) {
        [itemList addObject:simulatorItem];
    }
    
    return [itemList copy];
}

///异步生成此刻所需展示列表
- (void)asyncCreateMenuListWithBlock:(void(^)(NSArray<NSMenuItem *> *))block {
    dispatch_queue_t queue = [self p_defaultQueue];
    dispatch_async(queue, ^{
        NSArray<NSMenuItem *> *menuList = [self createMenuList];
        MDMAsyncOnMainQueue(^{
            block(menuList);
        });
    });
}


#pragma mark - private methods

///为MDMMenuSimulatorItem增加AppItem条目
- (void)p_addAppItemForMenuSimulatorItem:(MDMMenuSimulatorItem *)menuSimulatorItem {
    menuSimulatorItem.submenu = [[NSMenu alloc] init];
    
    //临时AppItem条目变量
    MDMMenuAppItem *menuAppItem = nil;
    
    //遍历增加AppItem
    for (MDMAppModel *appModel in menuSimulatorItem.simulatorModel.appArray) {
        menuAppItem = [[MDMMenuAppItem alloc] initWithAppModel:appModel showSimulatorInfo:NO];
        
        [self p_addActionItemForMenuAppItem:menuAppItem];
        
        [menuSimulatorItem.submenu addItem:menuAppItem];
    }
}

///为MDMMenuAppItem增加MDMMenuActionIte条目
- (void)p_addActionItemForMenuAppItem:(MDMMenuAppItem *)menuAppItem {
    menuAppItem.submenu = [[NSMenu alloc] init];
    
    //临时ActionItem条目变量
    MDMMenuActionItem *menuActionItem = nil;
    
    //增加在Finder中打开沙盒
    menuActionItem = [MDMMenuActionItem menuActionItemWithAppItem:menuAppItem];
    menuActionItem.title = @"在Finder中打开";
    menuActionItem.keyEquivalent = @"F";
    menuActionItem.target = self;
    menuActionItem.action = @selector(openSandboxInFinder:);
    [menuAppItem.submenu addItem:menuActionItem];
    
    //增加重置沙盒
    menuActionItem = [MDMMenuActionItem menuActionItemWithAppItem:menuAppItem];
    menuActionItem.title = @"重置沙盒";
    menuActionItem.keyEquivalent = @"R";
    menuActionItem.target = self;
    menuActionItem.action = @selector(resetSandboxForApp:);
    [menuAppItem.submenu addItem:menuActionItem];
    
    //增加卸载App
    menuActionItem = [MDMMenuActionItem menuActionItemWithAppItem:menuAppItem];
    menuActionItem.title = @"卸载App";
    menuActionItem.keyEquivalent = @"U";
    menuActionItem.target = self;
    menuActionItem.action = @selector(uninstallApp:);
    [menuAppItem.submenu addItem:menuActionItem];
}

///将AppModel插入最近使用数组中
- (void)p_addAppModel:(MDMAppModel *)appModel toRecentAppArray:(NSMutableArray<MDMAppModel *> *)recentAppArray {
    if (recentAppArray == nil) {
        return;
    }
    if (recentAppArray.count == 0) {
        [recentAppArray addObject:appModel];
    } else {
        [recentAppArray addObject:appModel];
        [recentAppArray sortUsingComparator:^NSComparisonResult(MDMAppModel *obj1, MDMAppModel *obj2) {
            return obj1.modifyDate <= obj2.modifyDate;
        }];
        if (recentAppArray.count > kMDMRecentAppCount) {
            [recentAppArray removeObjectsInRange:NSMakeRange(kMDMRecentAppCount - 1, recentAppArray.count - kMDMRecentAppCount)];
        }
    }
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

///在Finder中打开App沙盒
- (void)openSandboxInFinder:(MDMMenuActionItem *)menuActionItem {
    if (menuActionItem.appItem.appModel.sandboxPath &&
        ![menuActionItem.appItem.appModel.sandboxPath isEqualToString:@""]) {
        //通过fileURLWithPath方法获取到带有file://前缀的路径
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:menuActionItem.appItem.appModel.sandboxPath]]];
    }
}

///重置App沙盒
- (void)resetSandboxForApp:(MDMMenuActionItem *)menuActionItem {
    //拼接沙盒目录下三个重要的文件夹以及Library下Caches、Preferences文件夹
    NSArray<NSString *> *subFolderPaths = @[[menuActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Documents"],
                                            [menuActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library"],
                                            [menuActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"tmp"],
                                            [menuActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library/Caches"],
                                            [menuActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library/Preferences"],
                                            ];
    //清除文件夹下文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *folderPath in subFolderPaths) {
        if (folderPath) {
            NSArray<NSString *> *filePaths = [fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
            for (NSString *filePath in filePaths) {
                NSString *needRemovePath = [folderPath stringByAppendingPathComponent:filePath];
                //避免删除Library下的Caches和Preferences文件夹
                if ([needRemovePath hasSuffix:@"/Library/Caches"] ||
                    [needRemovePath hasSuffix:@"/Library/Preferences"]) {
                    continue;
                }
                [fileManager removeItemAtPath:needRemovePath error:NULL];
            }
        }
    }
}

///卸载App
- (void)uninstallApp:(MDMMenuActionItem *)menuActionItem {
    [MDMXcrunTool uninstallApp:menuActionItem.appItem.appModel.bundleIdentifier fromSimulator:menuActionItem.appItem.appModel.ownSimulatorModel.identifier];
}

@end
