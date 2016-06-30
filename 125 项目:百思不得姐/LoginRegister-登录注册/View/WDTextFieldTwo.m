//
//  WDTextFieldTwo.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/29.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDTextFieldTwo.h"
#import <objc/runtime.h>

@implementation WDTextFieldTwo

- (void)awakeFromNib{
    
    // 使用Runtime获得UITextField的成员变量列表
    [self getIvarsUsingRuntime];
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self getIvarsUsingRuntime];
    }
    return self;
}


/** 使用Runtime获得UITextField的成员变量列表 */
- (void)getIvarsUsingRuntime{
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    // 遍历ivars数组,取出每一个成员变量并打印其属性名
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = *(ivars + i);
        
        WDLog(@"%s", ivar_getName(ivar));
    }
    
    // 通过打印UITextField的属性列表,可以查找到一个名为_placeholderLabel的属性
    // 说明在UITextField内部,占位文字是通过一个UILabel来设置的
    
    // 运行时机制使用完成后,需要手动将数组释放
    free(ivars);
    
    // runtime不仅可以获得成员变量,还可以获得方法\属性等信息
    // copy方法列表
    // class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>);
    // copy属性列表
    // class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>);
    // copy协议列表
    // class_copyProtocolList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>);
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    
    // 使用KVC来设置占位文字的颜色
    [self setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    // 注意:下面的方法只能设置self里面的属性的值,不能设置self里面属性的属性值
//    [self setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>]
}


// 通过重写becomeFirstResponder来设置占位文字在textField弹出键盘时的颜色
- (BOOL)becomeFirstResponder{
    
    [self setValue:self.placeholderHighlightedColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return [super becomeFirstResponder];
}


// 通过重写resignFirstResponder来设置占位文字在键盘关闭时的颜色
- (BOOL)resignFirstResponder{
    
    [self setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return [super resignFirstResponder];
}


// 设置光标颜色
- (void)setCursorColor:(UIColor *)cursorColor{
    
    _cursorColor = cursorColor;
    
    self.tintColor = _cursorColor;
}

@end
