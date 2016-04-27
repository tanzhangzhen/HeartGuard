//
//  FindP.h
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindP : NSObject


-(void)startToSearchT:(int)rPoint;
-(void)analyseTempStartAndEnd;
-(void)analyseMaxAndMin;
-(float)changeEquationStartWithN0:(int)n0 WithNe:(int)ne WithN:(int)n;
-(float)changeEquationEndWithN0:(int)n0 WithNe:(int)ne WithN:(int)n;
-(int)findFinalStartTPointWithN0:(int)n0 WithNe:(int)ne;
-(int)findFinalEndTPointWithN0:(int)n0 WithNe:(int)ne;
-(int)getDoublePpoint;
-(Boolean)isUpM;


@end
