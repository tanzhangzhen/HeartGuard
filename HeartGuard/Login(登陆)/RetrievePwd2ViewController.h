//
//  RetrievePwd2ViewController.h
//  HeartGuard
//
//  Created by MM on 16/3/17.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>


@class  login;

@interface RetrievePwd2ViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary* dict;
@property(nonatomic,copy) login *logininfo;

//从a传值到b  属性必须定义在.h文件中
@property(nonatomic,strong)NSString *userPhone;

@end