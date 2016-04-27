//
//  UserLoginModel.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/18.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginModel : NSObject
//搜房网登陆返回的数据保存
@property(nonatomic,strong)NSString *md5_code;
@property(nonatomic,strong)NSString *user_id;
//云心电仪登陆数据保存
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;

@end
