//
//  WDChannelCellData.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCellData.h"
#import <MJExtension.h>

@implementation WDChannelCellData
{
    // 给readonly属性添加成员变量
    CGFloat _cellHeight;
}


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


- (CGFloat)cellHeight{
    
    if (_cellHeight == 0) {
        
        // 在此计算出cell的高度
        
        // cell中只有文字内容的高度是不固定的,其他空间的尺寸都是固定的,所以需要计算出文字内容的高度
        // 文字的y值
        CGFloat contentTextLabelY = channelCellMargin + channelCellIconH + channelCellMargin;
        
        // 取出对应cell中的文字内容
        WDChannelCellData *data = self;
        
        NSString *text = data.text;
        
        // 给定一段文字,计算出文字在指定尺寸下的宽高
        // 指定文字的最大尺寸,其中宽度固定,高度设置为最大
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * channelCellMargin, MAXFLOAT);
        
        // 获得文字的真实尺寸,相当于得到bounds,而不是frame
        CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:0];
        
        CGFloat contentTextLabelH = rect.size.height;
        
        // 根据条件计算图片控件的高度
        CGFloat imageH = 0;
        
        // 如果模型数据为图片数据,那么计算图片的高度
        if (self.type == WDChannelPictureTypeIdentify) {
            
            CGFloat realWidth = [UIScreen mainScreen].bounds.size.width - 4 * channelCellMargin;
            
            imageH = _height / _width * realWidth;
            
            // 判断图片高度是否超过1000,如果超过,那么只显示250高度,并且点击图片查看全图
            if (imageH >= channelCellPictureMaxH) {
                
                imageH = channelCellPictureClipedH;
                
                self.cliped = YES;
            }
        }
        
        // 计算cell的真实高度
        CGFloat cellH = contentTextLabelY + contentTextLabelH + channelCellMargin + imageH + channelCellMargin +channelCellBottomBarH;
        
        // 计算出图片控件的frame
        self.imageFrame = CGRectMake(channelCellMargin, contentTextLabelY + contentTextLabelH + channelCellMargin, size.width, imageH);
        
        // 由于在WDChannelCell中将cell的高度减少了10点,因此需要在此将cell的高度增加10以便在cell布局时将这10点减掉
        _cellHeight = cellH + channelCellMargin;
    }
    return _cellHeight;
}


/** 使用MJExtension设置需要替换的属性名 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"smallImage" : @"image0",
             @"middleImage" : @"image2",
             @"bigImage" : @"image1"
             };
}


/** 也可以使用该方法进行属性名替换 */
/*
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    // 例:如果属性名为smallImage,那么它的key为image0
    if ([propertyName isEqualToString:@"smallImage"]) return @"image0";
    
    return propertyName;
}
 */

@end
