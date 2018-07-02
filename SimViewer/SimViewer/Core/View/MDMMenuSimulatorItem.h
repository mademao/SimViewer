//
//  MDMMenuSimulatorItem.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMSimulatorGroupModel.h"

@interface MDMMenuSimulatorItem : NSMenuItem

///当前条目所属的SimulatorGroupModel
@property (nonnull, nonatomic, strong) MDMSimulatorGroupModel *simulatorGroupModel;
///当前条目所属的SimulatorModel
@property (nonnull, nonatomic, strong) MDMSimulatorModel *simulatorModel;

- (instancetype)initWithSimulatorGroupModel:(MDMSimulatorGroupModel *)simulatorGroupModel simulatorModel:(MDMSimulatorModel *)simulatorModel;
+ (instancetype)menuSimulatorItemWithSimulatorGroupModel:(MDMSimulatorGroupModel *)simlatorGroupModel simulatorModel:(MDMSimulatorModel *)simulatorModel;

@end
