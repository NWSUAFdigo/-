//
//  WDMeViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDMeViewController.h"

@implementation WDMeViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
//    // 设置右侧按钮 mine-setting-icon mine-moon-icon
//    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [settingBtn setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
//    
//    [settingBtn setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
//    
//    settingBtn.size = settingBtn.currentImage.size;
//    
//    
//    UIButton *moonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [moonBtn setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
//    
//    [moonBtn setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
//    
//    moonBtn.size = moonBtn.currentImage.size;
//    
//    
//    self.navigationItem.rightBarButtonItems = @[
//                                                [[UIBarButtonItem alloc] initWithCustomView:settingBtn],
//                                                [[UIBarButtonItem alloc] initWithCustomView:moonBtn]
//                                                ];
//    
//    // 给按钮添加事件
//    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [moonBtn addTarget:self action:@selector(moonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingItem = [UIBarButtonItem barButtonItemWithImageName:@"mine-setting-icon" highlightedImageName:@"mine-setting-icon-click" target:self action:@selector(settingBtnClick)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem barButtonItemWithImageName:@"mine-moon-icon" highlightedImageName:@"mine-moon-icon-click" target:self action:@selector(moonBtnClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    // 注意:rightBarButtonItems数组中,先添加的Item位于右侧,后添加的Item位于先添加的Item的左侧
}


- (void)settingBtnClick{
    
    WDLogFunc;
}


- (void)moonBtnClick{
    
    WDLogFunc;
}


@end
