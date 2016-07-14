//
//  UIView+Category.h
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

@interface UIView (Category)

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGSize size;

/*
 注意:
    在分类中使用@property是不会生成成员变量的
    并且只会生成相应getter方法和setter方法的声明,没有实现
 */


/** 判断一个UIView是否显示在主窗口上 */
- (BOOL)isShowOnKeyWindow;

@end
