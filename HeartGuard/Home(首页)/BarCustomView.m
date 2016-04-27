//
//  BarCustomView.m
//  HeartGuard
//
//  Created by MM on 16/3/14.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "BarCustomView.h"

@implementation BarCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)setUpView{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    //自定义导航栏navigationItem导航条添加任意视图，放到数组中，显示顺序，左边：按数组顺序从左向右；右边：按数组顺序从右向左
    UIImageView *navImage = [[UIImageView alloc]init];
    [navImage setImage:[UIImage imageNamed:@"ic_launcher"]];
    navImage.frame = CGRectMake(5, 10, 30, 30);
    
    UILabel *navLabel = [[UILabel alloc]init];
    navLabel.text = @"智能云心电仪";
    navLabel.textColor = [UIColor whiteColor];
    navLabel.frame = CGRectMake(45 ,15, 120, 20);
    
    UIButton *navButton = [[UIButton alloc]init];
    [navButton setImage:[UIImage imageNamed:@"ic_family"] forState:UIControlStateNormal];
    navButton.frame = CGRectMake(screenW-15, 0, 30, 20);
//    [navButton addTarget:self action:@selector(rightOnclick) forControlEvents:UIControlEventTouchDown];//点击事件
    
//    UIBarButtonItem *view1 = [[UIBarButtonItem alloc]initWithCustomView:navImage];
//    UIBarButtonItem *view2 = [[UIBarButtonItem alloc] initWithCustomView:navLabel];
//    UIBarButtonItem *view3 = [[UIBarButtonItem alloc] initWithCustomView:navButton];
//    NSArray *arrViews = [[NSArray alloc]initWithObjects:view1,view2,nil];//添加到数组中
    [self addSubview:navImage];
    [self addSubview:navLabel];
    [self addSubview:navButton];

}

@end
