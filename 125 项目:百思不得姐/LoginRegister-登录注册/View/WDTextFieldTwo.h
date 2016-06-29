//
//  WDTextFieldTwo.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTextFieldTwo : UITextField

/** 常规占位文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;
/** textField成为第一响应者后,占位文字的颜色 */
@property (nonatomic,strong) UIColor *placeholderHighlightedColor;
/** 设置光标颜色 */
@property (nonatomic,strong) UIColor *cursorColor;

@end
