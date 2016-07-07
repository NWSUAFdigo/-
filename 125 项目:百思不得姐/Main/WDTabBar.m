//
//  WDTabBar.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTabBar.h"
#import "WDPublishViewController.h"

@interface WDTabBar ()

@property (nonatomic,weak) UIButton *publishBtn;

@end


@implementation WDTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        [self setUpPublishBtn];
        
        // 设置tabBar背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    }
    return self;
}


/** 添加中间的 +号按钮 */
- (void)setUpPublishBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
    
    btn.size = btn.currentImage.size;
    
    [self addSubview:btn];
    
    self.publishBtn = btn;
    
    // 监听 +号按钮
    [btn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
}


/** 重新布局子控件 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 查看子控件
//    NSLog(@"%@",self.subviews);
    
    // 重新布局子控件
    // 首先布局 +号按钮
    
    self.publishBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
    // 布局其他tabBarButton
    // 打印self.subviews可以看到,其他按钮的类为UITabBarButton,这是一个私有类,所以需要通过NSClassFromString来获得类名
    NSInteger count = 0;
    
    CGFloat y = 0;
    CGFloat width = self.width / 5;
    CGFloat height = self.height;
    
    for (UIButton *btn in self.subviews) {
        
        // 如果子控件不是UITabBarButton对象,那么直接进行下一次循环
        if (![btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        // 进入这里说明btn是一个UITabBarButton对象
        
        CGFloat x = width * (count > 1 ? count + 1 : count);
        // 通过一个三目运算符来对count进行设置
        // 由于本例中,tabBar有五个按钮,出去 +号按钮只有4个普通按钮,所以当count > 1时,按钮位于 +号按钮的右边,需要让其向右移动一个width
        
        btn.frame = CGRectMake(x, y, width, height);
        
        count ++;
    }
}


- (void)publishClick{
    
    WDPublishViewController *vc = [[WDPublishViewController alloc] init];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
}


@end
