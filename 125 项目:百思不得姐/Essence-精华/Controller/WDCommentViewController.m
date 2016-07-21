//
//  WDCommentViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/10.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDCommentViewController.h"
#import "WDChannelCell.h"
#import "WDChannelCellData.h"
#import "WDChannelCellCommentData.h"
#import "WDChannelCellUserData.h"
#import "WDHeaderView.h"
#import "WDCommentTableViewCell.h"

#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>

@interface WDCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 评论工具条的底部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBarBottomConstraint;
/** 评论内容tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 热评和全部评论模型数组 */
@property (nonatomic,strong) NSMutableArray<NSArray *> *datas;
/** tableView的组数量 */
@property (nonatomic,assign) NSInteger groudCount;
/** 最后一个评论用户的ID */
@property (nonatomic,copy) NSString *lastID;

@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation WDCommentViewController


- (NSMutableArray *)datas{
    
    if (!_datas) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}


- (AFHTTPSessionManager *)manager{
    
    if (!_manager){
        
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


static NSString *const ID = @"commentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取消自动自动调整scrollView的Insets
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"评论";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"comment_nav_item_share_icon" highlightedImageName:@"comment_nav_item_share_icon_click" target:self action:@selector(rightBarButtomItemClick)];
    
    // 添加一个通知,监听键盘的弹出和关闭
    // 在控制器的dealloc方法中将控制器的观察者身份移除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 设置tableView的contentInset
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = WDViewBackgroundColor;
    
    // 注册评论cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WDCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    // 设置cell的高度为自适应(iOS8之后推出的功能)
    // 必须首先给cell一个评估高度
    self.tableView.estimatedRowHeight = 100;
    // 设置cell高度自适应
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置tableHeaderView
    [self setUpTableHeaderView];
    
    // 添加顶部下拉刷新
    [self setUpHeaderRefresh];
    
    // 底部添加上拉加载更多
    [self setUpFootLoadMore];
}


- (void)setUpTableHeaderView{
    
    // 创建一个UIView,将cell作为view里面的子控件.整个view作为tableHeaderView
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = WDViewBackgroundColor;
    
    // 计算HeaderView的高度:cell的高度 - 热评视图的高度
    CGFloat viewH = self.data.cellHeight - self.data.hotCmtViewH;
    
    view.height = viewH + channelCellMargin;
    
    // 加载WDChannelCell.xib
    WDChannelCell *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WDChannelCell class]) owner:nil options:nil] lastObject];
    
    headerView.data = self.data;
    
    // 设置cell的frame
    headerView.frame = CGRectMake(0, 0, WDScreenW, viewH);
    
    // 在添加WDChannelCell之前,需要将热评view隐藏
    // 热评view的隐藏需要在WDChannelCell设置data之后,也就是在headerView.data = self.data;这句之后设置
    headerView.hotCmtViewHidden = YES;
    
    [view addSubview:headerView];
    
    // 必须要在将view设置为headerView之前设置view的高度
    self.tableView.tableHeaderView = view;
    
    // 视频讲解中使用的是删除WDChannelCellData中top_cmt模型的方法来修改cell的内容;并在dealloc方法中将top_cmt模型补上
    // 参考:大神班 --> 08 百思不得姐 --> 0802 --> 09最热评论细节
}


- (void)setUpHeaderRefresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    self.tableView.header.autoChangeAlpha = YES;
    
    [self.tableView.header beginRefreshing];
}


- (void)refresh{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.data.ID;
    parameters[@"hot"] = @1;
    
    // 将manager中的所有任务清掉
    // AFN框架中,如果执行取消任务,会直接调用请求方法的failure block
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            
            [self.tableView.header endRefreshing];
            
            //
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                // 将热评数组和全部评论数组清空
                [self.datas removeAllObjects];
                
                // 将hot数据转为模型
                NSArray *hotDatas = [WDChannelCellCommentData mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
                
                // 将全部评论数据转为模型
                NSMutableArray *totalDatas = [WDChannelCellCommentData mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                
                // 将模型数组存入到datas中
                [self.datas addObject:hotDatas];
                [self.datas addObject:totalDatas];
                
                // 计算tableView的组数量
                // 根据热评数组的元素个数来判断组数量为1还是2
                self.groudCount = (hotDatas.count == 0) ? 1 : 2;
                
                // 刷新数据
                [self.tableView reloadData];
                
                // 记录最后一个评论的ID,用作加载更多时的请求参数
                WDChannelCellCommentData *lastData = [totalDatas lastObject];
                self.lastID = lastData.ID;
    //            WDLog(@"%@ -- %@",lastData.ID, lastData.user.ID);
             }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [self.tableView.header endRefreshing];
        }];
    });
}


- (void)setUpFootLoadMore{
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}


- (void)loadMore{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.data.ID;
    parameters[@"lastcid"] = self.lastID;
    
    // 首先将manager中的所有任务清掉
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.tableView.footer endRefreshing];
        
