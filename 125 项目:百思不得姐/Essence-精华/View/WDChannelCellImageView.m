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
#import "WDProgressView.h"
#import "WDBigImageViewController.h"

@interface WDChannelCellImageView ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isGifView;
@property (weak, nonatomic) IBOutlet UIButton *bigImageButton;

@property (weak, nonatomic) IBOutlet WDProgressView *circleProgressView;

/** 通过一个属性记录图片的url */
@property (nonatomic,strong) NSURL *bigImageURL;

@end


@implementation WDChannelCellImageView

+ (instancetype)channelCellImageView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (instancetype)init{
    
    if (self = [super init]) {
        
        self = [WDChannelCellImageView channelCellImageView];
    }
    return self;
}


-(void)awakeFromNib{
    
    // 取消autoresizingMask布局
    // 如果发现一个控件的frame设置没有问题,而最终显示的效果不是frame所设置的尺寸时,可能是autoresizingMask对控件进行了约束
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 设置图片控件允许交互
    self.contentImageView.userInteractionEnabled = YES;
    
    // 给图片控件添加一个点击手势
    [self.contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageClick:)]];
    
    // 让图片控件的内容位于控件内
    self.contentImageView.clipsToBounds = YES;
}


- (void)setData:(WDChannelCellData *)data{
    
    _data = data;
    
    // 取出模型中的图片下载进度,并设置到circleProgressView上面
    self.circleProgressView.loadProgress = data.progress;

    // 将取出的URL赋值给bigImageURL属性
    self.bigImageURL = data.bigImage;
    
    [self.contentImageView sd_setImageWithURL:data.bigImage placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        // 图片加载过程中的操作
        // 计算当前图片的下载进度,并保存到模型的progress属性中
        data.progress = 1.0 * receivedSize / expectedSize;
        
        
        // 判断当前任务中的图片URL是否是最新的URL(即bigImageURL属性)
        // 例:如果某一个cell的图片正在加载,而此时用户滚动到下面,该cell正好被循环利用,那么两个图片加载任务同时进行
        // 如果没有这个判断,那么两个任务同时对一个进度圈操作,就会造成该进度圈一会显示之前图片的加载进度,一会显示循环利用到的位置的图片加载进度,造成混乱
        if (data.bigImage == self.bigImageURL) {
            
            // 将progress值传递给circleProgressView
            self.circleProgressView.loadProgress = data.progress;
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片加载完成后的操作
        
        // 如果图片是大图,那么在此处将图片压缩\剪切,在添加到contentImageView上面
        if (data.isCliped == YES) {
            
            // 如果是大图,修改图片填充方式
            self.contentImageView.contentMode = UIViewContentModeTop;
            
            // 给UIImage添加一个分类方法:给定一张图片和比例,返回一张按照比例缩放的图片
            // 计算缩放比例
            CGFloat scale = data.imageFrame.size.width / image.size.width;
            
            self.contentImageView.image = [image zoomImageWithScale:scale];
        }else {
            
            // 如果不是大图,恢复图片填充方式
            self.contentImageView.contentMode = UIViewContentModeScaleToFill;
        }
    }];
    
    // 判断是否是gif图片
    self.isGifView.hidden = !data.is_gif;
    // 如果一个图片文件不知道其扩展名,可以通过查看其第一个字节来判断该图片是jpg还是gif还是其他
    
    self.bigImageButton.hidden = !data.isCliped;
}


/** 点击图片时调用该方法 */
- (IBAction)bigImageClick:(id)sender {
    
    WDBigImageViewController *vc = [[WDBigImageViewController alloc] init];
    
    // 将模型数据传递给控制器
    vc.data = self.data;
    
    // 由于本类对象是一个UIView,而不是一个控制器,所以可以从根控制器进行调转
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}


@end
