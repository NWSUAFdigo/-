//
//  WDRightTableViewCell.h
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDRightTableViewCellView : UIView

- (instancetype)init;
+ (instancetype)rightTableViewCellView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic,assign) NSInteger fansCount;
@property (nonatomic,copy) NSString *screenName;

@end
