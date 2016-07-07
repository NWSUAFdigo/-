//
//  UIImage+Category.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)originalImageWithName:(NSString *)name{
    
    UIImage *image = [UIImage imageNamed:name];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (UIImage *)zoomImageWithScale:(CGFloat)scale{
    
    // 通过位图上下文绘制图片,并返回
    // 计算缩放后的图片尺寸
    CGSize zoomSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(zoomSize);
    
    // 将图片绘制到上下文中
    [self drawInRect:CGRectMake(0, 0, zoomSize.width, zoomSize.height)];
    
    // 获取绘制后的图片
    UIImage *zoomImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return zoomImage;
}


@end
