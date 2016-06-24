//
//  WDRecommendViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRecommendViewController.h"
#import "WDRightTableViewCellView.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>


@interface WDRecommendViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 左侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *leftTableViewData;
/** 右侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *rightTableViewData;

@end


@implementation WDRecommendViewController


- (NSMutableArray<NSDictionary *> *)leftTableViewData{
    
    if (!_leftTableViewData){
        
        _leftTableViewData = [NSMutableArray array];
    }
    return _leftTableViewData;
}


- (NSMutableArray<NSDictionary *> *)rightTableViewData{
    
    if (!_rightTableViewData){
        
        _rightTableViewData = [NSMutableArray array];
    }
    return _rightTableViewData;
}


static NSString *IDLeftCell = @"leftTableViewCell";
static NSString *IDRightCell = @"rightTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐关注";
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 对左侧tableView进行设置
    self.leftTableView.backgroundColor = WDColor(233, 233, 233, 1);
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.separatorColor = [UIColor whiteColor];
    
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    
    // 注册cell
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDLeftCell];
    
    
    // 对右侧tableView进行设置
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    self.rightTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.rightTableView.tableFooterView = [[UIView alloc] init];
    
    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDRightCell];
    
    
    
    // 添加HUD
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
    
    // 请求左侧tableView频道数据
    [self leftTableViewRequest];
}


- (void)leftTableViewRequest{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    
    /*
     在iOS9 beta1中，苹果将原http协议改成了https协议，使用 TLS1.2 SSL加密请求数据。
     所以直接加载http协议文件是无法进行的（不会去加载）
     
     解决办法：
     在info.plist中添加（通过Source Code打开）
     <key>NSAppTransportSecurity</key><dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/></dict>
     */
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WDLog(@"%@", responseObject);
        
        self.leftTableViewData = responseObject[@"list"];
        
        // 刷新表格
        [self.leftTableView reloadData];

        [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 隐藏HUD
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        WDLog(@"%@", error);
        
        // 显示请求失败
        [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
        
        // 返回上一个控制器
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        
        return self.leftTableViewData.count;
    }else {
        
        return self.rightTableViewData.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (tableView == self.leftTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:IDLeftCell];
        
        cell.backgroundColor = [UIColor clearColor];
        
        NSDictionary *data = self.leftTableViewData[indexPath.row];
        
        cell.textLabel.text = data[@"name"];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.textLabel.highlightedTextColor = [UIColor redColor];
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:IDRightCell];
        
        WDRightTableViewCellView *cellView;
        
        if (cell.contentView.subviews.count == 0) {
            
            cellView = [WDRightTableViewCellView rightTableViewCellView];
            
            cellView.frame = cell.contentView.bounds;
            
            [cell.contentView addSubview:cellView];
        }else {
            
            cellView = [cell.contentView.subviews lastObject];
        }
        
        
        NSDictionary *data = self.rightTableViewData[indexPath.row];
        
        [cellView.icon sd_setImageWithURL:data[@"header"]];
        
        cellView.fansCount = [data[@"fans_count"] integerValue];
        
        cellView.screenName = data[@"screen_name"];
    }
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        NSDictionary *data = self.leftTableViewData[indexPath.row];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"a"] = @"list";
        parameters[@"c"] = @"subscribe";
        parameters[@"category_id"] = data[@"id"];
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            WDLog(@"%@", responseObject);
            
            self.rightTableViewData = responseObject[@"list"];
            
            // 刷新右侧表格
            [self.rightTableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            WDLog(@"%@", error);
        }];
    }
}


@end
