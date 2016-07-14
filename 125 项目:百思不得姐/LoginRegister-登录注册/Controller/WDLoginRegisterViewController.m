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
@property (weak, nonatomic) IBOutlet WDTextField *pwdField;
@property (weak, nonatomic) IBOutlet WDTextField *registerPhoneField;
@property (weak, nonatomic) IBOutlet WDTextField *registerPwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *loginView;

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

    // 设置textField的holder,使用默认样式
    [self setUpHolderUsingDefaultColor:self.phoneField];
    [self setUpHolderUsingDefaultColor:self.pwdField];
    [self setUpHolderUsingDefaultColor:self.registerPhoneField];
    [self setUpHolderUsingDefaultColor:self.registerPwdField];
}


// 设置textField的holder,使用默认样式
- (void)setUpHolderUsingDefaultColor:(WDTextField *)textField{
    
    textField.placeholderColor = [UIColor grayColor];
    // 设置textField弹出键盘时,占位文字的颜色
    textField.placeholderHighlightedColor = [UIColor lightGrayColor];
    // 设置textField光标的颜色
    textField.cursorColor = self.phoneField.placeholderHighlightedColor;
    // 设置textField输入的文字颜色
    textField.textColor = self.phoneField.placeholderHighlightedColor;
}


// 修改状态栏样式:从iOS7之后,状态栏的样式由控制器来设置
// 如果屏幕上除了主窗口外还有其他窗口,如本例中在状态栏位置添加了一个UIWindow,那么通过下面方法设置状态栏颜色是不好使的
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
/*
 状态栏颜色设置的两种方式:
    1 通过控制器的preferredStatusBarStyle方法进行设置 (iOS7之后推出,默认做法)
    2 通过[UIApplication sharedApplication].statusBarStyle来设置 (iOS7之前的做法)
 
    默认采取方式1来设置状态栏颜色
    默认情况下,采取方式2是无法设置状态栏颜色的
    如果想让方式2设置状态栏有效,需要在info.plist文件中,添加View controller-based status bar appearance key值,并将其设置为NO
    表示状态栏不由控制器来控制,那么就由UIApplication来控制
 
 本例中,如果想让登录页面的状态栏显示为白色,有如下两种解决方法:
    1 通过UIApplication来控制状态栏,在进入WDLoginRegisterViewController时设置状态栏为白色,在退出该控制器时设置为黑色
    2 通过默认的方式1来控制状态栏,在进入WDLoginRegisterViewController时将添加的UIWindow隐藏,在退出控制器时将该UIWindow显示
 
    本例采取第一种解决方法
        在viewDidAppear方法中设置状态栏为白色
        在返回按钮点击方法closeClick中设置状态栏为黑色
 */
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (IBAction)loginRegisterClick:(UIButton *)sender {
    
    // 每次点击按钮,都需要将键盘隐藏
     [self.view endEditing:YES];
    
    // 通过判断sender是否处于selected状态来决定显示登陆View还是注册View
    // 在xib中设置按钮selected状态下的文字内容,达到选中和非选中状态的内容不同
    if (sender.selected == NO) {
        
        // 修改登录View的约束
        self.loginViewLeadingConstraint.constant = - self.view.width;
        self.loginViewTrailingConstraint.constant = - self.view.width;
        
        // 将sender设置selected
        sender.selected = YES;
    } else {
        
        // 修改登录View的约束
        self.loginViewLeadingConstraint.constant = 0;
        self.loginViewTrailingConstraint.constant = 0;
        
        // 将sender设置selected
        sender.selected = NO;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        [self.view layoutIfNeeded];
        
        // 通过修改transform也可以达到移动的效果
//        self.loginView.transform = CGAffineTransformMakeTranslation(- self.view.width, 0);
    }];
}


// 点击关闭按钮,退出登录\注册界面
- (IBAction)closeClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
@end
