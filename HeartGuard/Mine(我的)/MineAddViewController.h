//
//  MineAddViewController.h
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"
#import "NetWorkTool.h"
#import "MineViewController.h"
#import "MineFamilyViewController.h"

@interface MineAddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISwitch *sex;
@property (weak, nonatomic) IBOutlet UITextField *birth;
@property (weak, nonatomic) IBOutlet UITextField *high;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (nonatomic,strong) MineModel *mine;

- (IBAction)save:(id)sender;

@end
