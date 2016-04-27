//
//  MineTableViewCell.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/19.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *iconView;
//@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property(nonatomic,strong)UILabel *titleView;
@property(nonatomic,strong)UIImageView *iconView;

@property(nonatomic,strong)MineModel *mine;

@end
