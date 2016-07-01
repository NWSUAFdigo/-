//
//  WDEssenceViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDEssenceViewController.h"
#import "WDRecommendTagTableViewController.h"

#import "WDAllTableViewController.h"
#import "WDVideoTableViewController.h"
#import "WDPictureTableViewController.h"
#import "WDWordTableViewController.h"
#import "WDSoundTableViewController.h"

@interface WDEssenceViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIView *redBar;
@property (nonatomic,weak) UIButton *lastChannelBtn;
@property (nonatomic,weak) UIView *channelView;
@property (nonatomic,weak) UIScrollView * scrollView;

@end


@implementation WDEssenceViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"MainTagSubIcon" highlightedImageName:@"MainTagSubIconClick" target:self action:@selector(tagBtnClick)];
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 取消自动调整scrollViewInsets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 给控制器添加子控制器
    [self setUpChildViewController];
    
    // 添加顶部频道View
    [self setUpChannelView];

    // 添加一个scrollView,作为内容的展示区
    [self setUpContentScrollView];
    
}


- (void)setUpChannelView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, channelViewHeight)];
    
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    
    // 添加单个频道按钮
    CGFloat y = 0;
    
    CGFloat width = view.width / self.childViewControllers.count;
    
    CGFloat height = view.height;
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:WDColor(222, 20, 0, 1) forState:UIControlStateDisabled];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        // 给btn绑定tag.tag为0-4
        btn.tag = i;
        
        CGFloat x = width * i;
        
        btn.frame = CGRectMake(x, y, width, height);
        
//        btn.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:btn];
        
        [btn addTarget:self action:@selector(channelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 让第一个频道按钮作为初始的lastChannelBtn
        if (self.lastChannelBtn != nil) continue;
        
        self.lastChannelBtn = btn;
    }
    
    // 添加底部红色条
    UIView *redBar = [[UIView alloc] init];
    
    redBar.height = 3;
    redBar.y = view.height - redBar.height;
    
    redBar.backgroundColor = WDColor(222, 20, 0, 1);
    
    [view addSubview:redBar];
    
    self.redBar = redBar;
    
    [self.view addSubview:view];
    
    self.channelView = view;
    
    
    // 强制布局初始的lastChannelBtn(第一个频道按钮)
    [self.lastChannelBtn layoutSubviews];
    
    // 对redBar修改尺寸和位置
    self.redBar.width = self.lastChannelBtn.titleLabel.width + 10;
    self.redBar.x = self.lastChannelBtn.center.x - self.redBar.width * 0.5;
    
    // 让初始lastChannelBtn处于不可用(会调用设置好的不可用状态的文字颜色)
    self.lastChannelBtn.enabled = NO;
}


- (void)setUpContentScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    // 设置scrollView的frame为整个窗口
    scrollView.frame = self.view.bounds;
    
    // scrollView设置分页
    scrollView.pagingEnabled = YES;
    
//    // 设置scrollView的contentInset
//    CGFloat topInset = CGRectGetMaxY(self.channelView.frame);
//    CGFloat bottomInset = self.tabBarController.tabBar.height;
    
//     contentInset就相当于在contentSize的基础上多增加或减少部分内容
//    scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
    
    // 设置scrollView
    scrollView.backgroundColor = WDViewBackgroundColor;
    scrollView.contentSize = CGSizeMake(self.view.width * 5, 0);
    scrollView.bounces = NO;
    
    // 将scrollView插入到self.view的子控件底部
    [self.view insertSubview:scrollView atIndex:0];
    
    scrollView.delegate = self;
    
    // 将"全部"频道的tableView添加到scrollView上面
    UITableViewController *tableVC = self.childViewControllers[0];
    
    tableVC.tableView.frame = scrollView.bounds;

    [scrollView addSubview:tableVC.tableView];
    
    self.scrollView = scrollView;
}


- (void)setUpChildViewController{
    
    WDWordTableViewController *wordVC = [[WDWordTableViewController alloc] init];
    wordVC.title = @"段子";
    [self addChildViewController:wordVC];
    
    WDAllTableViewController *allVC = [[WDAllTableViewController alloc] init];
    allVC.title = @"全部";
    [self addChildViewController:allVC];
    
    WDVideoTableViewController *videoVC = [[WDVideoTableViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    WDPictureTableViewController *pictureVC = [[WDPictureTableViewController alloc] init];
    pictureVC.title = @"图片";
    [self addChildViewController:pictureVC];
    
    WDSoundTableViewController *soundVC = [[WDSoundTableViewController alloc] init];
    soundVC.title = @"声音";
    [self addChildViewController:soundVC];
}


- (void)channelBtnClick:(UIButton *)btn{
    
    // 将上次选中的按钮变为可用
    // 将这次选中的按钮变为不可用
    self.lastChannelBtn.enabled = YES;
    btn.enabled = NO;
    self.lastChannelBtn = btn;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.redBar.width = btn.titleLabel.width + 10;
        self.redBar.x = btn.center.x - self.redBar.width * 0.5;
    }];
    
    // 修改self.scrollView的contentOffset
    CGPoint contentOffset = CGPointMake(btn.tag * self.scrollView.width, 0);
    
    // 重新设置scrollView的contentOffset
    // 非手动滑动引起的contentOffset改变,将会调用scrollView的scrollViewDidEndScrollingAnimation方法
    // 手动滑动引起的contentOffset改变,将会调用scrollView的scrollViewDidEndDecelerating方法
    [self.scrollView setContentOffset:contentOffset animated:YES];
}


- (void)tagBtnClick{
    
    // 推荐关注控制器跳转
    WDRecommendTagTableViewController *vc = [[WDRecommendTagTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <UIScrollViewDelegate>
/** 非手动滑动引起的contentOffset改变将会来到这个方法 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    // 计算出当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出当前索引所对应的UITableViewController对象
    UITableViewController *tableVC = self.childViewControllers[index];
    
    // 如果在scrollView的子视图中已经有了tableVC的tableView,那么直接返回
    if ([scrollView.subviews containsObject:tableVC.tableView]) return;
    
    
    // 来到这里说明tableVC.tableView还没有添加到scrollView的子视图中
    tableVC.tableView.frame = CGRectMake(index * scrollView.width, 0, scrollView.width, scrollView.height);
    
//    // 设置tableView的contentInset
//    CGFloat topInset = CGRectGetMaxY(self.channelView.frame);
//    CGFloat bottomInset = self.tabBarController.tabBar.height;
//    
//    tableVC.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
//    tableVC.tableView.scrollIndicatorInsets = tableVC.tableView.contentInset;
    
    [scrollView addSubview:tableVC.tableView];
}


/** 手动滑动引起的contentOffset改变将会来到这个方法 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 计算出当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
 
    // 找出当前索引所对应的频道按钮,并调用其点击方法
    for (UIButton *btn in self.channelView.subviews) {
        
        // 由于在self.channelView中,底部的红色bar没有绑定tag,所以默认其tag值为0
        // 因此除了要判断btn的tag值是否为index外,还需要判断btn的类型是否是UIButton
        if (btn.tag == index && [btn isKindOfClass:[UIButton class]]) {
            
            [self channelBtnClick:self.channelView.subviews[index]];
            
            break;
        }
    }
    
}

@end
