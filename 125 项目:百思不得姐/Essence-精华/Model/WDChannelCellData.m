//
//  WDChannelCellData.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCellData.h"
#import <MJExtension.h>
#import "WDChannelCellCommentData.h"
#import "WDChannelCellUserData.h"

@implementation WDChannelCellData
{
    // 给readonly属性添加成员变量
    CGFloat _cellHeight;
}


/** 设定数组中元素的类型(将数组中的元素转模型) */
//+ (NSDictionary *)mj_objectClassInArray{
//    
//    return @{@"top_cmt" : @"WDChannelCellCommentData"};
//}


// 重写数组的setter方法,使用MJExtension的字典转模型方法也可以达到转模型的目的
// 重写setter方法和使用mj_objectClassInArray方法二选其一即可
- (void)setTop_cmt:(WDChannelCellCommentData *)top_cmt{
    
//    _top_cmt = [WDChannelCellCommentData mj_objectArrayWithKeyValuesArray:top_cmt];
    // 由于在本类的mj_replacedKeyFromPropertyName方法中对top_cmt属性进行了映射
    // 所以不必再进行字典转模型
    _top_cmt = top_cmt;
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
        
        // 判断服务器返回的width和height是否为0
        if (_width != 0 && _height != 0) {
            
            // 如果模型数据为图片数据,那么计算图片的高度
            if (self.type == WDChannelPictureTypeIdentify) {
                
                CGFloat realWidth = [UIScreen mainScreen].bounds.size.width - 4 * channelCellMargin;
                
                imageH = _height / _width * realWidth;
                
                // 判断图片高度是否超过1000,如果超过,那么只显示250高度,并且点击图片查看全图
                if (imageH >= channelCellPictureMaxH) {
                    
                    imageH = channelCellPictureClipedH;
                    
                    self.cliped = YES;
                }
                
                // 给图片底部添加间距
                imageH += channelCellMargin;
            }
            else if (self.type == WDChannelAudioTypeIdentify) {
                
                CGFloat realWidth = [UIScreen mainScreen].bounds.size.width - 4 * channelCellMargin;
                
                imageH = _height / _width * realWidth;
                
                // 给图片底部添加间距
                imageH += channelCellMargin;
            }
            else if (self.type == WDChannelVideoTypeIdentify) {
                
                CGFloat realWidth = [UIScreen mainScreen].bounds.size.width - 4 * channelCellMargin;
                
                imageH = _height / _width * realWidth;
                
                // 给图片底部添加间距
                imageH += channelCellMargin;
            }
        }
        
        // 判断是否有热评,如果有,计算热评view的高度
        WDChannelCellCommentData *topcmtData = self.top_cmt;
        
        // 指定热评View的高度
        CGFloat hotcmtViewH = 0;
        
        if (topcmtData) {
            
            // 如果热评模型有值,取出热评用户模型
            WDChannelCellUserData *userData = topcmtData.user;
            
            // 拼接热评内容字符串
            NSString *hotcmtContent = [NSString stringWithFormat:@"%@: %@", userData.username, topcmtData.content];
            
            // 根据字符串,并指定字体大小和范围,计算字体所占高度
            CGSize contentMaxSize = size;
            CGRect contentRealSize = [hotcmtContent boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
            
            // 得到文字在指定范围的高度
            CGFloat contentH = contentRealSize.size.height;
            
            // 计算热评View的高度
            hotcmtViewH = channelCellMargin + contentH + channelCellMargin;
            
            // 给热评View的底部加上间距
            hotcmtViewH += channelCellMargin;
        }
        
        // 计算cell的真实高度
        CGFloat cellH = contentTextLabelY + contentTextLabelH + channelCellMargin + imageH + hotcmtViewH + channelCellBottomBarH;
        
        // 计算出图片控件的frame,将imageH中添加的底部间距去掉
        self.imageFrame = CGRectMake(channelCellMargin, contentTextLabelY + contentTextLabelH + channelCellMargin, size.width, imageH - channelCellMargin);
        
        // 计算出声音控件中图片的frame
        self.soundFrame = self.imageFrame;
        
        // 计算出视频控件的图片的frame
        self.videoFrame = self.imageFrame;
        
        // 获得热评视图的高度
        self.hotCmtViewH = hotcmtViewH;
        
        // 由于在WDChannelCell中将cell的高度减少了10点,因此需要在此将cell的高度增加10以便在cell布局时将这10点减掉
        _cellHeight = cellH + channelCellMargin;
    }
    return _cellHeight;
}


/** 使用MJExtension设置需要替换的属性名 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"smallImage" : @"image0",
             @"middleImage" : @"image2",
             @"bigImage" : @"image1",
             @"ID" : @"id",
             // 使用MJExtension可以将模型中的数组或字典中某个元素直接映射到模型内
             // 下面的例子就是将模型中的top_cmt数组的第0个元素映射到模型中的top_cmt属性中
             @"top_cmt" : @"top_cmt[0]"
             // 当然也可以对模型中的字典或数组中字典或数组元素映射到模型中,如下例
//             @"username" : @"top_cmt[0].user.username"
             // 由于已经有@"",所以使用.xx来代替@"xx"来访问字典的key
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
