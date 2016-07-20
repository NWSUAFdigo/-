//
//  WDTagButton.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTagButton.h"

@implementation WDTagButton

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleLabel.x = channelCellMargin - 2;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 4;
}


- (void)sizeToFit{
    
    [super sizeToFit];
    
    self.width += 2 * channelCellMargin;
    self.height += channelCellMargin;
}


@end
