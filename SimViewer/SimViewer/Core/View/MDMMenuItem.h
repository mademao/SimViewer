//
//  MDMMenuItem.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMSimulatorModel.h"

@interface MDMMenuItem : NSMenuItem

///当前条目对应的SimulatorModel
@property (nullable, nonatomic, strong) MDMSimulatorModel *simulatorModel;

@end