//        WDLog(@"%@", [responseObject class]);
        
        // 只有全部评论数量和全部评论模型数量不一致时,才需要将数据存储起来
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            // 将加载的数据存入全部评论数组
            NSArray *moreDatas = [WDChannelCellCommentData mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            NSMutableArray *totalDatas = (NSMutableArray *)[self.datas lastObject];
            
            [totalDatas addObjectsFromArray:moreDatas];
            
            [self.tableView reloadData];
            
            // 保存最后一个评论的ID
            self.lastID = [[moreDatas lastObject] ID];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.tableView.footer endRefreshing];
    }];
}


- (void)rightBarButtomItemClick{
    
    // 弹出alertSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([WDLoginTool getUid]) {
            
            WDLog(@"收藏到自己账号");
        }else {
            
            [WDLoginTool modalLoginController];
        }
    }];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([WDLoginTool getUid]) {
            
            WDLog(@"本账号举报该条内容");
        }else {
            
            [WDLoginTool modalLoginController];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    // 添加两个action
    [alert addAction:saveAction];
    [alert addAction:reportAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)keyboardFrameChange:(NSNotification *)noti{
    
//    WDLog(@"%@", noti.userInfo);
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 修改评论工具条底部约束
    self.commentBarBottomConstraint.constant = WDScreenH - keyboardFrame.origin.y;
    
    // 获得键盘弹出或隐藏时间
    CGFloat keyboardDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 执行动画将键盘弹出或隐藏
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 取消所有网络请求,并销毁manager
    [self.manager invalidateSessionCancelingTasks:YES];
}


#pragma mark - <UITableViewDataSource>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
    // 判断UIMenuController是否显示,如果显示,将其隐藏
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController.isMenuVisible) {
        
        [menuController setMenuVisible:NO animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 根据组的数量来决定每一种的row数量
    if (self.groudCount == 1) return [self.datas lastObject].count;
    else return self.datas[section].count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groudCount;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    if (self.groudCount == 1){
//        
//        return @"全部评论";
//    }
//    else {
//        
//        if (section == 0) return @"热门评论";
//        else return @"全部评论";
//    }
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // tableView中的header和footer视图和cell类似,也可以使用循环利用
    // 不过此时的header和footer视图不再是UIView,而是UITableViewHeaderFooterView
    // 本例中使用自定义UITableViewHeaderFooterView给其内部封装一个UIlabel
    
    static NSString *headerID = @"headerView";
    
    WDHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    
    if (headerView == nil) {
        
        headerView = [[WDHeaderView alloc] initWithReuseIdentifier:headerID];
        
        headerView.label.textColor = [UIColor darkGrayColor];
        
        headerView.label.font = [UIFont systemFontOfSize:14.0f];
    }
    
    if (self.groudCount == 1){

        headerView.label.text = @"全部评论";
    }
    else {

        if (section == 0) headerView.label.text = @"热门评论";
        else headerView.label.text = @"全部评论";
    }

    return headerView;
}


/** 根据section取出相应模型 */
- (NSArray *)datasOfSection:(NSInteger)section{
    
    if (self.groudCount == 1) {
        
        return [self.datas lastObject];
    }else {
        
        return self.datas[section];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    // 取出对应section的模型数据
    NSArray *sectionDatas = [self datasOfSection:indexPath.section];
    
    WDChannelCellCommentData *data = sectionDatas[indexPath.row];
    
    cell.data = data;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出对应的cell,并让其成为第一响应者
    WDCommentTableViewCell *cell = (WDCommentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // 在WDCommentTableViewCell中,重写becomeFirstResponder方法,给其添加UIMenuItem
    [cell becomeFirstResponder];
    
    /*
     UIMenuController的使用需求:
        1 点击同一个cell,如果UIMenuController显示,那么将其隐藏;如果其隐藏,将其显示
        2 点击不同的cell时,正在显示的UIMenuController消失,同时显示将要点击cell的UIMenuController
        3 滚动tableView时,UIMenuController消失
     
        需求1解决:
            在WDCommentTableViewCell重写的becomeFirstResponder方法中,获得UIMenuController并进行判断
            如果UIMenuController显示,那么将其隐藏;如果隐藏,那么创建新的UIMenuItem并添加到UIMenuController中
     
        需求2解决:
            如果点击不同的cell,那么会进入即将点击cell的becomeFirstResponder中
            而重写的becomeFirstResponder方法的第一句代码就是调用父类的该方法,让即将点击的cell成为第一响应者
            如果一个cell失去了第一响应者这个身份,那么他的UIMenuController将会自动隐藏消失
     
            这也解决了点击textField,或者点击导航控制器的返回按钮,UIMenuController的隐藏问题,因为点击这些,第一响应者会发生变化
     
        需求3解决:
            获得UIMenuController,如果其显示,那么将其隐藏
     */
}


@end
