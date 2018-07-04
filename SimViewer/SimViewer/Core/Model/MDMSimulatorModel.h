//
//  MDMSimulatorModel.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"
#import "MDMAppModel.h"

@class MDMSimulatorGroupModel;

@interface MDMSimulatorModel : MDMBaseModel

///所属模拟器分类
@property (nonatomic, weak) MDMSimulatorGroupModel *ownSimulatorGroupModel;

///名称
@property (nonatomic, copy) NSString *name;

///标识
@property (nonatomic, copy) NSString *identifier;

///是否在运行
@property (nonatomic, assign) BOOL booted;

///当前模拟器下的App
@property (nonatomic, copy) NSArray<MDMAppModel *> *appArray;

- (instancetype)initWithOwnSimulatorGroupModel:(MDMSimulatorGroupModel *)ownSimulatorGroupModel;
+ (instancetype)simulatorModelWithOwnSimulatorGroupModel:(MDMSimulatorGroupModel *)ownSimulatorGroupModel;

@end
