//
//  UIView+Category.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}


- (CGFloat)width{
    
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}


- (CGFloat)height{
    
    return self.frame.size.height;
}


- (void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}


- (CGFloat)x{
    
    return self.frame.origin.x;
}


- (void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}


- (CGFloat)y{
    
    return self.frame.origin.y;
}


- (void)setSize:(CGSize)size{
    
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}


- (CGSize)size{
    
    return self.frame.size;
}


- (BOOL)isShowOnKeyWindow{
    
    // 转换self的frame到主窗口坐标系上
    CGRect convertRect = [[UIApplication sharedApplication].keyWindow convertRect:self.frame fromView:self.superview];
    
    // 判断转换后的frame和主窗口是否有交集
    BOOL isIntersects = CGRectIntersectsRect(convertRect, [UIApplication sharedApplication].keyWindow.bounds);
    
    
    // 判断self是否显示
    BOOL isShow = (self.hidden == NO);
    
    // 判断self的透明度是否大于0.01(小于等于0.01即透明)
    BOOL hasAlpha = (self.alpha > 0.01);
    
    // 只有上述三个BOOL值都为YES,才能表示视图显示在主窗口上
    return isIntersects && isShow && hasAlpha;
}


@end
