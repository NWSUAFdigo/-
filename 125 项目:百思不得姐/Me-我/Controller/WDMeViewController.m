//
//  WDMeViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/23.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDMeViewController.h"
#import "WDMeTableViewCell.h"
#import "WDTableFooterView.h"
#import "WDSettingTableViewController.h"

@implementation WDMeViewController

static NSString *ID = @"meCell";
- (void)viewDidLoad{
    
    [super viewDidLoad];

    // 设置导航栏
    [self setUpNaviBar];
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 注册cell
    [self.tableView registerClass:[WDMeTableViewCell class] forCellReuseIdentifier:ID];
    
    // 设置tableView
    [self setUpTableView];
}


/** 设置导航栏按钮 */
- (void)setUpNaviBar{

    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *settingItem = [UIBarButtonItem barButtonItemWithImageName:@"mine-setting-icon" highlightedImageName:@"mine-setting-icon-click" target:self action:@selector(settingBtnClick)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem barButtonItemWithImageName:@"mine-moon-icon" highlightedImageName:@"mine-moon-icon-click" target:self action:@selector(moonBtnClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    // 注意:rightBarButtonItems数组中,先添加的Item位于右侧,后添加的Item位于先添加的Item的左侧
}


/** 设置tableView */
- (void)setUpTableView{
    
    // 如果tableView的样式为grouped,那么tableView中cell的间距受以下几个属性影响:
    // tableHeaderView  sectionHeaderHeight  sectionFooterHeight  tableFooterView
    /*
     说明:
        1 如果tableHeaderView 或者 tableFooterView 没有设置,那么默认在tableView的顶部或底部有35点的间距
        2 如果设置了tableHeaderView 或者 tableFooterView,但是没有设置高度,那么仍然是35点间距
        3 只有设置了tableHeaderView 或者 tableFooterView,并且设置高度值不为0,那么顶部或底部的间距才是设置的高度
     
        3 默认已经为sectionHeaderHeight 和 sectionFooterHeight 设置了一定的数值
        4 如果用户自行设置了sectionHeaderHeight 或 sectionFooterHeight,那么会以用户设置的数值为准,此时高度可以设置为0
     */
    
    // 添加一个tableHeaderView,并设置高度.目的是修改tableView的头部高度
    UIView *headerView = [[UIView alloc] init];
    
    headerView.height = channelCellMargin;
    
    self.tableView.tableHeaderView = headerView;
    
    // 设置section的头部和底部高度
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = channelCellMargin;
    
    // 创建一个tableFooterView
    WDTableFooterView *footerView = [[WDTableFooterView alloc] init];
    
    self.tableView.tableFooterView = footerView;
}


/** 该方法在tableView滚动过程中持续调用 */
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    WDTableFooterView *footerView = (WDTableFooterView *)self.tableView.tableFooterView;
    
    // bug:点击footerView的按钮进入WDFootButtonViewController,然后返回到本控制器时,footerView的滚动发生了改变
    CGSize contentSize = self.tableView.contentSize;
    contentSize.height = CGRectGetMaxY(footerView.frame);
    self.tableView.contentSize = contentSize;
    
//    self.tableView.contentOffset = footerView.offset;
    // 无法在此处设置tableView的contentOffset,因为该方法中,contentOffset一直在变化
}


- (void)settingBtnClick{
    
    WDSettingTableViewController *settingVC = [[WDSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)moonBtnClick{
    
    WDLogFunc;
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (indexPath.section == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
        
        cell.textLabel.text = @"登录/注册";
    }else if (indexPath.section == 1) {
        
        cell.imageView.image = nil;
        
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.selected = NO;
        
        if ([WDLoginTool getUid]) {
            
            WDLog(@"登录账号");
        }else {
            
            [WDLoginTool modalLoginController];
        }
    }
}


@end
