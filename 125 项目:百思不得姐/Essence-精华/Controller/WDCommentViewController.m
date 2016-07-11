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

@interface WDCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 评论工具条的底部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBarBottomConstraint;
/** 评论内容tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WDCommentViewController


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
    
    // 设置tableHeaderView
    [self setUpTableHeaderView];
}


- (void)setUpTableHeaderView{
    
    // 创建一个UIView,将cell作为view里面的子控件.整个view作为tableHeaderView
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = WDViewBackgroundColor;
    
    view.height = self.data.cellHeight + channelCellMargin;
    
    // 加载WDChannelCell.xib
    WDChannelCell *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WDChannelCell class]) owner:nil options:nil] lastObject];
    
    headerView.data = self.data;
    
    // 设置cell的frame
    headerView.frame = CGRectMake(0, 0, WDScreenW, self.data.cellHeight);
    
    [view addSubview:headerView];
    
    // 必须要在将view设置为headerView之前设置view的高度
    self.tableView.tableHeaderView = view;
}


- (void)rightBarButtomItemClick{
    
    WDLogFunc;
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
}


#pragma mark - <UITableViewDataSource>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"section-%lu", section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"hello-%lu-%lu",indexPath.section, indexPath.row];
    
    return cell;
}


@end
