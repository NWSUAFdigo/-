//
//  WDAddTagViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDAddTagViewController.h"
#import "WDCornerRoundedButton.h"
#import "WDTagButton.h"
#import "WDAddTagTextField.h"

#import <SVProgressHUD.h>

@interface WDAddTagViewController ()<UITextFieldDelegate>

/** 内容视图 */
@property (nonatomic,weak) UIView *contentView;
/** textField */
@property (nonatomic,weak) WDAddTagTextField *textField;
/** 输入提示按钮 */
@property (nonatomic,weak) WDCornerRoundedButton *tipsBtn;
/** tag按钮数组 */
@property (nonatomic,strong) NSMutableArray *tagsBtnArray;

@end


@implementation WDAddTagViewController

#pragma mark - 懒加载控件
- (UIView *)contentView{
    
    if (!_contentView){
        
        UIView *contentView = [[UIView alloc] init];
        
        contentView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:contentView];
        
        _contentView = contentView;
    }
    return _contentView;
}


- (WDAddTagTextField *)textField{
    
    if (!_textField){
        
        WDAddTagTextField *textField = [[WDAddTagTextField alloc] init];
        
        textField.placeholder = @"使用逗号或者确定添加标签";
        
//        textField.backgroundColor = [UIColor redColor];
        
        textField.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:textField];
        
        [textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
        
        textField.delegate = self;
        
        // 设置点击键盘删除按钮后,textField需要进行的操作
        // 为了防止循环引用,在block中使用weakSelf
        __weak typeof(self) weakSelf = self;
        
        textField.deleteBlock = ^{
            
            if (weakSelf.textField.hasText || (weakSelf.tagsBtnArray.count == 0)) return;
            
            // 来到这里说明textField没有text,并且标签数组有元素
            [self tagBtnClick:[weakSelf.tagsBtnArray lastObject]];
        };
        
        _textField = textField;
    }
    return _textField;
}


- (WDCornerRoundedButton *)tipsBtn{
    
    if (!_tipsBtn){
        
        WDCornerRoundedButton *btn = [WDCornerRoundedButton buttonWithType:UIButtonTypeCustom];
        

        
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, channelCellMargin, 0, 0);
        
        [self.contentView addSubview:btn];
        
        [btn addTarget:self action:@selector(addTagClick) forControlEvents:UIControlEventTouchUpInside];
        
        _tipsBtn = btn;
    }
    return _tipsBtn;
}


- (NSMutableArray *)tagsBtnArray{
    
    if (!_tagsBtnArray){
        
        _tagsBtnArray = [NSMutableArray array];
    }
    return _tagsBtnArray;
}


#pragma mark - 控件监听
/** textField文字内容发生改变 */
- (IBAction)textChange{
    
    [self setupFrameOfTextFieldAndTipsBtn];
    
    // 判断输入的内容中是否有,逗号
    // 判断textField是否包含,逗号
    BOOL hasComma = [self.textField.text containsString:@","] || [self.textField.text containsString:@"，"];
    
    if (hasComma && (self.textField.text.length == 1)) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"标签内容不能为空"];
        
        self.textField.text = nil;
        self.tipsBtn.hidden = YES;
    }else if (hasComma && (self.textField.text.length != 1)) {
        
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
        [self addTagClick];
    }
}


/** 输入提示按钮点击监听 */
- (IBAction)addTagClick{
    
    if (self.tagsBtnArray.count == 5) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
        
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        
        return;
    }
    
    WDTagButton * tagBtn = [WDTagButton buttonWithType:UIButtonTypeCustom];
    
    [tagBtn setTitle:self.textField.text forState:UIControlStateNormal];
    
    [tagBtn setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    
    tagBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [tagBtn sizeToFit];
    
    [self.contentView addSubview:tagBtn];
    
    [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 将tag按钮添加到按钮数组中
    [self.tagsBtnArray addObject:tagBtn];

    // 将textField清空
    self.textField.text = nil;
    
    // 重新布局所有子控件的frame
    [self setupFrameOfTagsArray];
    [self setupFrameOfTextFieldAndTipsBtn];
}


/** 标签按钮点击监听 */
- (IBAction)tagBtnClick:(WDTagButton *)button{
    
    // 将点击的按钮从父控件和数组中移除
    [button removeFromSuperview];
    
    [self.tagsBtnArray removeObject:button];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        // 重新布局所有子控件的frame
        [self setupFrameOfTagsArray];
        [self setupFrameOfTextFieldAndTipsBtn];
    }];
}


