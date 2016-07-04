//
//  WDSingleChannelController.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/2.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 通过枚举来指定频道的标识
typedef enum {
    WDChannelAllTypeIdentify = 1, // "全部"频道
    WDChannelPictureTypeIdentify = 10, // "图片"频道
    WDChannelWordTypeIdentify = 29, // "段子"频道
    WDChannelAudioTypeIdentify = 31, // "音频"频道
    WDChannelVideoTypeIdentify = 41, // "视频"频道
}WDChannelTypeIdentify;

@interface WDSingleChannelController : UITableViewController

/** 如果想要加载网络数据,那么在控制器的viewDidLoad方法调用之前,必须对该属性赋值 */
@property (nonatomic,assign) WDChannelTypeIdentify typeIdentify;

@end
