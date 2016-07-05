//
//  WDSingleChannelController.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/2.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDSingleChannelController : UITableViewController

/** 如果想要加载网络数据,那么在控制器的viewDidLoad方法调用之前,必须对该属性赋值 */
@property (nonatomic,assign) WDChannelTypeIdentify typeIdentify;

@end
