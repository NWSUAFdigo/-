//
//  WDLoginTool.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/21.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDLoginTool.h"
#import "WDLoginRegisterViewController.h"

@implementation WDLoginTool

static NSString * const WDUid = @"uid";

+ (void)setUid:(NSString *)uid{
    
    return [[NSUserDefaults standardUserDefaults] setObject:uid forKey:WDUid];
}


+ (NSString *)getUid{
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:WDUid];
}


+ (void)modalLoginController{
    
    WDLoginRegisterViewController *loginVC = [[WDLoginRegisterViewController alloc] init];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
}

@end
