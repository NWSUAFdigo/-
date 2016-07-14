//
//  WDTopStatusBarWindow.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/12.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTopStatusBarWindow.h"

@implementation WDTopStatusBarWindow

// 由于是类方法,所以无法使用成员变量和属性,将window声明为一个全局变量
static UIWindow *statusBarWindow_;
+ (void)showWithTapGesture{
    
    // 如果statusBarWindow_为空,那么创建一个UIWindow对象
    if (!statusBarWindow_) {
        
        statusBarWindow_ = [[UIWindow alloc] init];
        
        statusBarWindow_.frame = CGRectMake(0, 0, WDScreenW, 20);
        
        statusBarWindow_.windowLevel = UIWindowLevelAlert;
        
        statusBarWindow_.backgroundColor = [UIColor clearColor];
        
        statusBarWindow_.hidden = NO;
        
        // 添加点按手势
        // 由于在类方法中,self代表类名,所以tap方法必须是一个类方法
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        [statusBarWindow_ addGestureRecognizer:tapGesture];
        
        
        /*
         注意:
            在Xcode7,及iOS9中,程序启动阶段添加的UIWindow对象是必须要给定一个rootViewController的
            本例中,我们只是在状态栏的位置添加一个UIWindow,所以不需要指定rootViewController
            因此,statusBarWindow_的添加不能再程序启动阶段
            也就是说,在AppDelegate.m文件中,是无法添加statusBarWindow_的
         
            因此我们将statusBarWindow_的添加代码放在了keyWindow的rootViewController,也就是WDTabBarController的viewDidAppear:方法中
         */
    }
}


+ (void)tap{
    
    // 点击顶部,内容回滚的思路如下:
    
    // 通过递归调用找到所有keyWindow上的子控件,及子控件的子控件
    // 判断这些子控件哪些是UIScrollView
    // 判断所有UIScrollView中哪些显示在屏幕上
    
    // 开启递归调用
    [self searchScrollViewInSuperview:[UIApplication sharedApplication].keyWindow];
}


/** 递归调用:找到给定父控件下的所有子控件中的scrollView控件 */
+ (void)searchScrollViewInSuperview:(UIView *)superview{
    
    // 遍历所有子控件
    for (UIView *subview in superview.subviews) {
        
        // 判断subview是否是scrollView
        if ([subview isKindOfClass:[UIScrollView class]]) {
            
            // 判断subview是否在屏幕上
            if ([subview isShowOnKeyWindow]) {
                
                UIScrollView *scrollView = (UIScrollView *)subview;
                
                // 将scrollView回滚到contentInset设置的地方
                // 只在垂直方向上回滚,水平方向不变
                CGPoint contentOffset = scrollView.contentOffset;
                
                contentOffset.y = -scrollView.contentInset.top;
            
                [scrollView setContentOffset:contentOffset animated:YES];
            }
        }
        
        // 判断结束,判断subview中的子控件
        [self searchScrollViewInSuperview:subview];
    }
}


@end
