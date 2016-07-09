//
//  WDPublishView.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/7.
//  Copyright © 2016年 wudi. All rights reserved.
//

/*
 说明:
    如果想让发布窗口半透明,就不能使用Modal创建一个WDPublishViewController控制器
    因为控制器跳转时,系统会将跳转之前的控制器根视图从主窗口中移除
    而半透明效果是需要看到跳转之前的控制器根视图
    所以不能通过控制器跳转来实现半透明
 
    只能通过添加一个窗口(UIView)的方式实现半透明
 */

#import <UIKit/UIKit.h>

@interface WDPublishView : UIView

+ (instancetype)publishView;

@end
