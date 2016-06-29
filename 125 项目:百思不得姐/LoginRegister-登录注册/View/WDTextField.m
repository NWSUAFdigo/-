//
//  WDTextField.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTextField.h"
#import <objc/runtime.h>

@implementation WDTextField


// cursorColor的setter方法
- (void)setCursorColor:(UIColor *)cursorColor{
    
    _cursorColor = cursorColor;
    
    // 该属性可以设置光标颜色,当然也可以设置其他小模块的颜色
    self.tintColor = _cursorColor;
}

// placeholderColor属性的setter方法
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    
    [self setPlaceholderWithColor:_placeholderColor];
}


// 传入一个color,作为placeholder的文字颜色
- (void)setPlaceholderWithColor:(UIColor *)color{
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = color;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
}


// 重写becomeFirstResponder方法,对textField成为第一响应者后进行其他操作
- (BOOL)becomeFirstResponder{
    
    [self setPlaceholderWithColor:self.placeholderHighlightedColor];
    
    return [super becomeFirstResponder];
}


// 键盘退出时,需要将placeholder的文字颜色改为常规颜色
- (BOOL)resignFirstResponder{
    
    [self setPlaceholderWithColor:self.placeholderColor];
    
    return [super resignFirstResponder];
}


// 通过该方法可以对textField右侧清除按钮的位置和尺寸进行设置
// 传入的bounds为textField的bounds
//- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
//    
//    WDLog(@"%@", NSStringFromCGRect(bounds));
//    
//    return [super clearButtonRectForBounds:bounds];
//}

@end
