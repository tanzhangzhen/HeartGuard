//
//  UIButton+TY.m
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "UIButton+TY.h"

@implementation UIButton (TY)

-(instancetype)initWithFrame:(CGRect)frame bgImage:(NSString *)bg_image bgColor:(UIColor *)bg_color title:(NSString *)title titleColor:(UIColor *)t_color font:(UIFont *)font   Radius:(float )radius target:(id)target action:(SEL)action{
    
    if (self = [super init]) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        if (bg_image)
        {
            [btn setBackgroundImage:[UIImage imageNamed:bg_image] forState:UIControlStateNormal];
        }
        if (bg_color) {
            btn.backgroundColor= bg_color;
        }
        if (title) {
            [btn setTitle:title forState:UIControlStateNormal];
        }
        if (t_color)
        {
            [btn setTitleColor:t_color forState:UIControlStateNormal];
        }
        if (font) {
            btn.titleLabel.font = font;
        }
        if (radius) {
            btn.layer.cornerRadius = radius;
        }
        if (target&&action)
        {
            [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}
@end
