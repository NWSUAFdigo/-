//
//  NSDate+WDCategory.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/2.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WDCategory)

/** 计算调用该方法的时间对象和当前时间的时间间隔 */
- (NSDateComponents *)wd_timeIntervalFromNow;
/** 判断调用该方法的时间对象是否在今年 */
- (BOOL)wd_isThisYear;
/** 判断调用该方法的时间对象是否是今天 */
- (BOOL)wd_isToday;
/** 判断调用该方法的时间对象是否是昨天 */
- (BOOL)wd_isYesterday;

@end
