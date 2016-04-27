//
//  ResultTableViewCell.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/17.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "masonry.h"

@implementation ResultTableViewCell

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//        UIImageView *leftImageView = [[UIImageView alloc]init];
//        [self.contentView addSubview:leftImageView];
//        self.leftImageView = leftImageView;
//        
//        UILabel *nameLabel = [[UILabel alloc]init];
//        [self.contentView addSubview:nameLabel];
//        self.nameLabel = nameLabel;
//        
//        UILabel *scored = [[UILabel alloc]init];
//        scored.text = @"得分";
//        scored.font = [UIFont systemFontOfSize:17];
//        [self.contentView addSubview:scored];
//        
//        UILabel *scoreLabel = [[UILabel alloc]init];
//        scoreLabel.font = [UIFont systemFontOfSize:17];
//        [self.contentView addSubview:scoreLabel];
//        self.scoreLabel = scoreLabel;
//        
//        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(10);
//            make.top.equalTo(self).offset(10);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//        }];
//        
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(leftImageView.mas_right).offset(10);
//            make.top.equalTo(leftImageView).offset(5);
//        }];
//        [scored mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-50);
//            make.top.equalTo(nameLabel);
//        }];
//        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(scored.mas_right).offset(5);
//            make.top.equalTo(scored);
//        }];
//        
//    }
//    return self;
//}
//
-(void)setResult:(ResultModel *)result{
    _result = result;
    self.headImageView.image = [UIImage imageNamed:result.nick];
    self.nameLabelView.text = result.nick;
    self.timeLabelView.text = result.time;
    self.scoreLabelView.text = result.rate_average;
    self.numLabelView.text = result.rate_average;
    self.healthLabelView.text = result.symptoms_rhythm;
    self.symptomLabelView.text = result.symptoms_heart;
    //测试传值用
    //self.leftImageView.image = [UIImage imageNamed:@"bg_family"];
    //self.nameLabel.text =@"nihao";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
