//
//  WDEssenceViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDEssenceViewController.h"
#import "WDRecommendTagTableViewController.h"

@interface WDEssenceViewController ()

@property (nonatomic,weak) UIView *redBar;
@property (nonatomic,weak) UIButton *lastChannelBtn;

@end


@implementation WDEssenceViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightedImageName:@"MainTagSubIconClick" target:self action:@selector(tagBtnClick)];
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 添加顶部频道View
    [self setUpChannelView];
}


- (void)setUpChannelView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
    // 添加单个频道按钮
    NSArray *channelArray = @[@"全部", @"视频", @"图片", @"段子", @"声音"];
    
    CGFloat y = 0;
    
    CGFloat width = view.width / channelArray.count;
    
    CGFloat height = view.height;
    
    for (int i = 0; i < channelArray.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:channelArray[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:WDColor(222, 20, 0, 1) forState:UIControlStateDisabled];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        CGFloat x = width * i;
        
        btn.frame = CGRectMake(x, y, width, height);
        
//        btn.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:btn];
        
        [btn addTarget:self action:@selector(channelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 让第一个频道按钮作为初始的lastChannelBtn
        if (self.lastChannelBtn != nil) continue;
        
        self.lastChannelBtn = btn;
    }
    
    // 添加底部红色条
    UIView *redBar = [[UIView alloc] init];
    
    redBar.height = 3;
    redBar.y = view.height - redBar.height;
    
    redBar.backgroundColor = WDColor(222, 20, 0, 1);
    
    [view addSubview:redBar];
    
    self.redBar = redBar;
    
    [self.view addSubview:view];
    
    
    // 强制布局初始的lastChannelBtn(第一个频道按钮)
    [self.lastChannelBtn layoutSubviews];
    
    // 对redBar修改尺寸和位置
    self.redBar.width = self.lastChannelBtn.titleLabel.width + 10;
    self.redBar.x = self.lastChannelBtn.center.x - self.redBar.width * 0.5;
    
    // 让初始lastChannelBtn处于不可用(会调用设置好的不可用状态的文字颜色)
    self.lastChannelBtn.enabled = NO;
}


- (void)channelBtnClick:(UIButton *)btn{

    // 将上次选中的按钮变为可用
    // 将这次选中的按钮变为不可用
    self.lastChannelBtn.enabled = YES;
    btn.enabled = NO;
    self.lastChannelBtn = btn;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.redBar.width = btn.titleLabel.width + 10;
        self.redBar.x = btn.center.x - self.redBar.width * 0.5;
    }];
}


- (void)tagBtnClick{
    
    // 推荐关注控制器跳转
    WDRecommendTagTableViewController *vc = [[WDRecommendTagTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
