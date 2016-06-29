//
//  WDTextFieldThree.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTextFieldThree.h"

@implementation WDTextFieldThree

// 通过在该方法中重新绘制placeholder也可以对其进行设置
- (void)drawPlaceholderInRect:(CGRect)rect{
    
    [self.placeholder drawInRect:CGRectMake(0, 0, 50, 50) withAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
}

@end
