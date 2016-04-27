//
//  ResultModel.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/17.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "publicModel.h"
#import "pqrstModel.h"
#import "rhythmModel.h"
#import "symptomsModel.h"

@interface ResultModel : NSObject

//本地公共属性 本地plist属性 注意Model中定义的必须与 plist 文件中的字段名一致
@property (nonatomic,copy) NSString *message;//服务器错误信息
@property (nonatomic,assign) NSInteger ecgflag;//标识 判断诊断报告是 ecg 还是结果页跳转过去的
@property (nonatomic,strong) NSString * head;//头像 本地属性
@property (nonatomic,copy) NSString *username;//用户名
@property (nonatomic,copy) NSString *password;//密码
@property (nonatomic,copy) NSString *nick;//昵称
@property (nonatomic,copy) NSString *time;//时间
//public模块
@property (nonatomic,strong) publicModel *mPublic;
@property (nonatomic,copy) NSString *rate_average;//平均心率 82次
@property (nonatomic,copy) NSString *rate_min;//心率最小值 58
@property (nonatomic,copy) NSString *rate_max;//心率最大值 138
@property (nonatomic,copy) NSString *heart_beat_number;//心跳个数 37
@property (nonatomic,copy) NSString *rate_grade;//早搏个数prematureBeat
@property (nonatomic,copy) NSString *cardia_heart;//心动情况 正常
//@property (nonatomic,copy) NSMutableArray *psvc_Index;//房性期前收缩下标
//@property (nonatomic,copy) NSMutableArray *pvc_Index;//室性期前收缩下标
@property (nonatomic,copy) NSString *symptoms_rhythm;//心率病症
@property (nonatomic,copy) NSString *symptoms_heart;//心房病症 无症状
@property (nonatomic,copy) NSString *QRS;//平均QRS值
@property (nonatomic,copy) NSString *RR;//平均RR值
@property (nonatomic,copy) NSString *QT;//平均QT值,必须先计算QT才能计算QTc，QTc是由QT和RR决定的
@property (nonatomic,copy) NSString *PR;//平均PR值
@property (nonatomic,copy) NSString *QTC;//平均QTc值
//心律模块
@property (nonatomic,strong) rhythmModel *mRhythm;
@property (nonatomic,copy) NSString  *psvc_number;//房性期前收缩 0
@property (nonatomic,copy) NSString  *pvc_number;//室性期前收缩 3
@property (nonatomic,copy) NSString  *sinus_arrest;//窦性停搏 否
@property (nonatomic,copy) NSString  *rhythm_heart;//心率节奏 稍微不齐
//心房模块
@property (nonatomic,strong) symptomsModel *mSymptoms;
@property (nonatomic,copy) NSString *symptoms_heart_left;//左房负荷增重 无症状
@property (nonatomic,copy) NSString *symptoms_heart_right;//右房负荷增重 无症状
@property (nonatomic,copy) NSString *symptoms_heart_two;//两房负荷增重 无症状
//pqrst波模块
@property (nonatomic,strong) pqrstModel *mPqrst;
//@property (nonatomic,copy) NSMutableArray *rPoint;//R波集合
@property (nonatomic,copy) NSString *rCount;//R波个数
//@property (nonatomic,copy) NSMutableArray *pPoint;//P波集合
@property (nonatomic,copy) NSString *pCount;//P波个数
//@property (nonatomic,copy) NSMutableArray *tPoint;//T波集合
@property (nonatomic,copy) NSString *tCount;//T波个数
//@property (nonatomic,copy) NSMutableArray *qPoint;//Q波集合
@property (nonatomic,copy) NSString *qCount;//Q波个数
//@property (nonatomic,copy) NSMutableArray *sPoint;//S波集合
@property (nonatomic,copy) NSString *sCount;//S波个数
//搜房网的
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *building_type;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *money;

@end
