//
//  WDMeTableViewCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDMeTableViewCell.h"

@implementation WDMeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}


// 使用循环利用注册的cell会通过这个方法来创建,而不是上面两个方法
// 所以上面两个方法不会调用
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}


- (void)setup{ 
    
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    // cell右侧添加小箭头
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.height = self.height * 0.7;
    self.imageView.width = self.imageView.height;
    
    CGPoint center = self.imageView.center;
    center.y = self.height * 0.5;
    
    self.imageView.center = center;
}

@end
