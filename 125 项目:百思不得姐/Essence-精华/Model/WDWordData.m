//
//  WDWordData.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDWordData.h"

@implementation WDWordData

- (NSString *)create_time{
    
    /*
     新浪微博对于微博发出时间的处理:
     发出时间距离当前时间
     
     1 1分钟以内 显示:刚刚
     2 1小时以内 显示:xx分钟前
     3 超过1小时但在今天发出 显示:xx小时前
     4 昨天发出 显示:(例)昨天 18:20
     5 昨天之前 -- 今年以内 显示:(例)07-18 10:19:16
     6 去年及以前 显示:(例)2014-09-19 10:19:16
     
     本例采用新浪微博的方式处理时间
     */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *creatDate = [formatter dateFromString:_create_time];
//    NSDate *creatDate = [formatter dateFromString:@"2015-07-02 20:45:00"];
    
    // 给NSDate添加分类,添加一些判断时间的方法
    if (creatDate.wd_isThisYear){ // 今年
        
        if (creatDate.wd_isToday) { // 今天
            
            NSDateComponents *components = [creatDate wd_timeIntervalFromNow];
            
            if (components.hour > 0) { // 超过1小时 -- 今天以内
                
                return [NSString stringWithFormat:@"%lu小时前", components.hour];
                
            }else { // 一小时以内
                
                if (components.minute > 0) { // 超过1分钟 -- 一小时以内
                    
                    return [NSString stringWithFormat:@"%lu分钟前", components.minute];
                    
                }else { // 一分钟以内
                    
                    return @"刚刚";
                }
            }
            
        }else if (creatDate.wd_isYesterday) { // 昨天
            
            NSDateFormatter *form = [[NSDateFormatter alloc] init];
            form.dateFormat = @"昨天 HH:mm:ss";
            
            return [form stringFromDate:creatDate];
            
        }else { // 昨天之前 -- 今年以内
            
            NSDateFormatter *form = [[NSDateFormatter alloc] init];
            form.dateFormat = @"MM-dd HH:mm:ss";
            
            return [form stringFromDate:creatDate];
        }
        
    }else { // 去年之前
        
        return _create_time;
    }

}

@end
