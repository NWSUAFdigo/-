//
//  WDCommentTableViewCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/11.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDCommentTableViewCell.h"
#import "WDVerticalButton.h"
#import "WDChannelCellCommentData.h"
#import "WDChannelCellUserData.h"
#import "WDVoiceButton.h"

#import <UIImageView+WebCache.h>

@interface WDCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *womenLogo;
@property (weak, nonatomic) IBOutlet UIImageView *manLogo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet WDVerticalButton *dingBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet WDVoiceButton *voiceBtn;


@end


@implementation WDCommentTableViewCell

- (void)setData:(WDChannelCellCommentData *)data{
    
    _data = data;
    
    [self.iconView sd_setImageWithURL:data.user.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    if ([data.user.sex isEqualToString:WDMale]) {
        
        self.manLogo.hidden = NO;
        self.womenLogo.hidden = YES;
    }else {
        
        self.womenLogo.hidden = NO;
        self.manLogo.hidden = YES;
    }
    
    self.nameLabel.text = data.user.username;
    
    [self.dingBtn setTitle:[NSString stringWithFormat:@"%lu", data.like_count] forState:UIControlStateNormal];
    
    self.dingBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    self.contentLabel.text = data.content;
    
    // 测试语音使用
//    data.user.voicetime = 5;
    
    // 判断语音时长是否为0
    if (data.user.voicetime != 0) {
        
        // 内容label隐藏
        self.contentLabel.hidden = YES;
        
        // 语音按钮显示
        self.voiceBtn.hidden = NO;
        
        // 设置按钮长度
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%lu''", data.user.voicetime] forState:UIControlStateNormal];
        
        // 记录语音时长
        self.voiceBtn.voicetime = data.user.voicetime;
    }else {
        
        self.contentLabel.hidden = NO;
        self.voiceBtn.hidden = YES;
    }
}


- (void)setFrame:(CGRect)frame{
    
    frame.origin.x += channelCellMargin;
    frame.size.width -= 2 * channelCellMargin;
    
    [super setFrame:frame];
}


- (IBAction)voiceButtonClick:(id)sender {
    
    // 点击语音按钮后,如果按钮选中,将其取消选中;如果未选中,则选中按钮
    self.voiceBtn.selected = !self.voiceBtn.selected;
}

@end
