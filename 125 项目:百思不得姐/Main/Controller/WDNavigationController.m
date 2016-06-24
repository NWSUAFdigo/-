//
//  WDNavigationController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDNavigationController.h"

@implementation WDNavigationController

+ (void)initialize{

    // 不需要在本方法中调用父类的该方法
    
    // 获得该类的所有UINavigationBar,并对其进行设置
    UINavigationBar *naviBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    // 设置导航栏背景图片
    [naviBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 设置非栈底控制器的导航栏左侧为返回
    if (self.childViewControllers.count > 0) {
        
        // 创建一个返回按钮
        UIButton *leftBtn = [self setUpLeftBarButton];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        // 注意:此时不能使用backBarButtonItem来作为导航栏左侧内容,因为backBarButtonItem不能使用initWithCustomView:方法来设置左侧内容.那么就不能对左侧按钮进行自定义,限制比较多
    }
    
    [super pushViewController:viewController animated:animated];
    // 注意:父类的方法调用要放到最后.目的是保证 push的viewController的viewDidLoad方法能够在左侧按钮统一设置(本方法上面的代码)后调用
    // 这样做的好处是:如果需要对某一个控制器的左侧按钮进行自定义,那么只需要在viewDidLoad方法中自定义即可.因为自定义左侧按钮(viewDidLoad方法)在统一设置左侧按钮(本方法)后执行
}


/** 创建一个返回按钮并设置 */
- (UIButton *)setUpLeftBarButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置按钮的内容
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    
    // 设置文字颜色和大小
    [btn setTitleColor:WDColor(1, 1, 1, 1) forState:UIControlStateNormal];
    [btn setTitleColor:WDColor(240, 34, 38, 1) forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // 设置按钮尺寸
    [btn sizeToFit];

    // 设置按钮内容靠左对齐,此处不能使用contentMode来设置内容对齐,因为contentMode一般用来设置imageView的内容对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 设置按钮的内容边缘,本例为内容向左移动5个点
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    // 设置按钮的点击事件,点击返回上一个控制器
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


/** 左侧按钮的点击事件 */
- (void)leftBtnClick{
    
    [self popViewControllerAnimated:YES];
}

@end
