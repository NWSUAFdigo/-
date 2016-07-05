//
//  WDProgressView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/5.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDProgressView.h"

@implementation WDProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpView];
    }
    return self;
}


- (void)awakeFromNib{
    
    [self setUpView];
}


/** 设置视图 */
- (void)setUpView{
    
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}


- (void)setLoadProgress:(CGFloat)loadProgress{
    
    _loadProgress = loadProgress;
    
    // 设置进度圈
    [self setProgress:loadProgress animated:NO];
    // 此处不设置animated
    // 因为在cell的循环利用过程中,如果某一个cell的图片并未加载完成,并且该cell循环利用到其他位置时,此时由于进度圈中有值,所以会有一个回滚的效果,取消动画就是为了取消该回滚效果
    
    // 给进度圈添加文字
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", loadProgress * 100];
}

@end
