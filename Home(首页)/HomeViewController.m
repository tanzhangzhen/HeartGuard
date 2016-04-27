//
//  HomeViewController.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/18.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ECGViewController.h"
#import "Masonry.h"
#import "BarCustomView.h"

@interface HomeViewController ()<UIAlertViewDelegate>
{
    NSString *d0;
    NSString *d1;
    NSString *d2;
    NSString *d3;
    NSString *d4;
    NSString *d5;
    NSString *d6;
    NSString *d7;
    NSString *d8;
    NSString *d9;
}
@property(nonatomic,assign)BOOL isLogin;

@property (weak, nonatomic) IBOutlet UITextField *dataCount;

- (IBAction)startECG:(UIButton *)sender;
- (IBAction)selectData:(id)sender;


@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _isLogin = NO;
    self.navigationController.navigationBarHidden = NO;

    //自定义导航栏navigationItem导航条添加任意视图，放到数组中，显示顺序，左边：按数组顺序从左向右；右边：按数组顺序从右向左
    UIImageView *navImage = [[UIImageView alloc]init];
    [navImage setImage:[UIImage imageNamed:@"ic_launcher"]];
    navImage.frame = CGRectMake(15, 15, 30, 30);

    UILabel *navLabel = [[UILabel alloc]init];
    navLabel.text = @"智能云心电仪";
    navLabel.textColor = [UIColor whiteColor];
    navLabel.frame = CGRectMake(15 ,15, 120, 20);
    
    UIButton *navButton = [[UIButton alloc]init];
    [navButton setImage:[UIImage imageNamed:@"ic_family"] forState:UIControlStateNormal];
    navButton.frame = CGRectMake(15, 15, 30, 20);
    [navButton addTarget:self action:@selector(rightOnclick) forControlEvents:UIControlEventTouchDown];//点击事件
    
    UIBarButtonItem *view1 = [[UIBarButtonItem alloc]initWithCustomView:navImage];
    UIBarButtonItem *view2 = [[UIBarButtonItem alloc] initWithCustomView:navLabel];
    UIBarButtonItem *view3 = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    NSArray *arrViews = [[NSArray alloc]initWithObjects:view1,view2,nil];//添加到数组中
    self.navigationItem.leftBarButtonItems = arrViews;//数组添加到nav左边
    self.navigationItem.rightBarButtonItem = view3;
    d0 = @"data0";
    d1 = @"MLII_100_0-10s";
    d2 = @"MLII_105_0-1min";
    d3 = @"MLII_106_2-3min";
    d4 = @"MLII_107_2-3min";
    d5 = @"MLII_108_2-3min";
    d6 = @"MLII_111_0-1min";
    d7=  @"MLII_112_2-3min";
    d8 = @"MLII_115_0-1min";
    d9 = @"MLII_117_0-1min";
}
-(void)rightOnclick{
    self.tabBarController.selectedIndex = 2;
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if (_isLogin) {
//        return;
//    }
//    _isLogin = YES;
//    //两种方式页面跳转
//    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
//    [self presentViewController:login animated:YES completion:nil];
//    
//    //去掉NavigationBar的backButton去掉是在push之前
////    login.navigationItem.hidesBackButton = YES;
////    [self.navigationController pushViewController:login animated:YES];
//}

- (IBAction)startECG:(UIButton *)sender {
    //这里面核心的有两个,所谓跳转，其实就是往导航控制器栈中PUSH或者POP一个视图控制器，这样在最上面的视图控制器就变了，这样视图也跟着变了，因为只显示在栈顶得那个视图控制器的视图
    //所以(1)控制所谓的跳转，其实是导航控制器在控制，在里面的元素都可以通过navigationController属性获取到它们所在的导航控制器
    //所以(2)获取到导航控制器之后，使用Push的那个方法，往栈里面放一个视图控制器ecg，这个新放入的在栈顶，就显示它的视图，所以用户改变页面跳转了
    ECGViewController *ecg = [[ECGViewController alloc]init];
    ecg.message = _message;
    ecg.dataCount = _dataCount.text;
    [self.navigationController pushViewController:ecg animated:YES];
}

- (IBAction)selectData:(id)sender {
    //MLII_105_0-1min MLII_106_2-3min MLII_107_2-3min MLII_108_2-3min
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择一条数据" message:nil delegate:self cancelButtonTitle:@"默认数据" otherButtonTitles:d1,d2,d3,d4,d5,d6,d7,d8,d9,nil];
    //NSLog(@"按钮1的标题是:%@",[alert buttonTitleAtIndex:1]);//获取指定索引的按钮标题
    [alert show];
    //d9倒  d8粗 d7倒 d6粗 d5正108 d4倒幅度较大 d3倒较差 d2倒
}

-(void)showMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您选择了数据" message:_message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonInde{
    
    switch (buttonInde) {
        case 0:
            _message = d0;
            break;
        case 1:
            _message = d1;
            //[self showMsg:d1];
            break;
        case 2:
            _message = d2;
            //[self showMsg:d2];
            break;
        case 3:
            _message = d3;
            //[self showMsg:d3];
            break;
        case 4:
            _message = d4;
            //[self showMsg:d4];
            break;
        case 5:
            _message = d5;
            //[self showMsg:d5];
            break;
        case 6:
            _message = d6;
            //[self showMsg:d6];
            break;
        case 7:
            _message = d7;
            //[self showMsg:d7];
            break;
        case 8:
            _message = d8;
            //[self showMsg:d8];
            break;
        case 9:
            _message = d9;
            //[self showMsg:d9];
            break;
    }
    NSLog(@"Home主页选择了数据%@",_message);
    
    //NSDictionary *dic = [[NSDictionary alloc]init];
    //dic = @{@"data":message};
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"dataSelect" object:self userInfo: dic];
    //NSLog(@"%@",dic);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"按钮下标AtIndex:%ld",(long)buttonIndex);//测试时候使用
}
//回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
