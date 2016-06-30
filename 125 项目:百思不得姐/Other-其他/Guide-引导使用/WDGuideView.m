//
//  WDGuideView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/30.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDGuideView.h"

@implementation WDGuideView

/*
 父视图透明度说明:
    1 如果父视图的alpha值进行了设置,那么子视图也跟着改变alpha值
    2 如果想让子视图的alpha值不随着父视图改变,那么就不能调整父视图的alpha
    3 而应该在xib或者storyboard中点击父视图的background设置,在弹出的小弹框中修改Opacity
 */

+ (void)show{
    
    /*
     程序第一次安装或者有新版本时才会弹出引导页
        1 取出当前程序的版本号
        2 取出在bundle中存储的上次程序启动的版本号
        3 比较两个版本号,如果不同,则会加载引导页,同时将当前版本存入bundle
        4 程序第一次安装启动后,bundle中没有存储的上次版本号,所以第一次启动会进行版本号存储
     */
    
    // 版本号key
    NSString *key = @"CFBundleShortVersionString";

    // 获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 获取上次程序启动时的版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (![currentVersion isEqualToString:lastVersion]) {
        
        // 创建引导页
        WDGuideView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        view.frame = window.bounds;
        
        // 将引导页添加到主窗口上
        [window addSubview:view];
        
        // 将当前版本几率到bundle中
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    }
    
    
}


- (IBAction)buttonClick:(id)sender {

    [self removeFromSuperview];
}

@end
