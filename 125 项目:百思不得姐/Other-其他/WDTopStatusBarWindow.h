//
//  WDTopStatusBarWindow.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/12.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTopStatusBarWindow : NSObject

/** 创建一个和状态栏尺寸位置一样的UIWindow,点击该Window,内容回滚到顶部 */
+ (void)showWithTapGesture;

@end
