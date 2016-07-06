//
//  WDChannelCellData.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>

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
/** 返回的数据类型,用枚举来表示 */
@property (nonatomic,assign) WDChannelTypeIdentify type;

// 注意:由于服务器返回的参数名称为image0\image1\image2,所以需要指定属性名所对应的服务器参数名
/** cell中图片--小图 */
@property (nonatomic,strong) NSURL *smallImage;
/** cell中图片--中图 */
@property (nonatomic,strong) NSURL *middleImage;
/** cell中图片--大图 */
@property (nonatomic,strong) NSURL *bigImage;
/** cell中图片的高度 */
@property (nonatomic,assign) CGFloat height;
/** cell中图片宽度 */
@property (nonatomic,assign) CGFloat width;
/** 是否是GIF图片 */
@property (nonatomic,assign) BOOL is_gif;


// 添加属性
/** cell高度 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;
// CGFloat类型属于CoreGraphics/CoreGraphics.h框架中的变量类型,如果想要使用该类型必须包含CoreGraphics/CoreGraphics.h框架
// 由于在pch文件中包含了某些文件的.h文件,而这些.h文件包含了UIKit框架,UIKit框架已经包含了CoreGraphics/CoreGraphics.h框架,所以本例总可以在本文件中直接使用CGFloat类型
// 为了防止外界修改cellHeight的值,可以将该属性设置为readonly
// 如果设置为readonly,那么该属性只会生成getter方法
/*
 注意:OC语言对于@property属性有如下说明
    1 @property会生成setter方法\getter方法\成员变量
    2 如果同时对某一个属性重写getter和setter方法,那么系统会视该属性无效,将不再生成该属性所对于的成员变量
 
    3 所以,如果是readonly属性,并且重写了getter方法,那么系统就不会生成该属性所对于的成员变量
    4 因此需要我们手动添加该成员变量
 */

/** 图片的frame */
@property (nonatomic,assign) CGRect imageFrame;
/** 图片是否被裁切 */
@property (nonatomic,assign,getter=isCliped) BOOL cliped;
/** 当前图片的下载进度 */
@property (nonatomic,assign) CGFloat progress;

@end
