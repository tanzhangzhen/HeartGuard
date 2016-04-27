//
//  MineFamilyViewController.h
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineFamilyViewController : UIViewController

@property(nonatomic,strong) MineModel *mine;
//更新家人列表
-(void)loadNetData;
@end
