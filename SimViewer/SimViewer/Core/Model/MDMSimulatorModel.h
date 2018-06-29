//
//  MDMSimulatorModel.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"

@interface MDMSimulatorModel : MDMBaseModel

///名称
@property (nonatomic, copy) NSString *name;

///标识
@property (nonatomic, copy) NSString *identifier;

///是否在运行
@property (nonatomic, assign) BOOL booted;

@end
