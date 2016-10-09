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


- (UIImage *)circleImage{
    
    // 为保证绘制出来的图形为圆形,使用宽度或高度的最小值来作为半径进行绘制
    CGFloat imageWH = MIN(self.size.width, self.size.height);
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWH, imageWH), NO, 0);
    
    // 创建一个椭圆贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageWH, imageWH)];
    
    // 添加剪切
    [path addClip];
    
    // 添加图片
    [self drawInRect:CGRectMake(0, 0, imageWH, imageWH)];
    
    // 获得裁切后图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (UIImage *)wd_imageNamed:(NSString *)name{
    
    // 从沙盒中取出当前主题
    NSString *theme = [[NSUserDefaults standardUserDefaults] stringForKey:@"theme"];
    
    // 拼接文件在沙盒中的路径
    NSString *filePath = [NSString stringWithFormat:@"skins/%@", [theme stringByAppendingPathComponent:name]];
    
    // 获取文件全路径
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"png"];
    
    return [UIImage imageWithContentsOfFile:filePath];
}


@end
