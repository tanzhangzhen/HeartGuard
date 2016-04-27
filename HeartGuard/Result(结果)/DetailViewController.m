//
//  DetailViewController.m
//  UILesson07
//
//  Created by DGSCDI on 15/10/16.
//  Copyright © 2015年 com.tianyi. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *head;//头像 本地属性
@property (weak, nonatomic) IBOutlet UILabel *nick;//昵称
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property (weak, nonatomic) IBOutlet UILabel *rate_averagee;//得分、心率



@property (weak, nonatomic) IBOutlet UILabel *heart_beat_number;//心跳个数 37
@property (weak, nonatomic) IBOutlet UILabel *rate_grade;//早搏个数
@property (weak, nonatomic) IBOutlet UILabel *sinus_arrest;//窦性停搏 否
@property (weak, nonatomic) IBOutlet UILabel *cardia_heart;//心动情况 正常
@property (weak, nonatomic) IBOutlet UILabel *rhythm_heart;//心率节奏 稍微不齐
@property (weak, nonatomic) IBOutlet UILabel *psvc_number;//室上性期前收缩 0
@property (weak, nonatomic) IBOutlet UILabel *pvc_number;//室性期前收缩 3

@property (weak, nonatomic) IBOutlet UILabel *symptoms_rhythm;//心率病症
@property (weak, nonatomic) IBOutlet UIImageView *Symptoms_rhythm_i;//心率病症图
@property (weak, nonatomic) IBOutlet UILabel *symptoms_heart;//心房病症 无症状
@property (weak, nonatomic) IBOutlet UIImageView *symptoms_heart_i;//心房病症图

@property (weak, nonatomic) IBOutlet UILabel *rate_average;//平均心率 82次
@property (weak, nonatomic) IBOutlet UILabel *numQRS;// 计算平均QRS值
@property (weak, nonatomic) IBOutlet UILabel *numRR;//计算平均RR值
@property (weak, nonatomic) IBOutlet UILabel *numQT;//计算平均QT值,必须先计算QT才能计算QTc，QTc是由QT和RR决定的
@property (weak, nonatomic) IBOutlet UILabel *numPR;//计算平均PR值
@property (weak, nonatomic) IBOutlet UILabel *numQTc;//计算平均QTc值

@property (weak, nonatomic) IBOutlet UILabel *symptoms_heart_left;//左房负荷增重 无症状
@property (weak, nonatomic) IBOutlet UILabel *symptoms_heart_right;//右房负荷增重 无症状
@property (weak, nonatomic) IBOutlet UILabel *symptoms_heart_two;//两房负荷增重 无症状


@property (nonatomic,copy) NSString *username;//用户名
@property (nonatomic,copy) NSString *password;//密码
@property (nonatomic,copy) NSString *rate_min;//心率最小值 58
@property (nonatomic,copy) NSString *rate_max;//心率最大值 138
@property (nonatomic,assign) NSInteger ecgflag;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"诊断报告";
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickbackBtn)];
    [backBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [backBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    backBtn.tintColor=[UIColor blueColor];//返回箭头颜色
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    //确定scrollView能滚动多大范围CGRectGetMaxY(self.view.frame)+10
    self.scrollView.contentSize=CGSizeMake(320,800);
    //在scrollView周边增加滚动区域top为负主要是 ios7显示问题
    self.scrollView.contentInset=UIEdgeInsetsMake(-60, 0, 49, 0);
    //设置scrollView里的控件的移动位置
    self.scrollView.contentOffset=CGPointMake(0, -60);
//    self.detail = [[DetailViewController alloc]init];
}
-(void)clickbackBtn
{
    if (_ecgflag == 1) {
        //成功登陆后跳转到Storyboard
        UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller =  [mainBoard instantiateViewControllerWithIdentifier:@"main"];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = controller;

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark --界面出现加载详情数据
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _ecgflag = _result.ecgflag;
    _head.image = [UIImage imageNamed:_result.nick];
    _nick.text = _result.nick;//nick昵称
    _time.text = _result.time;//time时间
    
    _rate_averagee.text = _result.rate_average;//rate_grade得分、心率
    _rate_average.text = _result.rate_average;//rate_average平均心率 82次
    _rhythm_heart.text = _result.rhythm_heart;//rhythm_heart心率节奏 稍微不齐
    _sinus_arrest.text = _result.sinus_arrest;//sinus_arrest否
    _cardia_heart.text = _result.cardia_heart;//cardia_heart心动情况 正常
    _heart_beat_number.text = _result.heart_beat_number;//heart_beat_number心跳个数 37
    _rate_grade.text = _result.rate_grade;//早搏个数
    _psvc_number.text = _result.psvc_number;//psvc_number室上性期前收缩 0
    _pvc_number.text = _result.pvc_number;//pvc_number室性期前收缩 3
    _numQRS.text = _result.QRS;
    _numPR.text = _result.PR;
    _numQT.text = _result.QT;
    _numQTc.text = _result.QTC;
    _numRR.text = _result.RR;
    _symptoms_rhythm.text = _result.symptoms_rhythm;//symptoms_rhythm心率病症
    _Symptoms_rhythm_i.image = [UIImage imageNamed:[self selectColor:_result.symptoms_rhythm]];//心率病症显示图片
    _symptoms_heart.text = _result.symptoms_heart;//symptoms_heart心房病症 无症状
    _symptoms_heart_i.image = [UIImage imageNamed:[self selectColor:_result.symptoms_heart]];//心房病症显示图片
    _symptoms_heart_left.text = _result.symptoms_heart_left;//symptoms_heart_left左房负荷增重 无症状
    _symptoms_heart_right.text = _result.symptoms_heart_right;//symptoms_heart_right右房负荷增重 无症状
    _symptoms_heart_two.text = _result.symptoms_heart_two;//symptoms_heart_two两房负荷增重 无症状
    
}
-(void)setResult:(ResultModel *)result{
    _result = result;
}
-(NSString *)selectColor:(NSString *)title{
    NSString *imageColor = title;
    if ([imageColor isEqualToString:@"无症状"]||[imageColor isEqualToString:@"健康"]) {
        imageColor = @"ic_sym_health";
    }else if ([imageColor isEqualToString:@"较轻"]||[imageColor isEqualToString:@"室性期前收缩"]){
        imageColor = @"ic_sym_normal";
    }else if ([imageColor isEqualToString:@"严重"]||[imageColor isEqualToString:@"房性期前收缩"]){
        imageColor = @"ic_sym_medium";
    }else if ([imageColor isEqualToString:@"两房负荷增重"]||[imageColor isEqualToString:@"非常严重"]){
        imageColor = @"ic_sym_bad";
    }
    return imageColor;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
