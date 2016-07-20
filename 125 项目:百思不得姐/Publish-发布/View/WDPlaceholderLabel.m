//
//  WDPlaceholderLabel.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDPlaceholderLabel.h"

@implementation WDPlaceholderLabel

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    [self sizeToFit];
    
    // 将textView的font进行修改
    if ([self.superview isKindOfClass:[UITextView class]]) {
        
        UITextView *superView = (UITextView *)self.superview;
        
        // 判断两个font属性是否相同,如果相同,则直接返回
        if (superView.font != self.font) {
            
            superView.font = self.font;
        }
    }
}


- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    [self sizeToFit];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
//    [self sizeToFit];
    // 注意: sizeToFit会调用self的layoutSubviews方法,因此在此处如果调用sizeToFit,会造成死循环
}

@end
