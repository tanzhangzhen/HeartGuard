//
//  ResultTableViewCell.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/17.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultModel.h"

@interface ResultTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (strong, nonatomic) IBOutlet UILabel *nameLabelView;//名字
@property (strong, nonatomic) IBOutlet UILabel *scoreLabelView;//分值
@property (strong, nonatomic) IBOutlet UILabel *timeLabelView;//时间
@property (strong, nonatomic) IBOutlet UILabel *numLabelView;//平均心率
@property (strong, nonatomic) IBOutlet UILabel *healthLabelView;//心率病症
@property (strong, nonatomic) IBOutlet UILabel *symptomLabelView;//心房病症

@property (strong, nonatomic) ResultModel *result;

@end
