//
//  WDCornerRoundedButton.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDCornerRoundedButton.h"

@implementation WDCornerRoundedButton

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];
    
    [WDColor(44, 132, 246, 1) set];
    
    [path fill];
}

@end
