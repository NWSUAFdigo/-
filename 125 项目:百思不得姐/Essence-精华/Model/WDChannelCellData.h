//
//  WDChannelCellData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDChannelCellData : NSObject

/** 头像 */
@property (nonatomic,copy) NSURL *profile_image;
/** 昵称 */
@property (nonatomic,copy) NSString *name;
/** 内容 */
@property (nonatomic,copy) NSString *text;
/** 创建时间 */
@property (nonatomic,copy) NSString *create_time;
/** 顶 */
@property (nonatomic,copy) NSString *ding;
/** 踩 */
@property (nonatomic,copy) NSString *cai;
/** 分享 */
@property (nonatomic,copy) NSString *repost;
/** 评论 */
@property (nonatomic,copy) NSString *comment;


// 添加属性
/** cell高度 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;
// 为了防止外界修改cellHeight的值,可以将该属性设置为readonly
// 如果设置为readonly,那么该属性只会生成getter方法
/*
 注意:OC语言对于@property属性有如下说明
    1 @property会生成setter方法\getter方法\成员变量
    2 如果同时对某一个属性重写getter和setter方法,那么系统会视该属性无效,将不再生成该属性所对于的成员变量
 
    3 所以,如果是readonly属性,并且重写了getter方法,那么系统就不会生成该属性所对于的成员变量
    4 因此需要我们手动添加该成员变量
 */

@end
