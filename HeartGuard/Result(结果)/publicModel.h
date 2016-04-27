//
//  publicModel.h
//  HeartGuard
//
//  Created by MM on 16/4/10.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface publicModel : NSObject

@property (nonatomic,copy) NSString *rate_average;//平均心率 82次
@property (nonatomic,copy) NSString *rate_min;//心率最小值 58
@property (nonatomic,copy) NSString *rate_max;//心率最大值 138
@property (nonatomic,copy) NSString *heart_beat_number;//心跳个数 37
@property (nonatomic,copy) NSString *prematureBeat;//早搏个数
@property (nonatomic,copy) NSString *cardia_heart;//心动情况 正常
@property (nonatomic,copy) NSString *psvc_Index;//房性期前收缩下标
@property (nonatomic,copy) NSString *pvc_Index;//室性期前收缩下标
@property (nonatomic,copy) NSString *symptoms_rhythm;//心率病症
@property (nonatomic,copy) NSString *symptoms_heart;//心房病症 无症状
@property (nonatomic,copy) NSString *QRS;
@property (nonatomic,copy) NSString *RR;
@property (nonatomic,copy) NSString *QT;
@property (nonatomic,copy) NSString *PR;
@property (nonatomic,copy) NSString *QTC;


@end
