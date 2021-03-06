//
//  MDMAppModel.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/3.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMBaseModel.h"

@class MDMSimulatorModel;

@interface MDMAppModel : MDMBaseModel

///所属模拟器
@property (nonatomic, weak) MDMSimulatorModel *ownSimulatorModel;

///bundleIdentifier
@property (nonatomic, copy) NSString *bundleIdentifier;

///app名称
@property (nonatomic, copy) NSString *displayName;

///bundleName
@property (nonatomic, copy) NSString *bundleName;

///app图标
@property (nonatomic, strong) NSImage *appIconImage;

///最近修改时间
@property (nonatomic, assign) NSTimeInterval modifyDate;

///沙盒路径
@property (nonatomic, copy) NSString *sandboxPath;

- (instancetype)initWithOwnSimulatorModel:(MDMSimulatorModel *)ownSimulatorModel;
+ (instancetype)appModelWithOwnSimulatorModel:(MDMSimulatorModel *)ownSimulatorModel;

@end
