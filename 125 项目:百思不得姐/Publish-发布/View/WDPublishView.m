//
//  WDPublishView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/7.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDPublishView.h"
#import "WDVerticalButton.h"
#import "WDLoginRegisterViewController.h"
#import "WDWriteWordController.h"
#import "WDNavigationController.h"
#import <POP.h>


@interface WDPublishView ()

@property (nonatomic,weak) UIImageView *titleView;
@property (nonatomic,strong) NSMutableArray *publishBtnArray;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end


@implementation WDPublishView

- (NSMutableArray *)publishBtnArray{
    
    if (!_publishBtnArray) {
        
        _publishBtnArray = [NSMutableArray array];
    }
    return _publishBtnArray;
}


+ (instancetype)publishView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


- (instancetype)init{
    
    if (self = [super init]) {
        
        self = [WDPublishView publishView];
    }
    return self;
}


-(void)awakeFromNib{
    
    // 如果需要给控件添加动画,那么就尽量不要在storyboard或者xib中添加控件并设置约束,使用代码的方式来添加控件
    // 添加标题imageView
    [self setUpTitleView];
    
    // 添加发布按钮
    [self setUpPublishBtn];
    
    // 给contentView添加一个点按手势
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
    
    // 视图加载完毕后,让控制器的根视图不允许交互,此时,根视图上面的按钮是不可点击的.在动画执行完毕后将根视图的交互打开
    self.contentView.userInteractionEnabled = NO;
}


- (void)setUpTitleView{
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    
    // 如果使用POP来给控件添加动画,最好不要在控件创立时给其设置位置和尺寸
    // 当然也可以像本例中给控件一个初始位置
    // 因为通过POP来修改控件的尺寸和位置会最终真实修改控件的尺寸和位置,而通过coreAnimation不会最终修改控件的位置和尺寸
    
    // 本例中,如果没有给titleView一个位置,那么默认它的位置为(0,0),在执行动画的时候会先从这个位置闪到动画开始点
    // 所以在titleView创建的时候给它一个位置,本例中设置其位置为动画开始点的位置
    titleView.center = CGPointMake(WDScreenW * 0.5, -titleView.height);
    
    [self.contentView addSubview:titleView];
    
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
        animation.springSpeed = 18;
        animation.springBounciness = 6;
        
        // 判断是否是倒数第4个按钮
        if (i == publishBtnData.count - 4) {
            
            // 如果是倒数第4个按钮,那么在动画结束后让标题视图执行动画
            [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                
                self.titleView.hidden = NO;
                
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
                
                anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(WDScreenW * 0.5, -self.titleView.height)];
                anim.toValue = [NSValue valueWithCGPoint:CGPointMake(WDScreenW * 0.5, 100)];
                
                anim.springSpeed = 18;
                anim.springBounciness = 6;
                
                // 标题视图动画执行完成后将contentView视图的交互打开
                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    
                    self.contentView.userInteractionEnabled = YES;
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
        
        [self.contentView addSubview:button];
        
        // 将按钮存入按钮数组
        [self.publishBtnArray addObject:button];
        
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


/** 执行退出动画,动画执行完毕后执行block中的内容 */
- (void)dismissAnimationWithCompletionBlock:(void (^)())completionBlock{
    
    // 一旦开始执行退出动画,那么contentView视图的交互关闭
    self.contentView.userInteractionEnabled = NO;
    
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
        [self removeFromSuperview];
    }];
}


/** contentView的点击事件 */
- (void)contentViewTap{
    
    // 点击屏幕空白,触摸事件会传递到栈顶的子控件,而这些子控件都没有实现touchesBeagn方法,所以事件最终会传递到控制器,而被控制器拦截到
    [self cancelBtn:nil];
}


- (void)buttonClick:(WDVerticalButton *)button{
    
    [self dismissAnimationWithCompletionBlock:^{
        
        [self removeFromSuperview];
        
        if (button == self.publishBtnArray[2]) {
            
            UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            WDWriteWordController *writeWordVC = [[WDWriteWordController alloc] init];
            
            WDNavigationController *naviC = [[WDNavigationController alloc] initWithRootViewController:writeWordVC];
            
            [rootVC presentViewController:naviC animated:YES completion:nil];
        } else {
        
            WDLoginRegisterViewController *vc = [[WDLoginRegisterViewController alloc] init];

            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    }];
}


@end
