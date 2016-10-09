//
//  UIColor+WDCategory.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/21.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "UIColor+WDCategory.h"

@implementation UIColor (WDCategory)

-(UIColor *)wd_colorWithKey:(NSString *)key{
    
    // 从沙盒中取出当前主题
    NSString *theme = [[NSUserDefaults standardUserDefaults] stringForKey:@"theme"];
    
    // 加载当前主题所对应的plist
    NSString *filePath = [NSString stringWithFormat:@"skins/%@/color.plist", theme];
    
    // 获取全路径
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:nil];
    
    // 加载plist
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // 取出当前key对应的颜色
    NSString *colorStr = dict[key];
    
    // 对颜色字符串进行处理
    NSArray *colorArray = [colorStr componentsSeparatedByString:@","];
    
    return [UIColor colorWithRed:[colorArray[0] integerValue] green:[colorArray[1] integerValue] blue:[colorArray[2] integerValue] alpha:1];
}

@end
