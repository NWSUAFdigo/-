//
//  UIBarButtonItem+Category.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

/*
 说明:
    如果是对系统自带类进行分类,最好在分类的属性和方法名前加上一个前缀,如 wd_x,wd_width,wd_height
    由于本例中已经在大量的地方使用了自定义分类,所以暂不对之前添加的分类进行前缀添加
 */

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)

/** 创建一个UIButton类型的UIBarButtonItem */
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highImageName target:(id)target action:(SEL)selector;

@end
