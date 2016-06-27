//
//  WDLeftTableViewCell.m
//  125 项目:百思不得姐
//
//  Created by wudi on 16/6/24.
//  Copyright © 2016年 wudi. All rights reserved.
//

#import "WDLeftTableViewCell.h"
#import "WDLeftTableViewData.h"

@interface WDLeftTableViewCell ()
/** 左侧红色选中条 */
@property (weak, nonatomic) IBOutlet UIView *redView;

@end


@implementation WDLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 设置cell的背景色透明
    self.backgroundColor = [UIColor clearColor];

    self.textLabel.font = [UIFont systemFontOfSize:15.0];
}


/** 对cell的选中状态进行配置 */
// 使用该方法时,最好将cell的selection属性设置为none,使用该方法进行选中状态配置
// 如果cell的selection属性为非none,那么当cell选中时,cell会将内部子控件全部设置为highlight状态,同时添加一个灰色的view
// 自定义的cell在创建时,该方法就已经存在,说明官方推荐使用该方法进行自定义cell的选中配置
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   
    [super setSelected:selected animated:animated];
    
//    WDLog(@"%d", selected);
    // 通过打印可以看到,该方法在cell第一次加载时会调用.并且在cell选中时,会同时调用即将选中的cell和即将取消选中的cell的该方法
    
    // 根据cell的selected状态来修改决定文本颜色和红色选中条是否显示
    self.textLabel.textColor = selected ? WDColor(218, 22, 19, 1) : [UIColor darkGrayColor];
    
    self.redView.hidden = selected ? NO : YES;
}


- (void)setData:(WDLeftTableViewData *)data{
    
    _data =data;
    
    self.textLabel.text = data.name;
}

@end
