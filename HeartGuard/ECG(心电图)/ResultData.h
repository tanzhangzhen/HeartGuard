//
//  ResultData.h
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultData : NSObject

-(void)countAverageQRS;
-(void)countAverageQT;
-(void)countAveragePR;
-(void)countAverageQTcB;
-(NSMutableArray*)getVariance;
-(NSMutableArray *)getLogData_ifPositive;


@end
