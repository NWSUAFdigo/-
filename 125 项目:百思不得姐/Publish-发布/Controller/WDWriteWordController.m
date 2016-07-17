//
//  WDWriteWordController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDWriteWordController.h"

@interface WDWriteWordController ()

@property (nonatomic,weak) UITextView * textView;

@end

@implementation WDWriteWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNaviBarItem];
    
    // 
    [self setupTextView];
}


/** 对导航栏进行设置 */
- (void)setupNaviBarItem{
    
    self.title = @"写段子";
    
    // 该方法可以对导航栏中间文字的属性进行设置(大小\颜色...)
    //    [self.navigationController.navigationBar setTitleTextAttributes:<#(NSDictionary<NSString *,id> * _Nullable)#>];
    
    // 设置左侧按钮
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithTitle:@"取消" target:self action:@selector(cancelClick)];
    
    // 设置右侧按钮
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithTitle:@"发布" target:self action:@selector(publishClick)];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // UIBarButtonItem的disabled状态下的文字属性比较特殊.
    /*
     说明:
        1 不能将UIBarButtonItem的disabled状态在viewDidLoad方法中进行设置
        2 应该在viewWillAppear 或者 viewDidAppear方法中进行设置
        3 如果使用setTitleTextAttributes: forState:方法只是修改了disabled状态下的文字属性,那么该修改将不会起作用
        4 在修改disabled状态的同时,还需要修改其他状态(本例中修改了normal和disabled状态),才能使disabled状态的文字属性起作用.同时还必须在viewWillAppear 或者 viewDidAppear方法中设置UIBarButtonItem的enabled属性为NO(disabled状态)
     */
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


/** 设置导航栏两侧按钮 */
- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    
    // 设置常规状态文字属性
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];

    // 设置禁用状态文字属性
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    
    return item;
}


- (void)setupTextView{
    
    UITextView *textView = [[UITextView alloc] init];
    
    textView.frame = CGRectMake(0, 0, WDScreenW, WDScreenH);
    
    textView.backgroundColor = [UIColor whiteColor];
    
    textView.text = @"ailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlaiailhialnilhaioghioahoierhnlai";
    
    [self.view addSubview:textView];
    
    self.textView = textView;
}


- (void)cancelClick{
    
    // 退出键盘
    [self.view endEditing:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)publishClick{
    
    WDLogFunc;
}

@end
