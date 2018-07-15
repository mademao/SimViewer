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
#import "MDMMenuGenericItem.h"

static const NSUInteger kMDMRecentAppCount = 5;
static NSString * const kMDMEmail = @"ismademao@gmail.com";

@interface MDMMenuTool ()

///代理数组
@property (nonatomic, strong) NSPointerArray *delegateArray;

@end

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

///增加为代理
- (void)addDelegate:(id<MDMMenuToolDelegate>)delegate {
    [self.delegateArray addPointer:NULL];
    [self.delegateArray compact];
    [self.delegateArray addPointer:(__bridge void * _Nullable)(delegate)];
}

///生成此刻所需展示列表
- (NSArray<NSMenuItem *> *)createMenuList {
    NSMutableArray<NSMenuItem *> *itemList = [NSMutableArray array];
    
    //获取此刻活动的模拟器
    NSArray<MDMSimulatorGroupModel *> *allSimulatorGroup = [MDMSimulatorTool getAllSimulatorGroupWithBooted:[MDMUserDefaultsTool getOnlyLoadBootedSimulatorStatus]];
    
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
    
    //生成通用操作列表
    [self p_createGenericItemWithItemList:itemList];
    
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
    
    //临时ActionItem条目变量。keyEquivalent大写时，快捷键为shift+command+key;keyEquivalent小写时，快捷键为command+key
    MDMMenuAppActionItem *menuAppActionItem = nil;
    
    //增加在Finder中打开沙盒
    menuAppActionItem = [MDMMenuAppActionItem menuAppActionItemWithAppItem:menuAppItem];
    menuAppActionItem.title = @"在Finder中打开";
    menuAppActionItem.keyEquivalent = @"f";
    menuAppActionItem.target = self;
    menuAppActionItem.action = @selector(openSandboxInFinder:);
    [menuAppItem.submenu addItem:menuAppActionItem];
    
    //增加重置沙盒
    menuAppActionItem = [MDMMenuAppActionItem menuAppActionItemWithAppItem:menuAppItem];
    menuAppActionItem.title = @"重置沙盒";
    menuAppActionItem.keyEquivalent = @"r";
    menuAppActionItem.target = self;
    menuAppActionItem.action = @selector(resetSandboxForApp:);
    [menuAppItem.submenu addItem:menuAppActionItem];
    
    //启动App
    menuAppActionItem = [MDMMenuAppActionItem menuAppActionItemWithAppItem:menuAppItem];
    menuAppActionItem.title = @"启动App";
    menuAppActionItem.keyEquivalent = @"l";
    menuAppActionItem.target = self;
    menuAppActionItem.action = @selector(lanuchApp:);
    [menuAppItem.submenu addItem:menuAppActionItem];
    
    //关闭App
    menuAppActionItem = [MDMMenuAppActionItem menuAppActionItemWithAppItem:menuAppItem];
    menuAppActionItem.title = @"关闭App";
    menuAppActionItem.keyEquivalent = @"t";
    menuAppActionItem.target = self;
    menuAppActionItem.action = @selector(terminateApp:);
    [menuAppItem.submenu addItem:menuAppActionItem];
    
    //增加卸载App
    menuAppActionItem = [MDMMenuAppActionItem menuAppActionItemWithAppItem:menuAppItem];
    menuAppActionItem.title = @"卸载App";
    menuAppActionItem.keyEquivalent = @"u";
    menuAppActionItem.target = self;
    menuAppActionItem.action = @selector(uninstallApp:);
    [menuAppItem.submenu addItem:menuAppActionItem];
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

///生成通用操作列表
- (void)p_createGenericItemWithItemList:(NSMutableArray<NSMenuItem *> *)itemList {
    if (itemList.count > 0) {
        [itemList addObject:[NSMenuItem separatorItem]];
    }
    
    //临时GenericItem条目变量。
    MDMMenuGenericItem *menuGenericItem = nil;
    
    //增加是否只加载启动模拟器
    BOOL status = [MDMUserDefaultsTool getOnlyLoadBootedSimulatorStatus];
    menuGenericItem = [[MDMMenuGenericItem alloc] init];
    menuGenericItem.title = [NSString stringWithFormat:@"只加载启动模拟器：%@", status == YES ? @"是" : @"否"];
    menuGenericItem.target = self;
    menuGenericItem.action = @selector(onlyLoadBootedSimulatorChange:);
    [itemList addObject:menuGenericItem];
    
    //增加反馈功能
    menuGenericItem = [[MDMMenuGenericItem alloc] init];
    menuGenericItem.title = @"意见反馈";
    menuGenericItem.target = self;
    menuGenericItem.action = @selector(sendFeedback:);
    [itemList addObject:menuGenericItem];
    
    //增加退出功能
    menuGenericItem = [[MDMMenuGenericItem alloc] init];
    menuGenericItem.title = @"退出";
    menuGenericItem.keyEquivalent = @"q";
    menuGenericItem.target = self;
    menuGenericItem.action = @selector(quitApp:);
    [itemList addObject:menuGenericItem];
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
- (void)openSandboxInFinder:(MDMMenuAppActionItem *)menuAppActionItem {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (menuAppActionItem.appItem.appModel.sandboxPath &&
            ![menuAppActionItem.appItem.appModel.sandboxPath isEqualToString:@""]) {
            //通过fileURLWithPath方法获取到带有file://前缀的路径
            [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:menuAppActionItem.appItem.appModel.sandboxPath]]];
        }
    });
}

