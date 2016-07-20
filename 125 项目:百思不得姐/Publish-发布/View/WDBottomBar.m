//
//  WDBottomBar.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDBottomBar.h"
#import "WDAddTagViewController.h"
#import "WDTagButton.h"

@interface WDBottomBar ()

@property (weak, nonatomic) IBOutlet UIView *topView;
/** 标签按钮数组,包含 +号按钮 */
@property (nonatomic,strong) NSMutableArray *tagsArray;
/** 标签文本数组,在WDBottomBar和WDAddTagViewController中使用的都是这个对象 */
@property (nonatomic,strong) NSMutableArray *tagsStrArray;

@end


@implementation WDBottomBar

- (NSMutableArray *)tagsArray{
    
    if (!_tagsArray) {
        
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}


- (NSMutableArray *)tagsStrArray{
    
    if (!_tagsStrArray){
        
        _tagsStrArray = [NSMutableArray array];
    }
    return _tagsStrArray;
}


+ (instancetype)bottomBar{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (instancetype)init{
    
    if (self = [super init]) {
        
        self = [WDBottomBar bottomBar];
    }
    return self;
}


- (void)awakeFromNib{
    
    [self.tagsStrArray addObject:@"吐槽"];
    [self.tagsStrArray addObject:@"糗事"];
    
    // 添加标签按钮
    [self setupTagButtonWithStrArray:self.tagsStrArray];
}


/** 根据给定的字符串来设置标签按钮 */
- (void)setupTagButtonWithStrArray:(NSArray<NSString *> *)strArray{
    
    // 将标签按钮数组中的按钮从父控件移除
    for (UIButton *btn in self.tagsArray) {
        
        [btn removeFromSuperview];
    }
    
    // 将上次的标签按钮数组清空
    [self.tagsArray removeAllObjects];
    
    // 编辑标签文字数组
    for (NSString *tagStr in strArray) {
        
        WDTagButton *btn = [self tagButtonWithTitle:tagStr];
        
        [btn sizeToFit];
        
        // 设置按钮的高度
        btn.height = 25;
        
        [self.topView addSubview:btn];
        
        [self.tagsArray addObject:btn];
    }
    
    // 创建 + 号按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    
    [addBtn sizeToFit];
    
    [self.topView addSubview:addBtn];
    
    // 将 +号按钮也添加到标签数组中
    [self.tagsArray addObject:addBtn];
    
    [addBtn addTarget:self action:@selector(addTagClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置标签和 +号按钮的frame进行统一设置
    [self setNeedsLayout];
}


/*
 说明:
    1 对于自定义控件的布局(不管是xib创建还是代码创建),尽量放到layoutSubviews方法中
    2 对于控制器根视图的布局(不管是xib创建还是代码创建),尽量放到viewDidLayoutSubviews方法中
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.tagsArray.count; i++) {
        
        UIButton *tagBtn = self.tagsArray[i];
        
        if (i == 0) {
            
            tagBtn.x = channelCellMargin;
            tagBtn.y = 0;
        }else {
            
            // 取出上一个tag按钮
            UIButton *lastTagBtn = self.tagsArray[i - 1];
            
            // 判断上一个tag按钮所在行的剩余宽度是否能够显示这个tag按钮
            CGFloat remainingW = self.topView.width - CGRectGetMaxX(lastTagBtn.frame) - channelCellMargin - channelCellMargin;
            
            if (remainingW >= tagBtn.width) {
                
                tagBtn.x = CGRectGetMaxX(lastTagBtn.frame) + channelCellMargin;
                tagBtn.y = lastTagBtn.y;
            } else {
                
                tagBtn.x = channelCellMargin;
                tagBtn.y = CGRectGetMaxY(lastTagBtn.frame) + channelCellMargin;
            }
        }
    }
    
    // 取出最后一个数组元素( + 号按钮),计算topView的高度
    UIButton *lastBtn = [self.tagsArray lastObject];
    
    self.topView.height = CGRectGetMaxY(lastBtn.frame) + channelCellMargin;
    
    // 获取上一次的高度,计算WDBottomBar的y值
    CGFloat oldHeight = self.height;
    
    self.height = self.topView.height + 35;
    
    self.y += oldHeight - self.height;
}


- (WDTagButton *)tagButtonWithTitle:(NSString *)title{
    
    WDTagButton *btn = [WDTagButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [btn sizeToFit];
    
    btn.height = 25;
    
    return btn;
}


- (void)addTagClick{
    
    WDAddTagViewController *addTagVC = [[WDAddTagViewController alloc] init];
    
    addTagVC.completeBlock = ^(){
        
        [self setupTagButtonWithStrArray:self.tagsStrArray];
    };
    
    // 将WDBottomBar中的按钮文本数组赋值给addTagVC
    addTagVC.tagsStrArray = self.tagsStrArray;
    
    // 拿到根控制器
    UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    // 拿到当前写段子控制器所在的导航控制器
    UINavigationController *naviC = (UINavigationController *)rootVC.presentedViewController;
    
    [naviC pushViewController:addTagVC animated:YES];
}

@end