#pragma mark - 控件frame设置
/** 重新布局按钮数组的frame */
- (void)setupFrameOfTagsArray{
    
    for (NSInteger i = 0; i < self.tagsBtnArray.count; i++) {
        
        WDTagButton *tagBtn = self.tagsBtnArray[i];
        
        if (i == 0) {
            
            tagBtn.x = 0;
            tagBtn.y = 0;
        }else {
            
            // 取出上一个tag按钮
            WDTagButton *lastTagBtn = self.tagsBtnArray[i - 1];
            
            // 判断上一个tag按钮所在行的剩余宽度是否能够显示这个tag按钮
            CGFloat remainingW = self.contentView.width - CGRectGetMaxX(lastTagBtn.frame) - channelCellMargin;
            
            if (remainingW >= tagBtn.width) {
                
                tagBtn.x = CGRectGetMaxX(lastTagBtn.frame) + channelCellMargin;
                tagBtn.y = lastTagBtn.y;
            } else {
                
                tagBtn.x = 0;
                tagBtn.y = CGRectGetMaxY(lastTagBtn.frame) + channelCellMargin;
            }
        }
    }
}


/** textField\提示按钮的frame */
- (void)setupFrameOfTextFieldAndTipsBtn{
    
    // 设置textField的位置
    if (self.tagsBtnArray.count) {
        
        self.textField.placeholder = nil;
    } else {
        
        self.textField.placeholder = @"使用逗号或者确定添加标签";
    }
    
    WDTagButton *lastBtn = [self.tagsBtnArray lastObject];
    
    CGFloat remainingW = self.contentView.width - CGRectGetMaxX(lastBtn.frame) - channelCellMargin;
    
    if (remainingW > [self textFieldTextWidth]) {
        
        self.textField.x = CGRectGetMaxX(lastBtn.frame) + channelCellMargin;
        self.textField.y = lastBtn.y;
    } else {
        
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastBtn.frame) + channelCellMargin;
    }
    
    // 设置提示按钮的位置
    if (self.textField.hasText) {
        
        self.tipsBtn.y = CGRectGetMaxY(self.textField.frame) + channelCellMargin * 0.5;
        
        [self.tipsBtn setTitle:[NSString stringWithFormat:@"添加标签:%@", self.textField.text] forState:UIControlStateNormal];
        
        self.tipsBtn.hidden = NO;
    }else {
        
        self.tipsBtn.hidden = YES;
    }
}


/** textField文字的宽度 */
- (CGFloat)textFieldTextWidth{
    
    CGSize textSize = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}];
    
    // 当文字宽度小于20时,返回20作为宽度
    return MAX(20, textSize.width);
}


#pragma mark - 视图处理及导航栏设置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏
    [self setupNaviBar];
    
    // 将控件加载
    [self contentView];
    [self textField];
    
    // 对按钮数组进行设置
    [self setupTagsBtnArray];
}


- (void)setupTagsBtnArray{
    
    for (NSString *tagStr in self.tagsStrArray) {
        
        // 模拟输入文字并添加标签
        self.textField.text = tagStr;
        
        [self addTagClick];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}


/*
 说明:
 1 对于自定义控件的布局(不管是xib创建还是代码创建),尽量放到layoutSubviews方法中
 2 对于控制器根视图的布局(不管是xib创建还是代码创建),尽量放到viewDidLayoutSubviews方法中
 */
// 注意:该方法在运行过程中会多次调用,因此使用时要格外注意
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    // 设置contentView的尺寸
    self.contentView.frame = CGRectMake(channelCellMargin, 64 + channelCellMargin, WDScreenW - 2 * channelCellMargin, WDScreenH - 2 * channelCellMargin - 64);
    
    // 设置textField的尺寸
    self.textField.frame = CGRectMake(channelCellMargin, 0, self.contentView.width - 2 * channelCellMargin, 30);
    
    // 设置tipsBtn的尺寸
    self.tipsBtn.size = CGSizeMake(self.contentView.width, 25);
    
    self.tipsBtn.x = 0;
    
    [self setupFrameOfTagsArray];
    [self setupFrameOfTextFieldAndTipsBtn];
}


- (void)setupNaviBar{
    
    self.title = @"添加标签";
    
    self.navigationItem.leftBarButtonItem = [self barButtonItemWithTitle:@"取消" target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithTitle:@"完成" target:self action:@selector(publishClick)];
}


/** 设置导航栏两侧按钮 */
- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    
    // 设置常规状态文字属性
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
    return item;
}


- (void)cancelClick{
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)publishClick{
    
    // 将按钮文本数组清空
    [self.tagsStrArray removeAllObjects];
    
    // 给按钮文本数组添加元素
    for (UIButton *tagBtn in self.tagsBtnArray) {
        
        NSString *tagStr = tagBtn.titleLabel.text;
        
        [self.tagsStrArray addObject:tagStr];
    }
    
    // 调用block
    !self.completeBlock ? : self.completeBlock();
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.view endEditing:YES];
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.textField.hasText) {
        
        [self addTagClick];
    }else {
        
        [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"标签内容不能为空"];
    }
    
    
    return YES;
}


@end
