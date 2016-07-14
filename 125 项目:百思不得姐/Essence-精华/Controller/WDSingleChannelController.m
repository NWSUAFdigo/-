//
//  WDSingleChannelController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/30.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDSingleChannelController.h"
#import "WDChannelCellData.h"
#import "WDChannelCell.h"
#import "WDCommentViewController.h"
#import "WDNewViewController.h"

#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

@interface WDSingleChannelController ()

/** 当前页面所对应的数据数组 */
@property (nonatomic,strong) NSMutableArray<WDChannelCellData *> *datas;
/** 记录上一次的maxtime,加载下一页时使用 */
@property (nonatomic,copy) NSString *maxtime;

@property (nonatomic,strong) NSMutableDictionary *parameters;
/** 记录上次选中的tabBar索引 */
@property (nonatomic,assign) NSInteger lastTabBarSelectedIndex;
/** 请求参数@"a"的值 */
@property (nonatomic,copy) NSString * paraA;

@end


@implementation WDSingleChannelController


static NSString * const ID = @"wordCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    [self setUpTableView];
    
    // 设置请求参数a和上次选中的tabBar索引
    [self setUpParaAndIndex];
    
    // 使用MJRefresh给tableView添加一个页头
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    // 设置页头:自动调整透明度
    self.tableView.header.autoChangeAlpha = YES;
    
    // 开始刷新
    [self.tableView.header beginRefreshing];
    
    // 使用MJRefresh添加一个页尾
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // self成为观察者,监听tabBar按钮的点击
    // 由于WDSingleChannelController类一共创建了5个对象(全部\视频\图片\声音\段子),所以最终会有5个对象成为tabBar按钮点击的观察者
    // 但是WDSingleChannelController对象想要成为观察者,必须先创建并调用viewDidLoad方法
    // 所以程序一启动后,只有 全部 频道的viewDidLoad调用了,所以程序一启动只有 全部 频道一个观察者
    // 滑动屏幕,某个频道调用viewDidLoad方法后,那么该频道对象就成为观察者了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarItemSelected) name:WDTabBarSelectedItemNoti object:nil];
}


- (void)setUpTableView{
    
    // 设置tableView
    CGFloat topInset = 64 + channelViewHeight;
    CGFloat bottomInset = self.tabBarController.tabBar.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
    
    // 如果tableView设置了contentInset,最好将滚动条的contentInset也进行响应设置
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WDChannelCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
}


- (void)setUpParaAndIndex{
    
    // 如果当前控制器的父控制器类是WDNewViewController,那么请求参数a为newlist;如果不是,那么请求参数a为list
    // 注意:不能判断父控制器类是否是WDEssenceViewController,因为WDNewViewController继承自WDEssenceViewController,所以判断父控制器类为WDEssenceViewController没用
    
    if ([self.parentViewController isKindOfClass:[WDNewViewController class]]) {
        
        self.paraA = @"newlist";
        self.lastTabBarSelectedIndex = 1;
    }else{
        
        self.paraA = @"list";
        self.lastTabBarSelectedIndex = 0;
    }
}


- (void)tabBarItemSelected{
    
    // 获得tabBarController的当前选中按钮(控制器)的索引
    NSInteger selectedIndex = self.tabBarController.selectedIndex;
    
    // 取出当前索引所对应的控制器
    UIViewController *vc = self.tabBarController.childViewControllers[selectedIndex];
    
    // 判断当前索引对应的控制器是否是self的导航控制器
    if (vc == self.navigationController) {
        
        // 来到这里说明:self的父控制器,也就是WDNewViewController或者WDEssenceViewController正在屏幕上显示
        // 而我们的目的就是要对正在显示的tableView进行处理,没在屏幕显示的tableView不进行处理
        
        // 判断这次选择的tabBarItem和上次选择的是否一致
        // 注意:如果self的父控制器是WDNewViewController,那么需要将其self.lastTabBarSelectedIndex初始为1
        if (selectedIndex == self.lastTabBarSelectedIndex) {
            
            // 判断当前控制器的根视图是否在屏幕上
            if (self.view.isShowOnKeyWindow) {
                
                // 如果显示在屏幕上,那么调用其下拉刷新
                [self.tableView.header beginRefreshing];
            }
        }
    }
    
    // 记录这次选中的索引
    self.lastTabBarSelectedIndex = selectedIndex;
}


///** 请求参数@"a"的取值 */
//- (NSString *)parametersA{
//    
//    // 如果当前控制器的父控制器类是WDNewViewController,那么请求参数a为newlist;如果不是,那么请求参数a为list
//    // 注意:不能判断父控制器类是否是WDEssenceViewController,因为WDNewViewController继承自WDEssenceViewController,所以判断父控制器类为WDEssenceViewController没用
//    
//    if ([self.parentViewController isKindOfClass:[WDNewViewController class]]) {
//        
//        return @"newlist";
//    }
//    
//    return @"list";
//}


- (void)refresh{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.paraA;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.typeIdentify);
    
    self.parameters = parameters;
    
    // 模拟网速慢时的网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
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
            self.datas = [WDChannelCellData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
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
    parameters[@"a"] = self.paraA;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.typeIdentify);
    parameters[@"maxtime"] = self.maxtime;
    
    self.parameters = parameters;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (self.parameters != parameters) {
            
            [self.tableView.footer endRefreshing];
            
            return;
        };
        
        // 记录maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray *newDatas = [WDChannelCellData mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
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
    
    WDChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    // 取出对应模型
    WDChannelCellData *data = self.datas[indexPath.row];
    
    cell.data = data;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 由于cell的高度只和每一个cell中文字内容的长度有关,所以可以将cell的高度也封装到每一个cell的模型中
    // 并且由于本方法的调用非常频繁,所以可以通过懒加载的方式来获得每一个cell的高度
    
    // 取出对应模型
    WDChannelCellData *data = self.datas[indexPath.row];
    
    return data.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDCommentViewController *commentVC = [[WDCommentViewController alloc] init];
    
    commentVC.data = self.datas[indexPath.row];
    
    [self.navigationController pushViewController:commentVC animated:YES];
}

@end