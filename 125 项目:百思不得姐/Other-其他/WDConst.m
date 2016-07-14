//
//  WDConst.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDConst.h"

/** 精华模块中上面频道条的高度 */
CGFloat const channelViewHeight = 35;

/** 频道cell的间隔 */
CGFloat const channelCellMargin = 10;
/** 频道cell中头像的高度 */
CGFloat const channelCellIconH = 35;
/** 频道cell中底部条的高度 */
CGFloat const channelCellBottomBarH = 40;
/** 频道cell中,图片可显示的最大高度 */
CGFloat const channelCellPictureMaxH = 1000;
/** 频道cell中,如果图片高度超过最大高度,那么将其裁剪为250点的高度 */
CGFloat const channelCellPictureClipedH = 250;

/** tabBar点击某个按钮的通知 */
NSString * const WDTabBarSelectedItemNoti = @"WDTabBarSelectedItemNoti";