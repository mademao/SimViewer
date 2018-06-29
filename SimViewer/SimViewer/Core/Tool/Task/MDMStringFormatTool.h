//
//  MDMStringFormatTool.h
//  SimViewer
//
//  Created by 马德茂 on 2018/6/29.
//  Copyright © 2018年 sogou. All rights reserved.
//  从字符串中筛选所需信息工具类

#import <Foundation/Foundation.h>

@interface MDMStringFormatTool : NSObject

/**
 解析模拟器信息字符串
 @param string 模拟器信息字符串
 @return 解析结果
 */
+ (NSDictionary *)analyzeSimulatorInfoString:(NSString *)string;

@end
