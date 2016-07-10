//
//  WDChannelCellTopcmtData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/9.
//  Copyright © 2016年 wudi. All rights reserved.
//  热门评论模型

#import <Foundation/Foundation.h>

@class WDChannelCellUserData;
@interface WDChannelCellTopcmtData : NSObject

/** 评论内容 */
@property (nonatomic,copy) NSString *content;
/** 点赞数 */
@property (nonatomic,assign) NSInteger like_count;
/** 用户数据 */
@property (nonatomic,strong) WDChannelCellUserData *user;

@end
