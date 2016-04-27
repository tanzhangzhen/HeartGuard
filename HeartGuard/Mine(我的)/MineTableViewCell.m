//
//  MineTableViewCell.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/19.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "MineTableViewCell.h"
#import "Masonry.h"

@implementation MineTableViewCell

//自定义View类初始化设置按钮
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //1.左部图片
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];//添加到视图view中
        self.iconView = iconView;//该属性需要跨类调用，所以应该设置成全局的
        
        //2.中部文字label
        UILabel *titleView = [[UILabel alloc] init];//新建对象
        titleView.font = [UIFont systemFontOfSize:15];//设置字体大小
        [self.contentView addSubview:titleView];//添加到视图view中
        self.titleView = titleView;//该属性需要跨类调用，所以应该设置成全局的
        
        //图片位置
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        //文字位置
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

//继承自QuestionModel的question类
//-(void)setMine:(MineModel *)mine{
//    _mine = mine;
//    //设置图片
//    self.iconView.image = [UIImage imageNamed:mine.image];
//    //设置文字
//    self.titleView.text = mine.text;//设置topLabel文字
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
