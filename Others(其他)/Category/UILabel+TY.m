//
//  UILabel+TY.m
//  高仿_搜房网
//
//  Created by MM-Lab on 15/9/17.
//  Copyright (c) 2015年 Lab-Mini-1. All rights reserved.
//

#import "UILabel+TY.h"

@implementation UILabel (TY)

-(instancetype)initWithFrame:(CGRect)frame andText:(UILabel *)text{
    if (self = [super init]) {
        
        self.frame = frame;//设置位置
        self.font = [UIFont systemFontOfSize:11];//设置label字体大小
        self.textAlignment = NSTextAlignmentCenter;//设置文字居中
//        NSString *Str = [NSString stringWithFormat:@"%@\n",text];//设置字符串拼接totalStr＝text＋text2
//        NSMutableAttributedString *btnText = [[NSMutableAttributedString alloc ]initWithString:Str];//初始化、分配内存
//        [self setAttributedTitle:btnText forState:UIControlStateNormal];//设置Button文字
    }
    return self;
//    UILabel *label = [[UILabel alloc]initWithFrame:<#(CGRect)#> andImage:<#(UIImage *)#>];
//    label.frame = frame;
//    return label;
}

@end
