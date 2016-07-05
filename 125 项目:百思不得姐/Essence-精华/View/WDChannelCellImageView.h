//
//  WDChannelCellImageView.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/5.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDChannelCellData;
@interface WDChannelCellImageView : UIView

@property (nonatomic,strong) WDChannelCellData *data;

+ (instancetype)channelCellImageView;
- (instancetype)init;

@end
