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


@interface WDRecommendViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 左侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic,strong) NSMutableArray<WDLeftTableViewData *> *leftTableViewData;
/** 右侧tableView */
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic,strong) NSMutableArray<WDRightTableViewData *> *rightTableViewData;

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


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        
        return self.leftTableViewData.count;
    }else {
        
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
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"a"] = @"list";
        parameters[@"c"] = @"subscribe";
        parameters[@"category_id"] = @(data.ID);
        
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            WDLog(@"%@", responseObject);
            
            self.rightTableViewData = [WDRightTableViewData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            // 刷新右侧表格
            [self.rightTableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            WDLog(@"%@", error);
        }];
    }
}


@end
