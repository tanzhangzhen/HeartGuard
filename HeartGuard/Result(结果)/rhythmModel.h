//
//  rhythmModel.h
//  HeartGuard
//
//  Created by MM on 16/4/10.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rhythmModel : NSObject


@property (nonatomic,copy) NSString  *psvc_number;//房性期前收缩 0
@property (nonatomic,copy) NSString  *pvc_number;//室性期前收缩 3
@property (nonatomic,copy) NSString  *sinus_arrest;//窦性停搏 否
@property (nonatomic,copy) NSString  *rhythm_heart;//心率节奏 稍微不齐

@end
