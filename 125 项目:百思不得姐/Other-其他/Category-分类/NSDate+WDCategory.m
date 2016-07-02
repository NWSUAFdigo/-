//
//  NSDate+WDCategory.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/2.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "NSDate+WDCategory.h"

@implementation NSDate (WDCategory)

- (NSDateComponents *)wd_timeIntervalFromNow{
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calender components:unit fromDate:self toDate:nowDate options:0];
}


// 内部方法
/** 获取两个时间的 */
//- (NSDateComponents *)componentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate formatter:(NSDateFormatter *)formatter{
//    
//    
//}


- (BOOL)wd_isThisYear{
    
    // 对时间进行处理,只保留年份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    // 处理时间对象
    NSString *selfDateString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfDateString];
    
    NSDate *now = [NSDate date];
    NSString *nowDateString = [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowDateString];
    
    // 比较两个时间
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0;
}


- (BOOL)wd_isToday{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfDateString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfDateString];
    
    NSDate *now = [NSDate date];
    NSString *nowDateString = [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowDateString];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *components = [calender components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0 && components.month == 0 && components.day == 0;
}


- (BOOL)wd_isYesterday{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfDateString = [formatter stringFromDate:self];
    NSDate *selfDate = [formatter dateFromString:selfDateString];
    
    NSDate *now = [NSDate date];
    NSString *nowDateString = [formatter stringFromDate:now];
    NSDate *nowDate = [formatter dateFromString:nowDateString];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *components = [calender components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return components.year == 0 && components.month == 0 && components.day == 1;
}

@end
