//
//  WDAddTagTextField.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/19.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDAddTagTextField : UITextField

/** 点击删除按钮后调用的block */
@property (nonatomic,copy) void(^deleteBlock)();

@end
