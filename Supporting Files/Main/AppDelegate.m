//
//  AppDelegate.m
//  HeartGuard
//
//  Created by MM on 16/3/14.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "AppDelegate.h"
#import "RKSwipeBetweenViewControllers.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "NavigationController.h"
#import "RegexKitLite.h"
#import "ECGViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];//设置app启动后窗口的初始化和大小
    self.window.backgroundColor = [UIColor whiteColor];//设置app启动后窗口的背景颜色
    [[UITabBar appearance] setTintColor:[UIColor blueColor]];//设置UITabBar背景色
    //设置app进入后首先打开 登陆 页面 需要在storyboard取消页面入口
    NavigationController * nav = [[NavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.rootViewController = nav;//设置当前window的根控制器为
    [self.window makeKeyAndVisible];//使被使用对象的主窗口显示到屏幕的最前端
    
    //[self xmlParse];
    return YES;
}

/*
    Elapsed time\t        MLII\t     V1\r\n01234567890123456789012345678901223\r\n
    hh:mm:ss.mmm\t        (mV)\t      (mV)\r\n
    0:00.000\t -0.445\r\n 0:00.003\t -0.445\r\n  0:00.006\t -0.445\r\n
*/
-(void)xmlParse{
    ECGViewController *ecg = [[ECGViewController alloc]init];
    NSMutableArray *data = [ecg handleStringPath:@"MLII_108_2-3min" ofType:@"xml"];
    //[self findRData:data];//未滤波去寻找 R 波
    //[self findRData:[ecg handleWaveData:data CountNum:5000]];//滤波后去寻找 R 波
    //[ecg handleData:data Tag:1];
}
#pragma mark - findR波
-(void)findRData:(NSMutableArray *)data{
    //每次分析心电数据的单元，目前以5秒为一个单位1620
//    static int ALLPOINT = 5000;
//    NSInteger startIndex = data.count-ALLPOINT;
//    NSMutableArray *intercept = [NSMutableArray arrayWithArray:[data subarrayWithRange:NSMakeRange(startIndex, ALLPOINT)]];//data.count-1是因为元素下标从0开始，100个元素则最后一个下标为99，否则就越界
//    FindR *fqrs = [[FindR alloc]initWithData:data WithStartIndex:(int)startIndex];
    FindR *fqrs = [[FindR alloc]initWithData:data WithStartIndex:0];
    //保存R波峰值的表
    NSMutableArray *prelist = [NSMutableArray array];
    [prelist addObjectsFromArray:fqrs.StartToSearchQRS];    NSLog(@"R波峰值的集合：%@",prelist);
    NSMutableArray *rB= fqrs.getAllRPoint;  NSLog(@"R波下标的集合%@，R波下标个数%lu",rB,rB.count);
    float variance = fqrs.getVariance;  NSLog(@"R波下标方差%f" , variance);
    //心率=60*360/R值平均下标差
    int rate = fqrs.getHeartRate;   NSLog(@"心率=60*a*360/R值平均下标差=%d" , rate);
    //检测 R 波分析出的一些其他数据
    NSMutableArray *AvgList = fqrs.getAvgList;
    NSMutableArray *Min_avg = fqrs.getMin_avg;
    NSMutableArray *Max_avg = fqrs.getMax_avg;
    float LogData_slopeGate = fqrs.getLogData_slopeGate;
    float LogData_dateGate = fqrs.getLogData_dateGate;
    float RRInternal = fqrs.GetRRInternal;
    float RRAverage = RRInternal / 360 * 1000; // RR间期的平均值
    float AverageHeart_rate = 60 * 360 / RRInternal; // RR平均心率
    NSLog(@"搜索 R 波获得的平均值%@, 最小平均值%@, 最大平均值%@, 最大斜率值%f, 最大数据值%f ,获取R值下标的平均差%f,RR间期的平均值%f,RR间期平均心率%f",AvgList,Min_avg,Max_avg,LogData_slopeGate,LogData_dateGate, RRInternal,RRAverage,AverageHeart_rate);
}
#pragma mark - findTQS波
-(void)findTQSNormalRR:(NSMutableArray *)data {
//    FindTQS *findt = [[FindTQS alloc]initWithNormalRR:0 WithRealRR:0 WithData:data];
//    findt.startToSearchT(list.get(k).keyAt(0));
//    [self findt.findQSpoint];
    //normalrr为所有rr间期的平均值（一次心搏的采样点数）
    float normalrr = 0;
    // 整段数据的RR间期的差值（心室率）
//    findt = new FindTQS(normalrr,
//                                (list.get(k).keyAt(0) - list.get(k - 1)
//                                 .keyAt(0)), newDataListY);
//        findt.startToSearchT(list.get(k).keyAt(0));
//        findt.findQSpoint();
//        resultData.getTempTstart().add(findt.getTempStart());
//        resultData.getTempTend().add(findt.getTempEnd());
//        resultData.getTstart().add(findt.gettFinalStart());
//        resultData.getTend().add(findt.gettFinalEnd());
//        resultData.getTIsUp().add(findt.isUp());
//        resultData.getQRSAverage().add(findt.getQRSAverage());
//        resultData.getQpoint().add(findt.getQpoint());
//        resultData.getQstart().add(findt.getQStart());
//        resultData.getSpoint().add(findt.getSpoint());
//        resultData.getTpoint().add(findt.gettPoint());
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
