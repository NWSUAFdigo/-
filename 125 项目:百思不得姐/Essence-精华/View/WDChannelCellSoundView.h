//
//  WDChannelCellSoundView.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/9.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDChannelCellData;
@interface WDChannelCellSoundView : UIView

+ (instancetype)channelCellSoundView;
@property (nonatomic,strong) WDChannelCellData *data;

@end
