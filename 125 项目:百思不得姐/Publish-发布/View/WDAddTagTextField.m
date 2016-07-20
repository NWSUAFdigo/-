//
//  WDAddTagTextField.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/19.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDAddTagTextField.h"

@implementation WDAddTagTextField

/** 监听键盘删除键的点击 */
- (void)deleteBackward{
    
    // 首先调用删除block,在调用父类方法
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
}

@end
