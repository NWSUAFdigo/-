//
//  WDRecommendTagCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/28.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDRecommendTagCell.h"
#import "WDRecommendTagData.h"
#import <UIImageView+WebCache.h>

@interface WDRecommendTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTagLabel;

@end


@implementation WDRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (IBAction)tagBtnClick:(id)sender {
    
    if ([WDLoginTool getUid]) {
        
        WDLog(@"自己账号订阅该频道内容");
    }else {
        
        [WDLoginTool modalLoginController];
    }
}


- (void)setData:(WDRecommendTagData *)data{
    
    _data = data;
    
    [self.iconView sd_setImageWithURL:_data.image_list placeholderImage:[[UIImage imageNamed:@"defaultUserIcon"] circleImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
        
            self.iconView.image = [image circleImage];
        }
    }];
    
    self.nameLabel.text = _data.theme_name;
    
    // 对订阅人数进行处理,如果大于1万,显示为 xx万人订阅;小于1万,显示为 xx人订阅
    NSString *string = nil;
    
    if (_data.sub_number > 10000) {
        
        string = [NSString stringWithFormat:@"%.1f万人订阅", _data.sub_number / 10000.0];
    }else {
        
        string = [NSString stringWithFormat:@"%lu人订阅", _data.sub_number];
    }
    self.subTagLabel.text = string;
}


/*
 说明:
    需求:让cell的左右两侧距离tableView一定距离,同时cell之间有间隔
 
    1 任何控件,如果想要对其frame进行彻底修改,只需要重写setFrame方法,在内部修改即可
    2 本例中,在tableView的cellForRowAtIndexPath方法中修改cell的尺寸是不好使的
 */
- (void)setFrame:(CGRect)frame{
    
    // 对frame进行修改
    CGFloat offsetX = 7;
    CGFloat offsetY = 2;
    
    frame.origin.x += offsetX;
    
    frame.size.width -= offsetX * 2;
    
    frame.size.height -= offsetY;
    // y值保持不变,其余三个位置值进行了修改
    
    [super setFrame:frame];
}

/*
 注意:
    也可以通过对cell背景颜色的修改来达到上面的需求
    cell继承自UIView,本例中通过查看WDRecommendTagCell.xib文件可以知道,在cell控件上有三层
        1 cell的背景视图
        2 contentView
        3 自行添加的UIView
    如果想要达到上面的效果,可以采取如下方法:
        1 cell的背景视图和contentView的背景颜色设为透明
        2 自行添加的UIView添加一个背景颜色,比如白色
        3 修改自行添加的UIView的约束,让其四个边距离contentView一定距离
        4 这样也能达到上面的需求
 
    两者在cell选中时是不同的
        当cell选中时,选中所添加的灰色view的尺寸和cell一致
        setFrame方法修改了cell的尺寸,而通过调整自行添加的UIView的约束并没有修改cell的尺寸
        所以两者在选中时,灰色view的大小是不一样的
 */

@end