///重置App沙盒
- (void)resetSandboxForApp:(MDMMenuAppActionItem *)menuAppActionItem {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //拼接沙盒目录下三个重要的文件夹以及Library下Caches、Preferences文件夹
        NSArray<NSString *> *subFolderPaths = @[[menuAppActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Documents"],
                                                [menuAppActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library"],
                                                [menuAppActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"tmp"],
                                                [menuAppActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library/Caches"],
                                                [menuAppActionItem.appItem.appModel.sandboxPath stringByAppendingPathComponent:@"Library/Preferences"],
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
    });
}

///启动App
- (void)lanuchApp:(MDMMenuAppActionItem *)menuAppActionItem {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MDMXcrunTool launchApp:menuAppActionItem.appItem.appModel.bundleIdentifier onSimulator:menuAppActionItem.appItem.appModel.ownSimulatorModel.identifier];
    });
}

///关闭App
- (void)terminateApp:(MDMMenuAppActionItem *)menuAppActionItem {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MDMXcrunTool terminateApp:menuAppActionItem.appItem.appModel.bundleIdentifier onSimulator:menuAppActionItem.appItem.appModel.ownSimulatorModel.identifier];
    });
}

///卸载App
- (void)uninstallApp:(MDMMenuAppActionItem *)menuAppActionItem {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MDMXcrunTool uninstallApp:menuAppActionItem.appItem.appModel.bundleIdentifier fromSimulator:menuAppActionItem.appItem.appModel.ownSimulatorModel.identifier];
    });
}

///是否只加载启动模拟器
- (void)onlyLoadBootedSimulatorChange:(MDMMenuGenericItem *)menuGenericItem {
    [MDMUserDefaultsTool setOnlyLoadBootedSimulatorStatue:![MDMUserDefaultsTool getOnlyLoadBootedSimulatorStatus]];
    if (self.delegateArray.count > 0) {
        [self asyncCreateMenuListWithBlock:^(NSArray<NSMenuItem *> *itemList) {
            for (id delegate in self.delegateArray) {
                if ([delegate respondsToSelector:@selector(menuListDidChangedWithNewMenuList:)]) {
                    [delegate menuListDidChangedWithNewMenuList:itemList];
                }
            }
        }];
    }
}

///反馈
- (void)sendFeedback:(MDMMenuGenericItem *)genericItem {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", kMDMEmail]]];
}

///退出
- (void)quitApp:(MDMMenuGenericItem *)genericItem {
    [NSApp terminate:self];
}


#pragma mark - lazy load

- (NSPointerArray *)delegateArray {
    if (_delegateArray == nil) {
        _delegateArray = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegateArray;
}

@end
