//
//  MDMSimulatorGroupModel.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"
#import "MDMSimulatorModel.h"

@interface MDMSimulatorGroupModel : MDMBaseModel

///分组所对应的运行系统
@property (nonatomic, copy) NSString *os;

///处于该运行系统分组下的模拟器
@property (nonatomic, copy) NSArray<MDMSimulatorModel *> *simulatorArray;

@end
