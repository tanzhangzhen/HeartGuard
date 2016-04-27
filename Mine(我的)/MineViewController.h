//
//  MineViewController.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/19.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineViewController : UIViewController

@property(nonatomic,strong)UITableView *tableView;//设置属性tableView
@property(nonatomic,strong)NSArray *datas;//设置属性datas表示数据的数量
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIButton *curUserBtn;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *headLable;
@property(nonatomic,strong)NSUserDefaults *userInfo;
@property (nonatomic, strong) MineModel *mine;
-(void)loadNetData;//获取当前登录用户组信息
@end
