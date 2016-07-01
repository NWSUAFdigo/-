//
//  WDWordTableViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/30.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDWordTableViewController.h"
#import "WDWordData.h"

#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

@interface WDWordTableViewController ()

/** 当前页面所对应的数据数组 */
@property (nonatomic,strong) NSMutableArray *datas;
/** 记录上一次的maxtime,加载下一页时使用 */
@property (nonatomic,copy) NSString *maxtime;

@property (nonatomic,strong) NSMutableDictionary *parameters;


@end


@implementation WDWordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    CGFloat topInset = 64 + channelViewHeight;
    CGFloat bottomInset = self.tabBarController.tabBar.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
    
    // 如果tableView设置了contentInset,最好将滚动条的contentInset也进行响应设置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 使用MJRefresh给tableView添加一个页头
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    // 设置页头:自动调整透明度
    self.tableView.header.autoChangeAlpha = YES;
    
    // 开始刷新
    [self.tableView.header beginRefreshing];
    
    // 使用MJRefresh添加一个页尾
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.rowHeight = 50;
}


- (void)refresh{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @29;
    
    self.parameters = parameters;
    
    // 模拟网速慢时的网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            
            // 如果同时有多个网络请求,那么只执行最后一次的网络请求
            // 本句用来判断当前请求是否是最后一次网络请求
            if (self.parameters != parameters) {
                
                // 如果不是最后一次网络请求,需要将下拉刷新停掉,然后return
                [self.tableView.header endRefreshing];
                
                return;
            };
            
            // 记录maxtime
            self.maxtime = responseObject[@"info"][@"maxtime"];
            
            // 使用MJExtension将字典转模型
            self.datas = [WDWordData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            // 刷新表格
            [self.tableView reloadData];
            
            // 结束下拉刷新
            [self.tableView.header endRefreshing];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            // 结束下拉刷新
            [self.tableView.header endRefreshing];
        }];
        
    });
}


- (void)loadMoreData{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @29;
    parameters[@"maxtime"] = self.maxtime;
    
    self.parameters = parameters;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        if (self.parameters != parameters) {
            
            [self.tableView.footer endRefreshing];
            
            return;
        };
        
        // 记录maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray *newDatas = [WDWordData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 将新数据添加到数据数组中
        [self.datas addObjectsFromArray:newDatas];
        
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
    // 取出对应模型
    WDWordData *data = self.datas[indexPath.row];
    
    // 对cell进行设置
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.text;
    
    // 使用SDWebImage加载网络图片
    [cell.imageView sd_setImageWithURL:data.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    return cell;
}

@end