//
//  WDFriendTrendsViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDFriendTrendsViewController.h"

@implementation WDFriendTrendsViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    /*
     注意:
        此时不能使用self.title来设置导航栏标题,因为self.title会同时设置导航栏和tabBar的标题
        而此时导航栏和tabBar的标题是不同的
     */
    
    
//    // 设置左边按钮 friendsRecommentIcon
//    UIButton *friendsRecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [friendsRecBtn setImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
//    
//    [friendsRecBtn setImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
//    
//    friendsRecBtn.size = friendsRecBtn.currentImage.size;
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:friendsRecBtn];
//    
//    // 设置按钮点击
//    [friendsRecBtn addTarget:self action:@selector(friendsRecBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"friendsRecommentIcon" highlightedImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecBtnClick)];
    
    self.view.backgroundColor = WDViewBackgroundColor;
}


- (void)friendsRecBtnClick{
    
    WDLogFunc;
}


@end
