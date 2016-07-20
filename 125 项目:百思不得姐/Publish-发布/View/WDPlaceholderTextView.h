//
//  WDPlaceholderTextView.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/17.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDPlaceholderLabel;
@interface WDPlaceholderTextView : UITextView

/** 占位文字label */
@property (nonatomic,weak,readonly) WDPlaceholderLabel *placeholderLabel;

@end
