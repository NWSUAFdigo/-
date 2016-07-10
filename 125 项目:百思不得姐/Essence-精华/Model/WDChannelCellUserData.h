//
//  WDChannelCellUserData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/9.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDChannelCellUserData : NSObject

/** 是否为会员 */
@property (nonatomic,assign) BOOL is_vip;
/** 用户头像URL */
@property (nonatomic,strong) NSURL *profile_image;
/** 用户性别 */
@property (nonatomic,copy) NSString *sex;
/** 昵称 */
@property (nonatomic,copy) NSString *username;
/** 语音时长 */
@property (nonatomic,assign) NSInteger voicetime;
/** 语音URL */
@property (nonatomic,strong) NSURL *voiceuri;

@end
