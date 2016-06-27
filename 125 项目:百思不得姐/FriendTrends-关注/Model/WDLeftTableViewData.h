//
//  WDLeftTableViewData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDRightTableViewData;

@interface WDLeftTableViewData : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,assign) NSInteger count;

// 给左侧表格模型添加一个属性,用来记录左侧表格中某个cell所对应的右侧数据
@property (nonatomic,strong) NSMutableArray<WDRightTableViewData *> *rightTableViewData;
// 记录右边表格总共有多少数据
@property (nonatomic,assign) NSInteger total;
// 记录当前页面
@property (nonatomic,assign) NSInteger currentPage;

@end
