//
//  HomeViewController.h
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/18.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@protocol HomeViewControllerDelegate <NSObject>
//-(void)home:(HomeViewController *)control didClickButton2_2:(UIButton *)button;
@end

@interface HomeViewController : UIViewController

@property (nonatomic , strong) NSMutableArray *dataSource;//数据源
@property (nonatomic , strong) NSString *message;//消息通知


@property(nonatomic,weak) id<HomeViewControllerDelegate>  delegate;

//typedef void (^ReturnTextBlock)(NSString *showText);//为要声明的Block重新定义了一个名字
//@property(nonatomic,strong) void(^button4_1Click)();
//@property (nonatomic, copy) ReturnTextBlock returnTextBlock;//定义的一个Block属性
//- (void)returnText:(ReturnTextBlock)block;


@end
