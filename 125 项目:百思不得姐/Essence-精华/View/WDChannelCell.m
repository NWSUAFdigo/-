//
//  WDChannelCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCell.h"
#import "WDChannelCellData.h"
#import "WDChannelCellImageView.h"
#import "WDChannelCellSoundView.h"
#import <UIImageView+WebCache.h>

@interface WDChannelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

@property (nonatomic,weak) WDChannelCellImageView *imageV;
@property (nonatomic,weak) WDChannelCellSoundView *soundV;

@end


@implementation WDChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 添加一个背景
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}


- (WDChannelCellImageView *)imageV{
    
    if (!_imageV) {
        
        WDChannelCellImageView *imageView = [WDChannelCellImageView channelCellImageView];
        
        [self.contentView addSubview:imageView];
        
        _imageV = imageView;
    }
    return _imageV;
}


- (WDChannelCellSoundView *)soundV{
    
    if (!_soundV) {
        
        WDChannelCellSoundView *soundView = [WDChannelCellSoundView channelCellSoundView];
        
        [self.contentView addSubview:soundView];
        
        _soundV = soundView;
    }
    return _soundV;
}


- (void)setFrame:(CGRect)frame{
    
    static CGFloat margin = 10;
    
    frame.origin.x += margin;
    frame.origin.y += margin;
    frame.size.width -= margin * 2;
    frame.size.height -= margin;
    
    [super setFrame:frame];
}


- (void)setData:(WDChannelCellData *)data{
    
    _data = data;
    
    [self.iconView sd_setImageWithURL:data.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.nameLabel.text = data.name;
    
    // 在create_time的getter方法中对时间进行处理
    self.timeLabel.text = data.create_time;
    
    self.contentTextLabel.text = data.text;
    
    // 设置下方小按钮的文字
    // 1 如果按钮的数字超过10000,以 1万 表示
    // 2 如果按钮的数字为0 ,则显示当前按钮的功能,如"顶"\"踩"\"转发"
    [self setButton:self.dingBtn countString:data.ding holder:@"顶"];
    [self setButton:self.caiBtn countString:data.cai holder:@"踩"];
    [self setButton:self.repostBtn countString:data.repost holder:@"转发"];
    [self setButton:self.commentBtn countString:data.comment holder:@"评论"];
    
    
    // 判断模型中的type是否为图片数据,如果是图片数据,那么将创建好的xib添加进去
    if (data.type == WDChannelPictureTypeIdentify) {
        
        self.imageV.frame = data.imageFrame;
        
        self.imageV.data = data;
    }
    else if (data.type == WDChannelAudioTypeIdentify) {
        
        self.soundV.frame = data.soundFrame;
        
        self.soundV.data = data;
    }
    
    else {
        
        [self.imageV removeFromSuperview];
        
        [self.soundV removeFromSuperview];
    }
    
}


- (void)setButton:(UIButton *)btn countString:(NSString *)countStr holder:(NSString *)holder{
    
    NSInteger count = countStr.integerValue;
    
    if (count == 0) {
        
        [btn setTitle:holder forState:UIControlStateNormal];
    }else if (count > 10000){
        
        NSString *title = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        
        [btn setTitle:title forState:UIControlStateNormal];
    }else {
        
        [btn setTitle:countStr forState:UIControlStateNormal];
    }
}


@end
