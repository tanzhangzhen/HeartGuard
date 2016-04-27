//
//  pqrstModel.h
//  HeartGuard
//
//  Created by MM on 16/4/10.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pqrstModel : NSObject

@property (nonatomic,copy) NSMutableArray *rPoint;//R波集合
@property (nonatomic,copy) NSString *rCount;//R波个数
@property (nonatomic,copy) NSMutableArray *pPoint;//P波集合
@property (nonatomic,copy) NSString *pCount;//P波个数
@property (nonatomic,copy) NSMutableArray *tPoint;//T波集合
@property (nonatomic,copy) NSString *tCount;//T波个数
@property (nonatomic,copy) NSMutableArray *qPoint;//Q波集合
@property (nonatomic,copy) NSString *qCount;//Q波个数
@property (nonatomic,copy) NSMutableArray *sPoint;//S波集合
@property (nonatomic,copy) NSString *sCount;//S波个数


@end
