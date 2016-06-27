//
//  WDRightTableViewCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/27.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRightTableViewCell.h"
#import "WDRightTableViewData.h"

#import <UIImageView+WebCache.h>

@interface WDRightTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end


@implementation WDRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setData:(WDRightTableViewData *)data{
    
    _data = data;
    
    self.nameLabel.text = _data.screen_name;
    
    self.fansCountLabel.text = [NSString stringWithFormat:@"%lu人已关注", _data.fans_count];
    
    [self.iconView sd_setImageWithURL:_data.header placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}


- (IBAction)followBtnClick:(id)sender {
    WDLogFunc;
}

@end
