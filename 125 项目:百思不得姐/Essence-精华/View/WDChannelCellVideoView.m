//
//  WDChannelCellVideoView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/9.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCellVideoView.h"
#import "WDChannelCellData.h"
#import <UIImageView+WebCache.h>

@interface WDChannelCellVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;


@end


@implementation WDChannelCellVideoView

-(void)awakeFromNib{
    
    self.autoresizingMask = UIViewAutoresizingNone;
}


+ (instancetype)channelCellVideoView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (void)setData:(WDChannelCellData *)data{
    
    _data = data;
    
    self.playCountLabel.text = [NSString stringWithFormat:@"%lu次播放", data.playcount];
    
    // 对时间进行处理
    NSInteger min = data.videotime / 60;
    NSInteger sec = data.videotime % 60;
    
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu", min, sec];// 02表示显示2位,空白部分用0代替
    
    [self.imageView sd_setImageWithURL:data.bigImage];
}


- (IBAction)playClick:(id)sender {
    
    WDLogFunc;
}

@end
