//
//  WDChannelCell.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDChannelCellData;
@interface WDChannelCell : UITableViewCell

@property (nonatomic,strong) WDChannelCellData *data;
/** 热评视图是否隐藏 */
@property (nonatomic,assign,getter=hotCmtViewIsHidden) BOOL hotCmtViewHidden;

@end
