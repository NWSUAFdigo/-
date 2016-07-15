//
//  WDTableFooterView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTableFooterView.h"
#import "WDMeFooterViewData.h"
#import "WDMeFooterButton.h"
#import "WDTabBarController.h"
#import "WDFootButtonViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIButton+WebCache.h>

@interface WDTableFooterView ()

@property (nonatomic,strong) NSMutableArray *datas;

@end


@implementation WDTableFooterView

- (void)awakeFromNib{
    
    self.backgroundColor = [UIColor clearColor];
    
    // 发送请求
    [self postRequest];
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self postRequest];
    }
    return self;
}


/** 发送请求,加载数据显示在footerView上面 */
- (void)postRequest{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.datas = [WDMeFooterViewData mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        
        // 获得数据后,添加每个小按钮并进行设置
        [self setupButton];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}


/** 添加小按钮并进行设置 */
- (void)setupButton{
    
    // 设置列数为4
    NSInteger col = 4;
    
    // 计算得到每个按钮的宽度
    CGFloat width = self.width / col;
    
    // 根据宽度设置每个按钮的高度
    CGFloat height = width;
    
    for (NSInteger i = 0; i < self.datas.count; i++) {
        
        WDMeFooterViewData *data = self.datas[i];
        
        WDMeFooterButton *button = [WDMeFooterButton buttonWithType:UIButtonTypeCustom];
        
        // 将对应的数据赋值给对应的按钮
        button.data = data;
        
        // 将按钮添加到底部视图上
        [self addSubview:button];
        
        // 设置按钮的尺寸和位置: 行 row  列 column
        // 计算按钮的行号
        NSInteger btnRow = i / 4;
        
        // 计算列号
        NSInteger btnCol = i % 4;
        
        CGFloat x = width * btnCol;
        CGFloat y = height * btnRow;
        
        CGRect btnFrame = CGRectMake(x, y, width, height);
        
        // 修改frame,使其向内伸缩
        btnFrame.size.width -= 1;
        btnFrame.size.height -= 1;
        
        button.frame = btnFrame;
        
        // 添加按钮点击监听
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 得到self的高度
    // 计算按钮的总行数
    // 万能公式: 行数 = (元素总个数 + 列数 - 1) / 列数
    NSInteger totalRow = (self.datas.count + col - 1) / col;
    
    self.height = height * totalRow;
    
//    [self setNeedsDisplay];
    
    /*
     注意:
        setNeedsDisplay方法是对self进行重新布局
        如果使用该方法,那么self,也就是WDTabelFooterView的显示是没有问题的
     
        但是self的高度是通过加载数据动态获得的,而在数据加载完毕前,在WDMeViewController中,虽然指定了self为tableView的footerView,但是并没有给其一个高度
        这就造成一个问题:数据没有回来前,WDMeViewController已经显示完毕.由于在显示完毕之前没有对footerView设置高度,因此高度为0
     
        现在要做的就是:在数据回来后,重新对footerView的高度进行赋值
     
    重新对footerView的高度赋值的方式:
        方式1 将self作为tableView的footerView重新赋值一遍
        方式2 修改tableView的contentSize
     */
    
    UITableView *tableView = (UITableView *)self.superview;
    
//     方式1
//    tableView.tableFooterView = self;
    // 使用方式1,tableView的底部会多出20点的高度.可以修改contentSize来将其去除
    
//    CGSize contentSize = tableView.contentSize;
//    contentSize.height -= 20;
//    tableView.contentSize = contentSize;
    
    // 方式2
    CGSize contentSize = tableView.contentSize;
    contentSize.height = CGRectGetMaxY(self.frame);
    tableView.contentSize = contentSize;
    
//    WDLog(@"%@ -- %@", NSStringFromCGSize(tableView.contentSize), NSStringFromCGRect(tableView.tableFooterView.frame));
}


- (void)buttonClick:(WDMeFooterButton *)button{
    
    // 如果URL不是HTTP开头,那么不需要创建控制器并跳转
    if (![button.data.url.absoluteString hasPrefix:@"http"]) return;
    
    // 拿到FooterView所在的导航控制器
    WDTabBarController *tabBarC = (WDTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *selectedNaviC = tabBarC.selectedViewController;
    
    // 创建需要push的控制器
    WDFootButtonViewController *footerBtnVC = [[WDFootButtonViewController alloc] init];
    
    footerBtnVC.title = button.data.name;
    footerBtnVC.url = button.data.url;
    
    [selectedNaviC pushViewController:footerBtnVC animated:YES];
}

@end
