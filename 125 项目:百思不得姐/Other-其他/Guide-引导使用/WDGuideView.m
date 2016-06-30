//
//  WDGuideView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/30.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDGuideView.h"

@implementation WDGuideView

+ (void)show{
    
    WDGuideView *view = [[self alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    view.frame = window.bounds;
    
    [window addSubview:view];
}

@end
