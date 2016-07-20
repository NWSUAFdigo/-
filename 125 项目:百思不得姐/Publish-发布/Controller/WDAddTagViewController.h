//
//  WDAddTagViewController.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/18.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDAddTagViewController : UIViewController

@property (nonatomic,copy) void(^completeBlock)();
/** 从WDBottomBar中传递的标签文本数组 */
@property (nonatomic,weak) NSMutableArray *tagsStrArray;

@end
