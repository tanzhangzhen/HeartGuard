//
//  FineR.h
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindR : NSObject


-(instancetype)initWithData:(NSMutableArray *)data WithStartIndex:(int)startIndex;
-(void)setALLPOINT:(int)point_num;
-(NSMutableArray *)StartToSearchQRS;
-(void)absDataIfNeed:(int)startPosition;
-(float)GetMaxSlopeGate;
-(float)GetMaxDataGate;
-(int)FindOverMaxSlopeGate:(int)s;
-(int)GetMaxData:(int)start;
-(int)FindRPoint:(int)start;
-(int)FindRestRPoint:(int)start;
-(float)GetRRInternal;
-(NSMutableArray *)getAllRPoint;
-(int)getHeartRate;
-(float)getVariance;
-(void)MakeSureRPoint:(int)start;
-(NSMutableArray *)getAvgList;
-(NSMutableArray *)getMin_avg;
-(NSMutableArray *)getMax_avg;
-(float)getLogData_slopeGate;
-(float)getLogData_dateGate;


@end
