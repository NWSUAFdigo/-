//
//  WDPublishViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/7.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDPublishViewController.h"
#import "WDVerticalButton.h"
#import "WDLoginRegisterViewController.h"

#import <POP.h>
/*
 POP框架简介:
 1 该框架是Facebook开发的一款处理动画的框架
 2 POP框架中的动画可以适用于任何对象(NSObject),因为该框架实现动画的原理就是修改属性中的某些值
 3 比如可以让一个属性值按照衰减的方式增长
 4 POP框架的使用与CAAnimation类似
 5 POP框架的经典示例程序:popping(Github上搜索popping) learnCube(Github上搜索)
 6 可以结合示例程序自行学习pop框架
 */

@interface WDPublishViewController ()
@property (nonatomic,weak) UIImageView *titleView;
@property (nonatomic,strong) NSMutableArray *publishBtnArray;
@end


@implementation WDPublishViewController

- (NSMutableArray *)publishBtnArray{
    
    if (!_publishBtnArray) {
        
        _publishBtnArray = [NSMutableArray array];
    }
    return _publishBtnArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果需要给控件添加动画,那么就尽量不要在storyboard或者xib中添加控件并设置约束,使用代码的方式来添加控件
    // 添加标题imageView
    [self setUpTitleView];
    
    // 添加发布按钮
    [self setUpPublishBtn];
    
    // 视图加载完毕后,让控制器的根视图不允许交互,此时,根视图上面的按钮是不可点击的.在动画执行完毕后将根视图的交互打开
    self.view.userInteractionEnabled = NO;
}


- (void)setUpTitleView{
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    
    // 如果使用POP来给控件添加动画,最好不要在控件创立时给其设置位置和尺寸
    // 因为通过POP来修改控件的尺寸和位置会最终真实修改控件的尺寸和位置,而通过coreAnimation不会最终修改控件的位置和尺寸
//    titleView.center = CGPointMake(WDScreenW * 0.5, 100);
    
    [self.view addSubview:titleView];
    
    self.titleView = titleView;
    
    self.titleView.hidden = YES;
}


- (void)setUpPublishBtn{
    
    NSArray *publishBtnData = @[
                                @{@"name" : @"发视频", @"image" : @"publish-video"},
                                @{@"name" : @"发图片", @"image" : @"publish-picture"},
                                @{@"name" : @"发段子", @"image" : @"publish-text"},
                                @{@"name" : @"发声音", @"image" : @"publish-audio"},
                                @{@"name" : @"审帖", @"image" : @"publish-review"},
                                @{@"name" : @"离线下载", @"image" : @"publish-offline"}
                                ];
    
    // 设置尺寸
    CGFloat buttonW = 72;
    CGFloat buttonH = 110;
    
    CGFloat buttonStartX = 20;
    CGFloat buttonMarginX = (WDScreenW - 3 * buttonW - 2 * buttonStartX) * 0.5;
    
    CGFloat buttonMarginY = 20;
    CGFloat buttonStartY = (WDScreenH - 2 * buttonH - buttonMarginY) * 0.5;
    
    
    for (NSInteger i = 0; i < publishBtnData.count; i++) {
        
        WDVerticalButton *button = [WDVerticalButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮Frame
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        
        CGFloat buttonX = buttonStartX + col * (buttonW + buttonMarginX);
        CGFloat buttonY = buttonStartY + row * (buttonH + buttonMarginY);
        
        
        // 如果使用POP来给控件添加动画,最好不要在控件创立时给其设置位置和尺寸
        // 因为通过POP来修改控件的尺寸和位置会最终真实修改控件的尺寸和位置,而通过coreAnimation不会最终修改控件的位置和尺寸
//        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 使用POP给按钮添加动画
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        // 注意:POP设置动画时,会真实修改控件的位置和尺寸
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, -buttonH, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        
        // 设置按钮每隔一段时间开始动画
        animation.beginTime = CACurrentMediaTime() + i * 0.1;
        
        // 设置弹簧系数
        animation.springSpeed = 8;
        animation.springBounciness = 14;
        
        // 判断是否是倒数第4个按钮
        if (i == publishBtnData.count - 4) {
            
            // 如果是倒数第4个按钮,那么在动画结束后让标题视图执行动画
            [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                
                self.titleView.hidden = NO;
                
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
                
                anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(WDScreenW * 0.5, -self.titleView.height)];
                anim.toValue = [NSValue valueWithCGPoint:CGPointMake(WDScreenW * 0.5, 100)];
                
                anim.springSpeed = 8;
                anim.springBounciness = 14;
                
                // 标题视图动画执行完成后将根视图的交互打开
                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    
                    self.view.userInteractionEnabled = YES;
                }];
                
                [self.titleView pop_addAnimation:anim forKey:nil];
            }];
        }
        
        [button pop_addAnimation:animation forKey:nil];
        
        
        // 取出按钮数据
        NSDictionary *data = publishBtnData[i];
        
        [button setTitle:data[@"name"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [button setImage:[UIImage imageNamed:data[@"image"]] forState:UIControlStateNormal];
        
        [self.view addSubview:button];
        
        // 将按钮存入按钮数组
        [self.publishBtnArray addObject:button];
        
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


/** 执行退出动画,动画执行完毕后执行block中的内容 */
- (void)dismissAnimationWithCompletionBlock:(void (^)())completionBlock{
    
    // 一旦开始执行退出动画,那么根视图的交互关闭
    self.view.userInteractionEnabled = NO;
    
    // 执行完一段动画后将控制器退出
    for (NSInteger i = 0; i < self.publishBtnArray.count; i++) {
        
        // 从后往前取出按钮数组中的按钮
        WDVerticalButton *btn = self.publishBtnArray[self.publishBtnArray.count - 1 - i];
        
        // 执行动画
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(btn.center.x, WDScreenH + btn.height)];
        
        animation.beginTime = CACurrentMediaTime() + i * 0.1;
        
        // 如果是倒数第4个按钮,那么让标题视图开始执行动画
        if (i == self.publishBtnArray.count - 4) {
            
            [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
                
                anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.titleView.center.x, self.titleView.center.y)];
                anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.titleView.center.x, WDScreenH + self.titleView.height)];
                
                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    
                    // 动画执行完毕,判断block有无值,有则调用
                    if (completionBlock) {
                        completionBlock();
                    }
                }];
                
                [self.titleView pop_addAnimation:anim forKey:nil];
            }];
        }
        
        [btn pop_addAnimation:animation forKey:nil];
    }

}


- (IBAction)cancelBtn:(UIButton *)btn{
    
    [self dismissAnimationWithCompletionBlock:^{
        
        // 退出控制器
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


/** 让控制器监听触摸事件 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 点击屏幕空白,触摸事件会传递到栈顶的子控件,而这些子控件都没有实现touchesBeagn方法,所以事件最终会传递到控制器,而被控制器拦截到
    [self cancelBtn:nil];
}


- (void)buttonClick:(WDVerticalButton *)button{
    
    [self dismissAnimationWithCompletionBlock:^{

//        [self dismissViewControllerAnimated:NO completion:^{
        
            WDLoginRegisterViewController *vc = [[WDLoginRegisterViewController alloc] init];
            
            [self presentViewController:vc animated:YES completion:nil];
//        }];
    }];
}



@end
