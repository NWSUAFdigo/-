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
#import "WDChannelCellVideoView.h"
#import "WDChannelCellCommentData.h"
#import "WDChannelCellUserData.h"
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

@property (weak, nonatomic) IBOutlet UIView *hotCmtView;
@property (weak, nonatomic) IBOutlet UILabel *hotCmtLabel;

@property (nonatomic,weak) WDChannelCellImageView *imageV;
@property (nonatomic,weak) WDChannelCellSoundView *soundV;
@property (nonatomic,weak) WDChannelCellVideoView *videoV;

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


- (WDChannelCellVideoView *)videoV{
    
    if (!_videoV) {
        
        WDChannelCellVideoView *videoView = [WDChannelCellVideoView channelCellVideoView];
        
        [self.contentView addSubview:videoView];
        
        _videoV = videoView;
    }
    return _videoV;
}


- (void)setFrame:(CGRect)frame{
    
//    WDLogFunc;
    
    static CGFloat margin = 10;
    
    frame.origin.x += margin;
    frame.origin.y += margin;
    frame.size.width -= margin * 2;
    
    /*
     注意:
        本例中,在评论控制器内,将WDChannelCell设置为控制器tableView的HeaderView
        一旦对tableView设置了HeaderView,系统会不断调用HeaderView的frame,并不断查看其高度
        如果采用之前的 -= margin来设置高度,那么在评论控制器中,作为HeaderView的WDChannelCell的高度会一直被修改
        这不是我们希望的结果
     
        如果WDChannelCell是HeaderView,那么只能选用第二个方式设置高度
        所以在setFrame:方法中,WDChannelCell的高度必须要固定死
     
        如果WDChannelCell不是某个tableView的HeaderView,那么系统就不会持续调用其frame,即使它是HeaderView的子控件(本例)
        本例中,WDChannelCell是HeaderView的一个subView,所以不会持续调用其frame,理论上对于高度的设置,下面哪一个都是可以的
        不过如果频道cell中有热评view,那么在评论控制器中需要将热评view删除,因此不能将cell的高度固定死
     */
    frame.size.height -= margin;
//    frame.size.height = self.data.cellHeight - margin;
    
    [super setFrame:frame];
}


- (void)setData:(WDChannelCellData *)data{
    
    _data = data;
    
    [self.iconView sd_setImageWithURL:data.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
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
    
    
    // 在添加各种view之前,先将cell中已经有的view给移除
    [self.imageV removeFromSuperview];
    [self.soundV removeFromSuperview];
    [self.videoV removeFromSuperview];
    self.imageV = nil;
    self.soundV = nil;
    self.videoV = nil;
    
    // 判断模型中的type是否为图片数据,如果是图片数据,那么将创建好的xib添加进去
    if (data.type == WDChannelPictureTypeIdentify) {
        
        self.imageV.frame = data.imageFrame;
        
        self.imageV.data = data;
    }
    else if (data.type == WDChannelAudioTypeIdentify) {
        
        self.soundV.frame = data.soundFrame;
        
        self.soundV.data = data;
    }
    else if (data.type == WDChannelVideoTypeIdentify) {
        
        self.videoV.frame = data.videoFrame;
        
        self.videoV.data = data;
    }
    
    // 取出热评模型
    WDChannelCellCommentData *topcmtData = data.top_cmt;
    
    if (topcmtData) {
        
        // 如果热评模型有值,取出热评用户模型
        WDChannelCellUserData *userData = topcmtData.user;
        
        // 给热评内容label赋值
        self.hotCmtLabel.text = [NSString stringWithFormat:@"%@: %@", userData.username, topcmtData.content];
        
        self.hotCmtView.hidden = NO;
    } else {
        
        self.hotCmtView.hidden = YES;
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


/** 控制热评视图是否隐藏 */
- (void)setHotCmtViewHidden:(BOOL)hotCmtViewHidden{
    
    _hotCmtViewHidden = hotCmtViewHidden;
    
    self.hotCmtView.hidden = _hotCmtViewHidden;
}


@end
