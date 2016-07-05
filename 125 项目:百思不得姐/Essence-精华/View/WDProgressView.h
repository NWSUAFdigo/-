//
//  WDProgressView.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/5.
//  Copyright © 2016年 wudi. All rights reserved.
//

/*
 说明:如何减少更换第三方框架所带来的问题?
    背景:如果某一个第三方框架不再好用,需要更换为其他第三方框架
        如本例中,如果不想使用DACircularProgress框架,那么如何操作才能减少更换框架所带来的代码修改问题?
 
    结论:如果使用的第三方框架中的自定义控件,那么最好自己添加一个控件,继承自该第三方框架中的自定义控件
    好处:很好诠释了封装思想,将属于自己的操作封装起来,这样修改起来也比较方便
 */

#import <UIKit/UIKit.h>
#import <DALabeledCircularProgressView.h>

@interface WDProgressView : DALabeledCircularProgressView

/** 图片加载进度 */
@property (nonatomic,assign) CGFloat loadProgress;

@end
