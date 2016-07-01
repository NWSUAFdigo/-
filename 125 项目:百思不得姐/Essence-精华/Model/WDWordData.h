//
//  WDWordData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDWordData : NSObject

/** 头像 */
@property (nonatomic,copy) NSURL *profile_image;
/** 昵称 */
@property (nonatomic,copy) NSString *name;
/** 内容 */
@property (nonatomic,copy) NSString *text;

@end
