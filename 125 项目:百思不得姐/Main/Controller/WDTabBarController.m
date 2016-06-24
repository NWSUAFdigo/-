//
//  WDTabBarController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTabBarController.h"
#import "WDTabBar.h"
#import "WDNavigationController.h"

#import "WDEssenceViewController.h"
#import "WDNewViewController.h"
#import "WDFriendTrendsViewController.h"
#import "WDMeViewController.h"

@implementation WDTabBarController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 修改WDTabBarController的tabBar为自定义的WDTabBar
    // 由于tabBar属性为只读属性,所以可以采用KVC的方式进行赋值
    // 也可以参考 110 项目:网易彩票的做法,在tabBar上面添加一个view,让这个view实现tabBar的功能
    WDTabBar *tabBar = [[WDTabBar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    
    // 创建子控制器
    [self setUpChildViewController:[[WDEssenceViewController alloc] init] tabBarItemTitle:@"精华" tabBarItemImageName:@"tabBar_essence_icon" tabBarItemSelectedImageName:@"tabBar_essence_click_icon"];
    
    [self setUpChildViewController:[[WDNewViewController alloc] init] tabBarItemTitle:@"新帖" tabBarItemImageName:@"tabBar_new_icon" tabBarItemSelectedImageName:@"tabBar_new_click_icon"];
    
    [self setUpChildViewController:[[WDFriendTrendsViewController alloc] init] tabBarItemTitle:@"关注" tabBarItemImageName:@"tabBar_friendTrends_icon" tabBarItemSelectedImageName:@"tabBar_friendTrends_click_icon"];
    
    [self setUpChildViewController:[[WDMeViewController alloc] init] tabBarItemTitle:@"我" tabBarItemImageName:@"tabBar_me_icon" tabBarItemSelectedImageName:@"tabBar_me_click_icon"];
    
    // 如果在系统某个方法的后面含有如下宏:UI_APPEARANCE_SELECTOR,表示可以通过appearance来对这个方法进行统一设置
    // 本例中,可以通过appearance来对tabBarItem的setTitleTextAttributes: forState:方法进行统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
}


/** 创建子控制器并添加到tabBar中 */
- (void)setUpChildViewController:(UIViewController *)vc tabBarItemTitle:(NSString *)title tabBarItemImageName:(NSString *)imageName tabBarItemSelectedImageName:(NSString *)selectedImageName{
    
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.image = [UIImage originalImageWithName:imageName];
    
    vc.tabBarItem.selectedImage = [UIImage originalImageWithName:selectedImageName];
    
//    vc.view.backgroundColor = WDColor(223, 223, 223, 1);
    // 注意:不能在此处设置控制器根视图的背景颜色,因为一旦在此设置,那么根视图就会通过懒加载创建.那些没有被点击的控制器根视图也同时被创建,不符合点击时创建的原则
    
//    [self addChildViewController:vc];
    
    // 将导航栏作为tabBarController的子控制器
    WDNavigationController *navi = [[WDNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navi];
    
    // 设置导航栏背景图片
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

@end
