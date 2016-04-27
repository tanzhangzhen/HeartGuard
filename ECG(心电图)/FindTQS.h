//
//  FineTQS.h
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindTQS : NSObject

-(instancetype)initWithNormalRR:(float)normalRR WithRealRR:(float)realRR WithData:(NSMutableArray *)data;
-(void)startToSearchT:(int)rPoint;
-(void)findQSpoint;
-(Boolean)makeSureQpoint:(int)Qpoint WithSlopeGate:(float)slopeGate;
-(Boolean)makeSureSpoint:(int)Qpoint WithSlopeGate:(float)slopeGate;
-(int)findQStart:(int)minQ;
-(float)getQRSAverage;
-(void)analyseTempStartAndEnd;
-(void)analyseMaxAndMin;
-(float)changeEquationWithN0:(int)n0 WithNe:(int)ne WithN:(int)n;
-(int)findFinalStartAndEndTPointWithN0:(int)n0 WithNe:(int)ne;
-(Boolean)isUpM;

@end
