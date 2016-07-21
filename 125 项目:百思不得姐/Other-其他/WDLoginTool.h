//
//  WDLoginTool.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/21.
//  Copyright © 2016年 wudi. All rights reserved.
//

// 登录工具类,当点击某个内容需要登录才能操作时,使用该类的方法就可以进行相关操作
// 用户登录时,后台需要进行的操作
/*
 1 用户点击登录后,将用户的密码进行加密,然后将账号和密码发送给服务器
 2 登录成功后,服务器会返回一个uid值(也可能是token值),也就是用户的唯一标示
 3 将服务器返回的uid值存到沙盒中
 
 4 当用户点击某些需要登录才能进行的操作时,首先去沙盒中查看是否有uid值
 5 如果没有,弹出登录界面
 6 如果有,执行相应的操作
 
 7 如果用户退出账号时,将沙盒中的uid值删除
 
 uid值:一般作为一个请求参数发送给服务器,得到对应用户的某些信息并进行操作
 */

#import <Foundation/Foundation.h>

@interface WDLoginTool : NSObject

/** 将uid存入沙盒 */
+ (void)setUid:(NSString *)uid;
/** 获取沙盒中的uid值 */
+ (NSString *)getUid;
/** 弹出登录控制器 */
+ (void)modalLoginController;

@end
