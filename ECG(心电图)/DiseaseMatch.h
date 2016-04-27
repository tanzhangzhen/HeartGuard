//
//  DiseaseMatch.h
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultData.h"


@interface DiseaseMatch : NSObject

@property (nonatomic,strong) ResultData * resultData;

-(Boolean)ifPrematureBeat;
-(Boolean)ifPremature;
-(int)isBaoLoad;

-(Boolean)ifStopBeat:(float)RR_duration;
-(Boolean)ifMissBeat:(float)RR_duration Avg_RR_duration:(float)avg_RR_duration;
-(Boolean)ifRonT;
-(Boolean)ifPrematureVentricualrContraction:(float)HRV1 HRV2:(float)HRV2 HRV3:(float)HRV3 QRS_duration:(float)QRS_duration;
-(Boolean)ifTachyrhythm:(float)RR_duration;
-(Boolean)ifBradycardia:(float)RR_duration;

@end
