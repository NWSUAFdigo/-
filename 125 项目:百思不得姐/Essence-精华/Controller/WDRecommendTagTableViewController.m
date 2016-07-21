//
//  WDRecommendTagTableViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/28.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRecommendTagTableViewController.h"
#import "WDRecommendTagData.h"
#import "WDRecommendTagCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface WDRecommendTagTableViewController ()

@property (nonatomic,strong) NSMutableArray<WDRecommendTagData *> *datas;

@end


@implementation WDRecommendTagTableViewController


static NSString *ID = @"recommendTag";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐标签";
    
    // 设置tableView
    self.tableView.backgroundColor = WDViewBackgroundColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WDRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    self.tableView.rowHeight = 60;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self loadRequest];
}

/** 加载网络请求 */
- (void)loadRequest{
    
    // 显示HUD
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
    
    // 模拟网速慢时的情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"a"] = @"tag_recommend";
        parameters[@"action"] = @"sub";
        parameters[@"c"] = @"topic";
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            // 隐藏HUD
            [SVProgressHUD dismiss];
            
            self.datas = [WDRecommendTagData mj_objectArrayWithKeyValuesArray:responseObject];
            
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];
    });
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WDRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    WDRecommendTagData *data = self.datas[indexPath.row];
    
    cell.data = data;
    
    return cell;
}

@end
