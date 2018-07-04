//
//  MDMMenuAppItem.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/4.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMSimulatorGroupModel.h"

@interface MDMMenuAppItem : NSMenuItem

///当前条目所属的AppModel
@property (nonnull, nonatomic, strong) MDMAppModel *appModel;

- (instancetype)initWithAppModel:(MDMAppModel *)appModel;
+ (instancetype)menuAppItemWithAppModel:(MDMAppModel *)appModel;

@end
