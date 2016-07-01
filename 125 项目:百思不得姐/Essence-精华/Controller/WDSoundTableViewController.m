//
//  WDSoundTableViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/30.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDSoundTableViewController.h"

@interface WDSoundTableViewController ()

@end

@implementation WDSoundTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView的contentInset
    // contentInset属性应该在最后一个能够滚动的视图上
    // 本例中需要在垂直方向上设置contentInset,而最后一个能够滚动的视图是scrollView里面的tableView
    // 由于tableView需要在垂直方向上滚动,那么其父控件scrollView就尽量不要设置垂直方向上的滚动
    // 如果contentInset设置在scrollView上,那么tableView是无法实现穿透效果的
    CGFloat topInset = 64 + channelViewHeight;
    CGFloat bottomInset = self.tabBarController.tabBar.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
    
    // 如果tableView设置了contentInset,最好将滚动条的contentInset也进行响应设置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %lu", [self class], indexPath.row];
    
    return cell;
}

@end