//
//  WDFootButtonViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDFootButtonViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

@interface WDFootButtonViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForward;

@property (nonatomic,strong) NJKWebViewProgress *progress;
/** 进度条 */
@property (weak, nonatomic) IBOutlet NJKWebViewProgressView *progressView;

@end

@implementation WDFootButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用第三方框架NJKWebViewProgress在导航栏底部创建一个加载进度条
    self.progress = [[NJKWebViewProgress alloc] init];
    // 注意:NJKWebViewProgress必须不能声明为一个局部变量,最好用属性或者全局变量
    
    self.webView.delegate = self.progress;
    
    self.progress.webViewProxyDelegate = self;
    
    self.progress.progressDelegate = self;
    
    // webView加载请求的代码需要放在NJKWebViewProgress创建并指定代理的后面
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    self.goForward.enabled = NO;
    self.goBack.enabled = NO;
    
    // storyboard创建一个view用来显示进度
    self.progressView.backgroundColor = [UIColor clearColor];
    
    // 设置进度条的颜色为红色
    self.progressView.progressBarView.backgroundColor = [UIColor redColor];
}


- (IBAction)goBack:(id)sender {
    
    [self.webView goBack];
}


- (IBAction)goForward:(id)sender {
    
    [self.webView goForward];
}


- (IBAction)refresh:(id)sender {
    
    [self.webView reload];
}


#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.goBack.enabled = webView.canGoBack;
    self.goForward.enabled = webView.canGoForward;
}


#pragma mark - <NJKWebViewProgressDelegate>
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    
    [self.progressView setProgress:progress animated:YES];
}


@end
