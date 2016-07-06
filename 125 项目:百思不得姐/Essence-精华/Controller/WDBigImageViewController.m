//
//  WDBigImageViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/5.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDBigImageViewController.h"
#import "WDChannelCellData.h"
#import "WDProgressView.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface WDBigImageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet WDProgressView *progressView;

@end

@implementation WDBigImageViewController


- (UIImageView *)imageView{
    
    if (!_imageView) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        [self.scrollView addSubview:imageV];

        // 如果频道cell中的图片并没有加载完全,那么当点击查看大图时,继续加载
        self.progressView.loadProgress = self.data.progress;
        
        // 注意:在SDWebImage中,一个URL对应一个任务,因此只要URL一致,那么多个sd_setImage方法执行的是同一个任务,因此可以继续加载图片
        [imageV sd_setImageWithURL:self.data.bigImage placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            // 控制progressView的显示和隐藏
            self.progressView.hidden = NO;
            
            // 控制保存按钮的可用与否
            self.saveBtn.enabled = NO;
            
            self.data.progress = 1.0 * receivedSize / expectedSize;
            
            self.progressView.loadProgress = self.data.progress;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 图片加载完成后,progressView隐藏
            self.progressView.hidden = YES;
            
            // 保存按钮可用
            self.saveBtn.enabled = YES;
        }];
        
        // 给imageV添加一个点按手势
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClick:)]];
        
        _imageView = imageV;
    }
    return _imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置保存按钮和分享按钮圆角
    self.saveBtn.layer.cornerRadius = 5;
    self.shareBtn.layer.cornerRadius = 5;
    
    // 计算图片需要显示的尺寸
    CGFloat pictureW = [UIScreen mainScreen].bounds.size.width;
    // 注意:图片宽度的获得尽量不要使用self.view.bounds.size.width
    // 因为如果是在storyboard或者xib中创建的控制器根视图,那么在viewDidLoad方法中,self.view的尺寸并没有根据手机屏幕尺寸进行伸缩,而是显示storyboard或者xib中的尺寸
    // 本例中,在viewDidLoad方法中,self.view的size为600 * 600
//    WDLog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    
    CGFloat pictureH = self.data.height / self.data.width * pictureW;
    
    // 根据图片将要显示的高度不同来决定self.imageView的位置和尺寸
    if (pictureH > [UIScreen mainScreen].bounds.size.height) {
        
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        
        self.scrollView.contentSize = self.imageView.frame.size;
        
    }else {
        
        self.imageView.bounds = CGRectMake(0, 0, pictureW, pictureH);
        
        self.imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    }
}


- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


/** 点击保存按钮将图片保存到相册 */
- (IBAction)saveBtnClick:(id)sender {
    
    // 将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    // 写入完成后的回调方法中,参数有严格的要求,可以点击写入函数查看.系统已经提供了一个回调方法示例
}


/** 写入相册后的回调方法 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    // 设置HUD的最小淡出时间
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    
    // 根据写入是否成功来显示HUD的内容
    if (error) {
        
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
    else {

        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
    /*
     注意:
        iPhone默认是不支持gif动态图片的,在SDWebImage框架中,gif图片也是被切割为很多张静态图片,然后一张一张显示
        所以当保存gif图片到相册时,iPhone只会保存点击保存按钮那一刻的那张静态图到相册
     */
}

@end
