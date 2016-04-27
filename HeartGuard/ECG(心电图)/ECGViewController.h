//
//  ECGViewController.h
//  智能云心电仪
//
//  Created by MM on 16/3/12.
//  Copyright © 2016年 mm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartLive.h"
#import "Masonry.h"
#import "RegexKitLite.h"
#import "FindP.h"
#import "FindR.h"
#import "FindTQS.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "NavigationController.h"
#import "ResultModel.h"

@interface ECGViewController : UIViewController

@property (nonatomic , strong) NSMutableArray *dataSource;//数据源
@property (nonatomic , strong) HeartLive *translationMoniterView;//平移视图
@property (nonatomic , strong) NSString *message;
@property (nonatomic , strong) NSString *dataCount;
@property (nonatomic , strong) FindR *fqrs;
@property (nonatomic , strong) ResultModel *result;
#pragma mark - 自定义读文件、处理字符串的方法，参数为文件名和文件类型 @"MLII_108_2-3min"
-(NSMutableArray *)handleStringPath:(NSString *)path ofType:(NSString*)type;
#pragma mark - 自定义中值滤波方法 参数1：要处理的数据源 参数2：要处理的数据量
-(NSMutableArray *)handleWaveData:(NSMutableArray *)data CountNum:(NSInteger)mCount;
#pragma mark - 数据处理，调整波形 Y 坐标，使波形显示在界面中央
-(NSMutableArray *)handleData:(NSMutableArray *)data Tag:(NSInteger)tag;

@end

