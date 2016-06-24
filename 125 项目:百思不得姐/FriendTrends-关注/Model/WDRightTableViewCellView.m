//
//  WDRightTableViewCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRightTableViewCellView.h"

@interface WDRightTableViewCellView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end


@implementation WDRightTableViewCellView

- (instancetype)init{
    
    if (self = [super init]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"WDRightTableViewCellView" owner:nil options:nil] lastObject];
    }
    return self;
}


+ (instancetype)rightTableViewCellView{
    
    return [[self alloc] init];
}


- (void)setFansCount:(NSInteger)fansCount{
    
    _fansCount = fansCount;
    
    self.fansCountLabel.text = [NSString stringWithFormat:@"%lu人已关注", _fansCount];
}


- (void)setScreenName:(NSString *)screenName{
    
    _screenName = screenName;
    
    self.nameLabel.text = _screenName;
}


- (IBAction)followBtnClick:(id)sender {
    WDLogFunc;
}

@end
