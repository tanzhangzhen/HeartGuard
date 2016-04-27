//
//  NavigationViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/14.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建一个按钮，点击后进入子视图控制器，相当于进入子页面
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame=CGRectMake(38, 100, 300, 30);
    [btn1 setTitle:@"jump to secondviewcontroller" forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor redColor];
    [btn1 addTarget:self action:@selector(jumpTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    //设置导航条样式
    //默认的时白色半透明（有点灰的感觉），UIBarStyleBlack,UIBarStyleBlackTranslucent,UIBarStyleBlackOpaque都是黑色半透明，其实它们有的时不透明有的时透明有的时半透明，但不知为何无效果
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    //设置导航条背景颜色，也是半透明玻璃状的颜色效果
    self.navigationController.navigationBar.backgroundColor=[UIColor orangeColor];
    //可以用self.navigationController.navigationBar.frame.size获得高宽，还有self.navigationController.navigationBar.frame.origin获得x和y
    //高44，宽375，如果是Retina屏幕，那么宽和高@2x即可分别是750和88
    //x是0很明显，y是20，其中上面20就是留给状态栏的高度
    NSLog(@"%f",self.navigationController.navigationBar.frame.origin.y);
    
    //隐藏导航条，由此点击进入其他视图时导航条也会被隐藏，默认是NO
    //以下一个直接给navigationBarHidden赋值，一个调用方法，都是一样的，下面一个多了一个动画选项而已
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //给导航条增加背景图片，其中forBarMetrics有点类似于按钮的for state状态，即什么状态下显示
    //UIBarMetricsDefault-竖屏横屏都有，横屏导航条变宽，则自动repeat图片
    //UIBarMetricsCompact-竖屏没有，横屏有，相当于之前老iOS版本里地UIBarMetricsLandscapePhone
    //UIBarMetricsCompactPrompt和UIBarMetricsDefaultPrompt暂时不知道用处，官方解释是Applicable only in bars with the prompt property, such as UINavigationBar and UISearchBar，以后遇到时再细说
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"big2.png"] forBarMetrics:UIBarMetricsDefault];
    //如果图片太大会向上扩展侵占状态栏的位置，在状态栏下方显示
    //clipsToBounds就是把多余的图片裁剪掉
    self.navigationController.navigationBar.clipsToBounds=YES;
    
    //设置导航标题
    [self.navigationItem setTitle:@"主页"];
    
    //设置导航标题视图，就是这一块可以加载任意一种视图
    //视图的x和y无效，视图上下左右居中显示在标题的位置
    UIView *textView1=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    textView1.backgroundColor=[UIColor whiteColor];
    [self.navigationItem setTitleView:textView1];
    
    //设置导航条的左右按钮
    //先实例化创建一个UIBarButtonItem，然后把这个按钮赋值给self.navigationItem.leftBarButtonItem即可
    //初始化文字的按钮类型有UIBarButtonItemStylePlain和UIBarButtonItemStyleDone两种类型，区别貌似不大
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc]initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:self action:@selector(changeColor)];
    self.navigationItem.leftBarButtonItem=barBtn1;
    
    //我们还可以在左边和右边加不止一个按钮，,且可以添加任意视图，以右边为例
    //添加多个其实就是rightBarButtonItems属性，注意还有一个rightBarButtonItem，前者是赋予一个UIBarButtonItem对象数组，所以可以显示多个。后者被赋值一个UIBarButtonItem对象，所以只能显示一个
    //显示顺序，左边：按数组顺序从左向右；右边：按数组顺序从右向左
    //可以初始化成系统自带的一些barButton，比如UIBarButtonSystemItemCamera是摄像机，还有Done，Reply等等，会显示成一个icon图标
    //还可以initWithImage初始化成图片
    //还可以自定义，可以是任意一个UIView
    UIBarButtonItem *barBtn2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(changeColor2)];
    UIBarButtonItem *barBtn3=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo-40@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(changeColor3)];
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
//    view4.backgroundColor=[UIColor blackColor];
    UIBarButtonItem *barBtn4=[[UIBarButtonItem alloc]initWithCustomView:view4];
    NSArray *arr1=[[NSArray alloc]initWithObjects:barBtn2,barBtn3,barBtn4, nil];
    self.navigationItem.rightBarButtonItems=arr1;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)changeColor{
    self.view.backgroundColor=[UIColor purpleColor];
}
-(void)changeColor2{
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)changeColor3{
    self.view.backgroundColor=[UIColor orangeColor];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navButtonclick:(UIBarButtonItem *)button{
    //    [self.navigationController pushViewController:[[MineViewController alloc] init] animated:YES];
    self.tabBarController.selectedIndex = 2;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 失败弹窗
-(void)showFailedMessage{
    NSString * messaeg = @"正在开发中，敬请期待！";
    //便利构造器初始化方法（+类方法）
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messaeg preferredStyle:UIAlertControllerStyleAlert];
    //按钮标题，按钮样式，点击事件 ----- 知识点：Block
    UIAlertAction * sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    //把按钮添加到弹出框
    [alertController addAction:sureAction];
    //弹出对话框
    [self presentViewController:alertController animated:YES completion:nil];
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
