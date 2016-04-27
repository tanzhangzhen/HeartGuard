//
//  UIButton+TY.h
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TY)

-(instancetype)initWithFrame:(CGRect)frame bgImage:(NSString *)bg_image bgColor:(UIColor *)bg_color title:(NSString *)title titleColor:(UIColor *)t_color font:(UIFont *)font   Radius:(float )radius target:(id)target action:(SEL)action;
@end
