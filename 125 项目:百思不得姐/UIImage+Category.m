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

@end
