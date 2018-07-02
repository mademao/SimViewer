//
//  MDMThreadTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/7/2.
//  Copyright © 2018年 sogou. All rights reserved.
//

#import "MDMBaseModel.h"

static inline void MDMAsyncOnMainQueue(void(^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
