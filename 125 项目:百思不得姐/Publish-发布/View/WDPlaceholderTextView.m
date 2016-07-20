//
//  WDPlaceholderTextView.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/17.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDPlaceholderTextView.h"
#import "WDPlaceholderLabel.h"

@implementation WDPlaceholderTextView
{
    WDPlaceholderLabel *_placeholderLabel;
}

static CGFloat const margin = 7;

- (WDPlaceholderLabel *)placeholderLabel{
    
    if (!_placeholderLabel) {
        
        WDPlaceholderLabel *label = [[WDPlaceholderLabel alloc] init];
        
        label.x = margin;
        
        label.y = margin;
        
        label.numberOfLines = 0;
        
        [self addSubview:label];
        
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}

- (void)awakeFromNib{
    
    // 让self成为观察者,监听textView的文本改变
    [self addObserverForTextChange];
    
    // 当前使用代理也可以监听textView的文本改变
    // 不过此时监听文本改变的目的是添加placeholder,这属于WDPlaceholderTextView内部的功能
    // 因此使用代理只能是self成为self的代理,一般不这么做,因为代理都是self之外的对象
    // 所以使用通知来进行文本改变的监听
    
    [self setup];
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addObserverForTextChange];
        
        [self setup];
    }
    return self;
}


/** 让self成为观察者,监听textView的文本改变 */
- (void)addObserverForTextChange{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:self];
}


/** 属性的默认设置 */
- (void)setup{
    
    // 设置textView默认状态可以垂直滚动
    self.alwaysBounceVertical = YES;
    
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    
    self.font = [UIFont systemFontOfSize:15];
    
    self.placeholderLabel.font = self.font;
}


- (void)textChange:(id)sender{
    
    self.placeholderLabel.hidden = self.hasText;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置占位label的宽度
    self.placeholderLabel.width = self.width - 2 * margin;
    
    // 让占位label的尺寸自适应
    [self.placeholderLabel sizeToFit];
}


#pragma mark - setter方法重写

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    /*
     说明
        1 在WDPlaceholderTextView类和WDPlaceholderLabel类中,同时对font属性的setter方法进行了重写
        2 目的是要保证两个类的font属性永远一致
        3 即对其中一个类的font属性进行赋值,另外一个类的该属性也跟着变化
        4 为了防止两个类同时访问setter方法而形成死循环,所以加入下面的判断
     */
    if (self.font != self.placeholderLabel.font) {
        
        self.placeholderLabel.font = self.font;
    }
}


- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    self.placeholderLabel.hidden = self.hasText;
}


- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    self.placeholderLabel.hidden = self.hasText;
}


@end
