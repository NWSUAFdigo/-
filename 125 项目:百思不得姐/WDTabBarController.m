//
//  WDTabBarController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTabBarController.h"
#import "UIImage+Category.h"

@implementation WDTabBarController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 创建子控制器
    [self creatChildViewControllerWithBackgroundColor:[UIColor grayColor] tabBarItemTitle:@"精华" tabBarItemImageName:@"tabBar_essence_icon" tabBarItemSelectedImageName:@"tabBar_essence_click_icon"];
    
    [self creatChildViewControllerWithBackgroundColor:[UIColor greenColor] tabBarItemTitle:@"新帖" tabBarItemImageName:@"tabBar_new_icon" tabBarItemSelectedImageName:@"tabBar_new_click_icon"];
    
    [self creatChildViewControllerWithBackgroundColor:[UIColor blueColor] tabBarItemTitle:@"关注" tabBarItemImageName:@"tabBar_friendTrends_icon" tabBarItemSelectedImageName:@"tabBar_friendTrends_click_icon"];
    
    [self creatChildViewControllerWithBackgroundColor:[UIColor orangeColor] tabBarItemTitle:@"我" tabBarItemImageName:@"tabBar_me_icon" tabBarItemSelectedImageName:@"tabBar_me_click_icon"];
    
    // 如果在系统某个方法的后面含有如下宏:UI_APPEARANCE_SELECTOR,表示可以通过appearance来对这个方法进行统一设置
    // 本例中,可以通过appearance来对tabBarItem的setTitleTextAttributes: forState:方法进行统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    attr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
}


/** 创建子控制器并添加到tabBar中 */
- (void)creatChildViewControllerWithBackgroundColor:(UIColor *)backgroundColor tabBarItemTitle:(NSString *)title tabBarItemImageName:(NSString *)imageName tabBarItemSelectedImageName:(NSString *)selectedImageName{
    
    UIViewController *vc = [[UIViewController alloc] init];
    
    vc.view.backgroundColor = backgroundColor;
    
    vc.tabBarItem.title = title;
    
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    
//    attr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//    
//    [vc.tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
    
    vc.tabBarItem.image = [UIImage originalImageWithName:imageName];
    
    vc.tabBarItem.selectedImage = [UIImage originalImageWithName:selectedImageName];
    
    [self addChildViewController:vc];
}

@end
