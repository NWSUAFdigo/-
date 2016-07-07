//
//  WDPublishViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/7.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDPublishViewController.h"
#import "WDVerticalButton.h"
#import "WDLoginRegisterViewController.h"

@interface WDPublishViewController ()
@property (nonatomic,weak) UIImageView *titleView;
@property (nonatomic,strong) NSMutableArray *publishBtnArray;
@end


@implementation WDPublishViewController

- (NSMutableArray *)publishBtnArray{
    
    if (!_publishBtnArray) {
        
        _publishBtnArray = [NSMutableArray array];
    }
    return _publishBtnArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果需要给控件添加动画,那么就尽量不要在storyboard或者xib中添加控件并设置约束,使用代码的方式来添加控件
    // 添加标题imageView
    [self setUpTitleView];
    
    // 添加发布按钮
    [self setUpPublishBtn];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // 设置形变
    [self setAnimation];
}


- (void)setUpTitleView{
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    
    titleView.center = CGPointMake(WDScreenW * 0.5, 100);
    
    [self.view addSubview:titleView];
    
    self.titleView = titleView;
    
    // 设置形变
    titleView.transform = CGAffineTransformMakeTranslation(0, -120);
    
}


- (void)setUpPublishBtn{
    
    NSArray *publishBtnData = @[
                                @{@"name" : @"发视频", @"image" : @"publish-video"},
                                @{@"name" : @"发图片", @"image" : @"publish-picture"},
                                @{@"name" : @"发段子", @"image" : @"publish-text"},
                                @{@"name" : @"发声音", @"image" : @"publish-audio"},
                                @{@"name" : @"审帖", @"image" : @"publish-review"},
                                @{@"name" : @"离线下载", @"image" : @"publish-offline"}
                                ];
    
    // 设置尺寸
    CGFloat buttonW = 72;
    CGFloat buttonH = 110;
    
    CGFloat buttonStartX = 20;
    CGFloat buttonMarginX = (WDScreenW - 3 * buttonW - 2 * buttonStartX) * 0.5;
    
    CGFloat buttonMarginY = 20;
    CGFloat buttonStartY = (WDScreenH - 2 * buttonH - buttonMarginY) * 0.5;
    
    
    for (NSInteger i = 0; i < publishBtnData.count; i++) {
        
        WDVerticalButton *button = [WDVerticalButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮Frame
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        
        CGFloat buttonX = buttonStartX + col * (buttonW + buttonMarginX);
        CGFloat buttonY = buttonStartY + row * (buttonH + buttonMarginY);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 取出按钮数据
        NSDictionary *data = publishBtnData[i];
        
        [button setTitle:data[@"name"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [button setImage:[UIImage imageNamed:data[@"image"]] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        // 将按钮存入按钮数组
        [self.publishBtnArray addObject:button];
        
        
        // 设置形变
        CGFloat ty = CGRectGetMaxY(button.frame) + arc4random_uniform(40);

        button.transform = CGAffineTransformMakeTranslation(0, -ty);
        
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)setAnimation{
    
    // 设置动画
    
    // 设置按钮动画
    for (NSInteger i = 0; i < self.publishBtnArray.count; i++) {
        
        [UIView animateWithDuration:0.8f delay:i * 0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            WDVerticalButton *btn = self.publishBtnArray[i];
            
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 按钮动画执行完成后执行标题动画
            // 判断是否是倒数第3个按钮的动画
            if (i == self.publishBtnArray.count - 3) {
             
                [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.titleView.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        }];
    }
}


- (void)buttonClick:(WDVerticalButton *)button{
    
    WDLoginRegisterViewController *vc = [[WDLoginRegisterViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)cancleBtn:(id)sender {
    
    for (NSInteger i = self.publishBtnArray.count - 1; i >= 0; i--) {
        
        [UIView animateWithDuration:0.8f delay:(self.publishBtnArray.count - i) * 0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            WDVerticalButton *btn = self.publishBtnArray[i];

            btn.transform = CGAffineTransformMakeTranslation(0, WDScreenH);
        } completion:^(BOOL finished) {
            
            // 判断当前按钮是否是第4个按钮
            if (i == 3) {
                
                [UIView animateWithDuration:0.8f animations:^{
                    
                    self.titleView.transform = CGAffineTransformMakeTranslation(0, WDScreenH);
                } completion:^(BOOL finished) {
                    
                    // 动画完成将控制器销毁
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
            }
            
            
        }];
    }
}

@end
