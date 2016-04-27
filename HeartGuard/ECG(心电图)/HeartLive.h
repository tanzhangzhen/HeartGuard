//
//  ECGViewController.h
//  智能云心电仪
//
//  Created by MM on 16/3/12.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointContainer : NSObject

@property (nonatomic , readonly) CGPoint *translationPointContainer;//点容器
@property (nonatomic , readonly) NSInteger numberOfTranslationElements;//点元素数
+ (PointContainer *)sharedContainer;//共享的容器，单例模式
- (void)addPointAsTranslationChangeform:(CGPoint)point;//增加点到点容器中

@end



@interface HeartLive : UIView

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;

@end

