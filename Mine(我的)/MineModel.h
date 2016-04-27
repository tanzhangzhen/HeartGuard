//
//  MineModel.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/19.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject

@property (nonatomic,assign) int tag;//页面跳转标识
@property (nonatomic,strong) NSString *image;//头像
@property (nonatomic,copy) NSString *username;//用户名
@property (nonatomic,copy) NSString *nick;//昵称
@property (nonatomic,copy) NSString *gender;//性别
@property (nonatomic,copy) NSString *birthday;//生日
@property (nonatomic,copy) NSString *high;//身高
@property (nonatomic,copy) NSString *weight;//体重
@property (nonatomic,copy) NSString *title;//添加家人返回 title

@end
