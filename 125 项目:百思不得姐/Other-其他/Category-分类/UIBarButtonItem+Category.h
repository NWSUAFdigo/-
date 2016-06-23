//
//  UIBarButtonItem+Category.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)

/** 创建一个UIButton类型的UIBarButtonItem */
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highImageName target:(id)target action:(SEL)selector;

@end
