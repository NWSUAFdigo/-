//
//  WDFriendTrendsViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDFriendTrendsViewController.h"
#import "WDRecommendViewController.h"
#import "WDLoginRegisterViewController.h"

@implementation WDFriendTrendsViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    /*
     注意:
        此时不能使用self.title来设置导航栏标题,因为self.title会同时设置导航栏和tabBar的标题
        而此时导航栏和tabBar的标题是不同的
     */
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"friendsRecommentIcon" highlightedImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecBtnClick)];
    
    self.view.backgroundColor = WDViewBackgroundColor;
}


- (void)friendsRecBtnClick{
    
    WDRecommendViewController *recommendVC = [[WDRecommendViewController alloc] init];
    
    [self.navigationController pushViewController:recommendVC animated:YES];
}


/** 登录/注册 按钮点击 */
- (IBAction)loginOrRegisterClick:(id)sender {
    
    WDLoginRegisterViewController *loginRegisterVC = [[WDLoginRegisterViewController alloc] init];
    
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
}

@end
