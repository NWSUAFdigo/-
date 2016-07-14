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
    
    [self.iconView sd_setImageWithURL:data.user.profile_image placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            
            self.iconView.image = [image circleImage];
        }
    }];
    
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


- (BOOL)becomeFirstResponder{
    
    // 调用父类的该方法
    // 一旦调用,将会调用下面两个can...方法
    BOOL flag = [super becomeFirstResponder];
    
    // 获得UIMenuController,并添加UIMenuItem
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController.isMenuVisible) {
        
        [menuController setMenuVisible:NO animated:YES];
    }else {
        
        // ** 注意:不管在任何地方,在给UIMenuControl添加Item之前,最好将menuItems数组清空
        menuController.menuItems = nil;
    
        UIMenuItem *dingItem = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replyItem = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)];
        UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        
        menuController.menuItems = @[dingItem, replyItem, reportItem];
        
        // 设置UIMenuController的位置和尺寸为cell的下半部分
        
        CGRect rect = CGRectMake(0, self.height * 0.5, self.width, self.height * 0.5);
        
        [menuController setTargetRect:rect inView:self];
        
        [menuController setMenuVisible:YES animated:YES];
    }
    
    return flag;
}


- (BOOL)canBecomeFirstResponder{
    
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(ding:) || action == @selector(reply:) || action == @selector(report:))
        
        return YES;
        
    return NO;
}


/** 顶 回调 */
- (void)ding:(id)sender{
    
    WDLogFunc;
}


/** 回复 回调 */
- (void)reply:(id)sender{
    
    WDLogFunc;
}


/** 举报 回到 */
- (void)report:(id)sender{
    
    WDLogFunc;
}

@end
