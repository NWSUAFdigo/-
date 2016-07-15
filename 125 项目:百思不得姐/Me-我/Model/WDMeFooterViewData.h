//
//  WDMeFooterViewData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/15.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMeFooterViewData : NSObject

/** 图片URL */
@property (nonatomic,strong) NSURL *icon;
/** 名称 */
@property (nonatomic,copy) NSString *name;
/** 跳转url */
@property (nonatomic,strong) NSURL *url;

@end
