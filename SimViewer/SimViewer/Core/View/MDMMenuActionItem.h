//
//  MDMMenuActionItem.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMSimulatorModel.h"

@interface MDMMenuActionItem : NSMenuItem

///当前条目所属的SimulatorModel
@property (nonnull, nonatomic, strong) MDMSimulatorModel *simulatorModel;

- (instancetype)initWithSimulatorModel:(MDMSimulatorModel *)simulatorModel;
+ (instancetype)menuActionItemWithSimulatorModel:(MDMSimulatorModel *)simlatorModel;

@end
