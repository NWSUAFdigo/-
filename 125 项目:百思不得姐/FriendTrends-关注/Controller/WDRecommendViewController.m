//
//  WDRecommendViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRecommendViewController.h"
#import "WDLeftTableViewData.h"
#import "WDLeftTableViewCell.h"
#import "WDRightTableViewData.h"
#import "WDRightTableViewCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>


@interface WDRecommendViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 左侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic,strong) NSMutableArray<WDLeftTableViewData *> *leftTableViewData;
/** 右侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic,weak) NSMutableArray<WDRightTableViewData *> *rightTableViewData;
// 由于self.rightTableViewData属性是通过WDLeftTableViewData模型中的rightTableViewData属性(strong强指针)获得,所以可以将本属性设为weak

@end


@implementation WDRecommendViewController


static NSString *IDLeftCell = @"leftTableViewCell";
static NSString *IDRightCell = @"rightTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐关注";
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 对左侧tableView进行设置
    // 已经在xib中通过连线指定leftTableView的delegate和datasource
    self.leftTableView.backgroundColor = WDColor(233, 233, 233, 1);
    
    // 给footerView添加一个UIView,目的是如果tableView的内容不能填满整个tableView的高度时,多余的cell不再显示
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    
    // 取消左侧滚动条
    self.leftTableView.showsVerticalScrollIndicator = NO;
    
    // 注册cell.加载xib中的cell,并给其绑定标识
    [self.leftTableView registerNib:[UINib nibWithNibName:@"WDLeftTableViewCell" bundle:nil] forCellReuseIdentifier:IDLeftCell];
    
    
    // 对右侧tableView进行设置
    // 已经在xib中通过连线指定rightTableView的delegate和datasource
    self.rightTableView.tableFooterView = [[UIView alloc] init];
    
    // 注册cell
//    [self.rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDRightCell];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"WDRightTableViewCell" bundle:nil] forCellReuseIdentifier:IDRightCell];
    
    // 使用MJRefresh框架对右侧表格添加 上拉加载更多数据功能
    self.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.rightTableView.mj_footer.hidden = NO;
    
    // 对tableView的contentInset进行统一设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.leftTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.rightTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
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

        // 使用MJExtension将字典数组转换为模型数组
        [WDLeftTableViewData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        self.leftTableViewData = [WDLeftTableViewData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
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


/** 右侧表格底部的上拉刷新功能 */
- (void)loadMoreData{
    
    WDLeftTableViewData *data = self.leftTableViewData[[self.leftTableView indexPathForSelectedRow].row];
        
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(data.ID);
    parameters[@"page"] = @(++data.currentPage);
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //                    WDLog(@"%@", responseObject);
        
        // 将加载的数据存入左侧表格模型的rightTableViewData属性中
        NSArray *newData = [WDRightTableViewData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [data.rightTableViewData addObjectsFromArray:newData];
        
        self.rightTableViewData = data.rightTableViewData;
        
        // 刷新右侧表格
        [self.rightTableView reloadData];
        
//        if (data.total == data.rightTableViewData.count) {
//            
//            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            
//            // 将上拉刷新控件复原(结束刷新)
//            [self.rightTableView.mj_footer endRefreshing];
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //                    WDLog(@"%@", error);
    }];
    
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        
        return self.leftTableViewData.count;
    }else {
        
        // 在这个方法中对右边表格的底部的隐藏和显示进行设置,右边表格有数据时,显示mj_footer,没有数据时,隐藏mj_footer
        // 因为mj_footer的隐藏是需要self.rightTableViewData为空,而self.rightTableViewData的数值一旦发生变化,都需要reloadData
        // 而reloadData就会来到该方法,所以在该方法中进行设置
        self.rightTableView.mj_footer.hidden = (self.rightTableViewData == nil);
        
        // 将mj_footer内容的判断写在这里不太好,有显示问题
        WDLeftTableViewData *data = self.leftTableViewData[[self.leftTableView indexPathForSelectedRow].row];
        
        
        if (data.total == data.rightTableViewData.count) {
            
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            
            [self.rightTableView.mj_footer endRefreshing];
        }
        
        return self.rightTableViewData.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        WDLeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IDLeftCell];
        
        WDLeftTableViewData *data = self.leftTableViewData[indexPath.row];
        
        cell.data = data;
        
        // 无网络加载时测试
//        cell.textLabel.text = [NSString stringWithFormat:@"%luabc", indexPath.row];
        
        return cell;
    }else {
        
        WDRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDRightCell];
        
        WDRightTableViewData *data = self.rightTableViewData[indexPath.row];
        
        cell.data = data;
       
        return cell;
    }
    
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        WDLeftTableViewData *data = self.leftTableViewData[indexPath.row];
        
        // 判断data中的rightTableViewData属性是否有值,来决定是否进行网络请求
        if (data.rightTableViewData) {
            
            self.rightTableViewData = data.rightTableViewData;
            [self.rightTableView reloadData];
            
            // 进入这里说明点击的cell已经从网络上请求了一些数据
//            if (data.total == data.rightTableViewData.count) {
//                
//                // 进入这里说明点击的cell的所有数据已经请求完成,那么mj_footer需要显示:数据加载完毕
//                [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
//            }else {
//                
//                // 进入这里说明点击的cell只有部分数据请求完成,那么mj_footer需要显示:上拉加载更多数据
//                [self.rightTableView.mj_footer endRefreshing];
//            }
            /*
             注意:
                上面的if判断语句在三个地方出现: 
                    1 loadMoreData方法
                    2 本例if (data.rightTableViewData)
                    3 本例else
                三个地方都有reloadData,可以将其统一放在numberOfRowsInSection方法中进行设置
             */
        } else {
            
            // 点击tableView的任一行,无论网络加载是否完成,都需要将之前点击的数据从视图中清除
            // 通过将self.rightTableViewData置空,并且刷新表格的方式将之前的表格数据从视图中清除
            self.rightTableViewData = nil;
            [self.rightTableView reloadData];
            
            // 模拟网速慢时的情况
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                parameters[@"a"] = @"list";
                parameters[@"c"] = @"subscribe";
                parameters[@"category_id"] = @(data.ID);
                
                [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    WDLog(@"%@", responseObject);
                    
                    // 将加载的数据存入左侧表格模型的rightTableViewData属性中
                    data.rightTableViewData = [WDRightTableViewData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                    
                    data.total = [responseObject[@"total"] integerValue];
                    
                    // 任何cell在初次网络请求时都需要将当前页面设置为1
                    data.currentPage = 1;
                    
                    self.rightTableViewData = data.rightTableViewData;
                    
                    // 判断当前返回的右侧表格行数和总行数是否相等
//                    if (data.total == data.rightTableViewData.count) {
//                    
//                        [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
//                    }else {
//                        
//                        [self.rightTableView.mj_footer endRefreshing];
//                    }
                    
                    // 刷新右侧表格
                    [self.rightTableView reloadData];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    WDLog(@"%@", error);
                }];
                
            });
        }
    }
}


@end
