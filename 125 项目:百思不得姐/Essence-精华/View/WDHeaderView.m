//
//  WDHeaderView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/11.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDHeaderView.h"

@implementation WDHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = WDViewBackgroundColor;
        
        [self setUpLabel];
    }
    return self;
}


- (void)setUpLabel{
    
    _label = [[UILabel alloc] init];
    
    [self.contentView addSubview:_label];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置UIlabel的frame
    _label.frame = CGRectMake(channelCellMargin, 0, self.contentView.width - channelCellMargin, self.contentView.height);
}

@end
