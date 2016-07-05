//
//  WDChannelCellImageView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/5.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCellImageView.h"
#import "WDChannelCellData.h"
#import <UIImageView+WebCache.h>

@interface WDChannelCellImageView ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isGifView;
@property (weak, nonatomic) IBOutlet UIButton *bigImageButton;


@end


@implementation WDChannelCellImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [super initWithCoder:aDecoder];
}


+ (instancetype)channelCellImageView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (instancetype)init{
    
    if (self = [super init]) {
        
        self = [WDChannelCellImageView channelCellImageView];
    }
    return self;
}


- (void)setData:(WDChannelCellData *)data{
    
    // 取消autoresizingMask布局
    // 如果发现一个控件的frame设置没有问题,而最终显示的效果不是frame所设置的尺寸时,可能是autoresizingMask对控件进行了约束
    self.autoresizingMask = UIViewAutoresizingNone;
    
    _data = data;
    
    [self.contentImageView sd_setImageWithURL:data.bigImage];
    
    // 判断是否是gif图片
    self.isGifView.hidden = !data.is_gif;
    // 如果一个图片文件不知道其扩展名,可以通过查看其第一个字节来判断该图片是jpg还是gif还是其他
    
    self.bigImageButton.hidden = !data.isCliped;
}





@end
