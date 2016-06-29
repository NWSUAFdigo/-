//
//  WDLoginRegisterViewController.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDLoginRegisterViewController.h"
#import "WDTextField.h"
#import "WDTextFieldTwo.h"

@interface WDLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet WDTextField *phoneField;
@property (weak, nonatomic) IBOutlet WDTextFieldTwo *pwdField;

@end


@implementation WDLoginRegisterViewController

// 点击屏幕退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 登录按钮变为圆角
    [self setUpLoginBtn];

    // 设置textField的占位文字(颜色\字体\大小)
//    [self setUpTextFieldHolder];
    
    // 设置占位文字颜色
    [self setUpTextField];
}


- (void)setUpLoginBtn{
    // 项目中提供的登录图片是一个矩形图片,如何让登录按钮的背景图片变为圆角?
    // 可以通过设置登录按钮的layer来达到圆角效果
    /*
     步骤:
     1 通过拖线在WDLoginRegisterViewController控制器中拿到登录按钮
     2 对按钮的layer进行如下设置:
     btn.layer.cornerRadius = 5;
     btn.layer.masksToBounds = YES;
     3 第一句代码让按钮图层变为圆角
     4 第二句代码让按钮内部图层依据按钮图层进行裁切
     */
    // 同样,可以在xib或者storyboard中通过KVC的方式来设置控件(本例使用的就是xib中的KVC来设置控件)
    // 在xib或者storyboard中点击需要设置的控件,点击右上角的六个按钮的第三个
    // 在User Defined Runtime Attributes中就可以通过KVC来设置控件的属性
}


- (void)setUpTextFieldHolder{
    
    // 在UITextField类中搜索holder,可以看到,在placeholder属性下面有一个attributedPlaceholder属性
    // 通过attributedPlaceholder属性就可以对占位文字进行一些设置.该属性是NSAttributedString类型的对象
    
    NSAttributedString *holder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    // 通过传入一个字符串和一个属性字典来创建一个NSAttributedString对象
    // 也可以使用NSMutableAttributedString类来对字符串进行更多设置(如设置单个文字的大小\颜色\字体等)
    
    self.phoneField.attributedPlaceholder = holder;
    
}


// 设置textField的占位文字颜色\光标等属性
- (void)setUpTextField{
    
    self.phoneField.placeholderColor = [UIColor grayColor];
    // 设置textField弹出键盘时,占位文字的颜色
    self.phoneField.placeholderHighlightedColor = [UIColor lightGrayColor];
    // 设置textField光标的颜色
    self.phoneField.cursorColor = self.phoneField.placeholderHighlightedColor;
    // 设置textField输入的文字颜色
    self.phoneField.textColor = self.phoneField.placeholderHighlightedColor;
    
    
    self.pwdField.placeholderColor = [UIColor grayColor];
    self.pwdField.placeholderHighlightedColor = [UIColor lightGrayColor];
    self.pwdField.cursorColor = self.pwdField.placeholderHighlightedColor;
    self.pwdField.textColor = self.pwdField.placeholderHighlightedColor;
}


// 修改状态栏样式:从iOS7之后,状态栏的样式由控制器来设置
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
