//
//  ResultViewController.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/17.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultTableViewCell.h"
#import "ResultModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "NetWorkTool.h"

@interface ResultViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * datas;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetData];
    [self initLayout];
}
-(void)initLayout{
    self.navigationItem.title = @"查看结果";
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

    //数据后期通过字典转模型
    //self.datas = [ResultModel mj_objectArrayWithFilename:@"result.plist"];
    //NSLog(@"%@",self.datas);//查看字典转模型对象内容
    
    //实现上拉下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"结果页下拉刷新中");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNetData];
            //[self.datas addObjectsFromArray:_datas];//增加 datas
            //[self.datas removeObjectAtIndex:0];//删除一行
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
}
-(void)loadNetData{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userInfo objectForKey:@"UserName"];
    NSString *passWord = [userInfo objectForKey:@"PassWord"];
    NSLog(@"看结果页面获取到的登录信息userName:%@ userName:%@",userName,passWord);
    NSDictionary *p = @{@"username":userName};
    [NetWorkTool resultWithParam:p Success:^(NSArray *models) {
        self.datas = [NSMutableArray arrayWithArray:models];
        NSLog(@"获取到的所有家人的测量结果为：%@",self.datas);
        [self.tableView reloadData];
    } Failture:^(NSError *error) {
        NSLog(@"获取结果列表失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取结果列表失败" message:@"请检查网络"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark -- 数据源方法 tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
#pragma mark -- 数据源方法 tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell * cell = (ResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    //Model 层来传递数据
    ResultModel *result = self.datas[indexPath.row];
    cell.result = result;
    return cell;
}

#pragma mark --<UITabkeViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我被点击了%@",self.datas[indexPath.row]);
    //点击跳动效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //手动触发推送操作 参数1：连线的标识(不是子界面的identity)  参数2：传递参数数据
    [self performSegueWithIdentifier:@"resultsDetail" sender:indexPath];
}

#pragma mark -- 传递数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //第一步，得到目的界面
    DetailViewController * detail = (DetailViewController *)segue.destinationViewController;
    //第二步：传递数据
    //首先，得到数据 索引标识
    NSIndexPath * indexpath = (NSIndexPath *) sender;
    //最后，开始传递数据
    detail.result  = self.datas[indexpath.row];
//    detail.result = result;

//    if (result.head != nil) {
//        detail.headString = result.head;
//    }
//    detail.nick = result.nick;
//    detail.rate_grade = result.rate_grade;
//    detail.time = result.time;
//    detail.rate_average = result.rate_average;
//    detail.rhythm_heart = result.rhythm_heart;
//    detail.cardia_heart = result.cardia_heart;

//    @property (nonatomic,copy) NSString *nick;//昵称
//    @property (nonatomic,copy) NSString *time;//时间
//    @property (nonatomic,copy) NSString *rate_grade;//得分
//    @property (nonatomic,copy) NSString *symptoms_rhythm;//心率病症
//    @property (nonatomic,copy) NSString *rate_average;//平均心率 82次
//    @property (nonatomic,copy) NSString *rate_min;//心率最小值 58
//    @property (nonatomic,copy) NSString *rate_max;//心率最大值 138
//    @property (nonatomic,copy) NSString *rhythm_heart;//心率节奏 稍微不齐
//    @property (nonatomic,copy) NSString *sinus_arrest;//否
//    @property (nonatomic,copy) NSString *cardia_heart;//心动情况 正常
//    @property (nonatomic,copy) NSString *heart_beat_number;//心跳个数 37
//    @property (nonatomic,copy) NSString *psvc_number;//室上性期前收缩 0
//    @property (nonatomic,copy) NSString *pvc_number;//室性期前收缩 3
//    @property (nonatomic,copy) NSString *QRS;
//    @property (nonatomic,copy) NSString *RR;
//    @property (nonatomic,copy) NSString *QT;
//    @property (nonatomic,copy) NSString *PR;
//    @property (nonatomic,copy) NSString *QTC;
//    @property (nonatomic,copy) NSString *symptoms_heart;//心房病症 无症状
//    @property (nonatomic,copy) NSString *symptoms_heart_left;//左房负荷增重 无症状
//    @property (nonatomic,copy) NSString *symptoms_heart_right;//右房负荷增重 无症状
//    @property (nonatomic,copy) NSString *symptoms_heart_two;//两房负荷增重 无症状


}
//



