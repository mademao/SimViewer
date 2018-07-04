//
//  MDMAppModel.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/3.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"

@interface MDMAppModel : MDMBaseModel

///bundleIdentifier
@property (nonatomic, copy) NSString *bundleIdentifier;

///app名称
@property (nonatomic, copy) NSString *displayName;

///bundleName
@property (nonatomic, copy) NSString *bundleName;

@end
