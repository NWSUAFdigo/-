//
//  UIBarButtonItem+Category.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "UIBarButtonItem+Category.h"

@implementation UIBarButtonItem (Category)

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highImageName target:(id)target action:(SEL)selector{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    btn.size = btn.currentImage.size;
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