//数据前期读取pList文件数据 从字典读出数据后需要放到NSArray中 self.datas = [array copy] pathForResource:@"result" ofType:@"plist"  pathForAuxiliaryExecutable:@"result.plist"
//    NSString * path = [[NSBundle mainBundle]pathForAuxiliaryExecutable:@"result.plist"];
//    self.datas = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];


//cell
//    NSString * title = self.datas[indexPath.row][@"head"];
//    cell.headImageView.image = [UIImage imageNamed:[title stringByAppendingString:@".png"]];//头像,经测试，这里可以直接取png，不需要拼
//    cell.nameLabelView.text = self.datas[indexPath.row][@"name"];//名字
//    cell.scoreLabelView.text = self.datas[indexPath.row][@"score"];//分值
//    cell.timeLabelView.text = self.datas[indexPath.row][@"time"];//时间
//    cell.numLabelView.text = self.datas[indexPath.row][@"num"];//心率次数
//    cell.healthLabelView.text = self.datas[indexPath.row][@"health"];//健康
//    cell.symptomLabelView.text = self.datas[indexPath.row][@"symptom"];//症状
//    cell.feelBackgroud.layer.cornerRadius = 5.0;


//自定义解析 json
-(void)loadNetData1{
    //    NSError *error;
    //    NSString *url = @"http://114.215.159.55:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult&username=13751338740";
    //    http://192.168.123.5
    
    //    NSString *str=[NSString stringWithFormat:@"http://114.215.159.55:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult&username=13751338740"];
    //    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    NSURL *url = [NSURL URLWithString:@"http://114.215.159.55:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult&username=13751338740"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    NSLog(@"格式化后的 url 是:%@",request);
    //    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    //     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    [manager POST:@"http://192.168.123.5:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult&username=13751338740" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSArray *a =   [ResultModel mj_objectArrayWithKeyValuesArray:responseObject];
    //
    //        self.datas = [NSMutableArray arrayWithArray:a];
    //        NSLog(@"获取到的数据为：%@",self.datas);
    //        [self.tableView reloadData];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
    //    [operation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSString *html = operation.responseString;
    //
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //     NSArray *a =   [ResultModel mj_objectArrayWithKeyValuesArray:operation.responseString];
    ////        [ResultModel mj_objecta]
    //
    //        NSLog(@"此时得到带[]的json 数组 是:%@",html);//此时得到带[]的json 数组
    //        NSRange rang1 = [html rangeOfString:@"["];
    //        NSString *str1 = [html stringByReplacingCharactersInRange:rang1 withString:@""];
    //        NSLog(@"第一次处理后的字符串是%@",str1);
    //        NSRange rang2 = [str1 rangeOfString:@"]"];
    //        NSString *str2 = [str1 stringByReplacingCharactersInRange:rang2 withString:@""];
    //        NSLog(@"第二次处理后的字符串是%@",str2);
    //
    //        NSData *da= [str2 dataUsingEncoding:NSUTF8StringEncoding];
    //        NSError *error = nil;
    //        id jsonObject = [NSJSONSerialization JSONObjectWithData:da options:NSJSONReadingAllowFragments error:&error];
    //        if ([jsonObject isKindOfClass:[NSDictionary class]]){
    //            NSDictionary *dictionary = (NSDictionary *)da;
    //            NSLog(@"Dersialized JSON Dictionary = %@", dictionary);
    //        }else if ([jsonObject isKindOfClass:[NSArray class]]){
    //            NSArray *nsArray = (NSArray *)jsonObject;
    //            NSLog(@"Dersialized JSON Array = %@", nsArray);
    //        } else {
    //            NSLog(@"An error happened while deserializing the JSON data.");
    //        }
    //        NSArray *ARRAY = [ResultModel mj_objectArrayWithKeyValuesArray:responseObject[@"nick"]];
    //
    //        self.datas = [NSMutableArray arrayWithArray:ARRAY];
    //        NSLog(@"获取到的数据为：%@",self.datas);
    //        [self.tableView reloadData];
    //
    ////        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    ////        NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
    ////        NSData* data=[str2 dataUsingEncoding:NSUTF8StringEncoding];
    ////        NSLog(@"格式化后的 data 是:%@",data);
    ////        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
    ////        NSLog(@"获取到的数据为：%@",dict);
    //    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"发生错误！%@",error);
    //    }];
    //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //    [queue addOperation:operation];
    //
}

@end

