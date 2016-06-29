//
//  WDVerticalButton.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDVerticalButton.h"

@implementation WDVerticalButton


- (void)awakeFromNib{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
