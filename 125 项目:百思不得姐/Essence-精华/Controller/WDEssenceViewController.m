//
//  WDEssenceViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDEssenceViewController.h"
#import "WDRecommendTagTableViewController.h"

@implementation WDEssenceViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
//    // 设置左边按钮 MainTagSubIcon
//    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [tagBtn setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
//    
//    [tagBtn setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
//    
//    tagBtn.size = tagBtn.currentImage.size;
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagBtn];
//    
//    // 设置左边按钮点击
//    [tagBtn addTarget:self action:@selector(tagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightedImageName:@"MainTagSubIconClick" target:self action:@selector(tagBtnClick)];
    
    self.view.backgroundColor = WDViewBackgroundColor;
}


- (void)tagBtnClick{
    
    // 测试:控制器的跳转
    WDRecommendTagTableViewController *vc = [[WDRecommendTagTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
