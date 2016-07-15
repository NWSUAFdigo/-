//
//  WDMeFooterButton.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDMeFooterButton.h"
#import "WDMeFooterViewData.h"
#import <UIButton+WebCache.h>

@implementation WDMeFooterButton

- (void)awakeFromNib{
    
    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}


- (void)setup{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    self.backgroundColor = [UIColor whiteColor];
}


/** 重新布局按钮子控件 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    
    CGPoint imageCenter;
    
    imageCenter.x = self.width * 0.5;
    imageCenter.y = self.height * 0.4;
    
    self.imageView.center = imageCenter;
    
    // 设置label位置和尺寸
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame);
    
    self.titleLabel.frame = CGRectMake(0, labelY, self.width, self.height - labelY);
}


- (void)setData:(WDMeFooterViewData *)data{
    
    _data = data;
    
    [self setTitle:data.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:data.icon forState:UIControlStateNormal];
}

@end
