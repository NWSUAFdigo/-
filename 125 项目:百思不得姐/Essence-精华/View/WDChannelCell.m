//
//  WDChannelCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/7/1.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDChannelCell.h"
#import "WDChannelCellData.h"
#import <UIImageView+WebCache.h>

@interface WDChannelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;


@end


@implementation WDChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 添加一个背景
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFrame:(CGRect)frame{
    
    static CGFloat margin = 10;
    
    frame.origin.x += margin;
    frame.origin.y += margin;
    frame.size.width -= margin * 2;
    frame.size.height -= margin;
    
    [super setFrame:frame];
}


- (void)setData:(WDChannelCellData *)data{
    
    _data = data;
    
    [self.iconView sd_setImageWithURL:data.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.nameLabel.text = data.name;
    
    // 在create_time的getter方法中对时间进行处理
    self.timeLabel.text = data.create_time;
    
    self.contentTextLabel.text = data.text;
    
    // 设置下方小按钮的文字
    // 1 如果按钮的数字超过10000,以 1万 表示
    // 2 如果按钮的数字为0 ,则显示当前按钮的功能,如"顶"\"踩"\"转发"
    [self setButton:self.dingBtn countString:data.ding holder:@"顶"];
    [self setButton:self.caiBtn countString:data.cai holder:@"踩"];
    [self setButton:self.repostBtn countString:data.repost holder:@"转发"];
    [self setButton:self.commentBtn countString:data.comment holder:@"评论"];
}


- (void)setButton:(UIButton *)btn countString:(NSString *)countStr holder:(NSString *)holder{
    
    NSInteger count = countStr.integerValue;
    
    if (count == 0) {
        
        [btn setTitle:holder forState:UIControlStateNormal];
    }else if (count > 10000){
        
        NSString *title = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        
        [btn setTitle:title forState:UIControlStateNormal];
    }else {
        
        [btn setTitle:countStr forState:UIControlStateNormal];
    }
}


/** 学习:如何获得时间间隔 */
- (void)learnHowToGetTimeInterval:(NSString *)dataStr{
    
    // 如何将一个字符串时间转换为NSDate?
    // 首先需要得到字符串时间的显示格式 --> NSDataFormatter
    // 打印字符串
//    WDLog(@"%@", dataStr);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // 根据一个时间格式将字符串时间转换为NSDate
    // NSDate的时间都是以0时区的时间显示,所以东八区的时间(北京时间)会减去8个小时进行显示
    NSDate *creatDate = [formatter dateFromString:dataStr];
    WDLog(@"%@", creatDate);
    
    // 获取时间间隔
    [self getTimeIntervalFromNowWithDate:creatDate];
}


/** 获取给定时间到当前时间的时间间隔 */
- (void)getTimeIntervalFromNowWithDate:(NSDate *)date{
 
    // 使用以下方法获取时间
    // NSCalender类:
    // - (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts;
    /*
     参数说明:
        1 unitFlags:需要获取哪些时间间隔? 间隔多少年\间隔多少月...
        2 startingDate:起始时间
        3 resultDate:结束时间
        4 opts:该参数传0即可
     
     NSDateComponents:时间模块
        该类可以将一个时间分成需要模块,如年模块\月模块
     */
    
    // 创建一个NSCalender对象
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 获取一个时间的单个模块:如下面方法中获得 日模块
//    NSInteger day = [calender component:NSCalendarUnitDay fromDate:date];
    
    // 获取多个时间模块:如本例中获得一个时间的 年\月\日
//    NSDateComponents *comps = [calender components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//    WDLog(@"%@", comps);
    
    
    // 获取时间间隔
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    
    // 获取给定时间和当前时间的间隔
    NSDateComponents *components = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:nowDate options:0];
    WDLog(@"%@", components);
}


@end
