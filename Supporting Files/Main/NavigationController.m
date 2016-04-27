//
//  NavigationController.m
//  HeartGuard
//
//  Created by MM on 16/3/14.
//  Copyright © 2016年 mm. All rights reserved.
//
//橘色[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//蓝色[UIColor colorWithRed:216/255.0f green:209/255.0f blue:192/255.0f alpha:1]
//登陆按钮背景蓝色[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:216/255.0f green:209/255.0f blue:192/255.0f alpha:1]];

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条样式  默认的时白色半透明（有点灰的感觉），
    self.navigationBar.barStyle=UIBarStyleDefault;
    
    //设置导航条背景颜色，也是半透明玻璃状的颜色效果
    self.navigationBar.backgroundColor=[UIColor blackColor];//背景浅色效果
    
    //信号栏隐藏[self setEdgesForExtendedLayout:UIRectEdgeNone];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.navigationBar.translucent = NO;
    
    //设置NavigationBar文字颜色
    //[[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];//没什么效果
//    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1],NSForegroundColorAttributeName,nil];//橘黄色
//    [self.navigationBar setTitleTextAttributes:attributes];
    
    //设置全局的title文字@{}代表Dictionary
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //设置导航条背景图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    //如果图片太大会向上扩展侵占状态栏的位置，在状态栏下方显示 clipsToBounds把多余的图片裁剪掉
    self.navigationBar.clipsToBounds=YES;
    
    //打印导航条宽高，x是0很明显，y是0，上面20状态栏的高度，高44，宽320，如果是Retina屏幕，那么宽和高@2x即可分别是750和88
    CGFloat navH = self.navigationBar.frame.size.height;
    CGFloat navW = self.navigationBar.frame.size.width;
    CGFloat navX = self.navigationBar.frame.origin.x;
    CGFloat navY = self.navigationBar.frame.origin.y;
    NSLog(@"Navigation的frame 高:%f宽:%fx:%fy:%f", navH, navW, navX, navY);
    //隐藏导航条 
    self.navigationBarHidden=NO;
    [self setNavigationBarHidden:NO animated:YES];
    
/*    
    //自定义子页面返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"ic_launcher.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
*/
    //自定义返回箭头
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickbackBtn)];
    //    [backBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    //    [backBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    //    backBtn.tintColor=[UIColor blueColor];//返回箭头颜色
    //    [self.navigationItem setLeftBarButtonItem:backBtn];

/*
    //1.navigationItem与 navigationController 同级，在 navigationController 中设置无效
    //2.把控件添加到当前的view中，设置隐藏导航时候无法隐藏控件
    //自定义导航栏navigationItem导航条添加任意视图，放到数组中，显示顺序，左边：按数组顺序从左向右；右边：按数组顺序从右向左
    UIImageView *navImage = [[UIImageView alloc]init];
    [navImage setImage:[UIImage imageNamed:@"ic_launcher"]];
    navImage.frame = CGRectMake(15, 25, 30, 30);//y 坐标要加10
    [self.view addSubview:navImage];
    UILabel *navLabel = [[UILabel alloc]init];
    navLabel.text = @"智能云心电仪";
    navLabel.textColor = [UIColor whiteColor];
    navLabel.frame = CGRectMake(navImage.frame.origin.x+navImage.frame.size.width+10 ,navH/2+10, 120, 20);
    [self.view addSubview:navLabel];
    UIButton *navButton = [[UIButton alloc]init];
    [navButton setImage:[UIImage imageNamed:@"ic_family"] forState:UIControlStateNormal];
    navButton.frame = CGRectMake(navW-47, navImage.frame.origin.y+5, 30, 20);
    [navButton addTarget:self action:@selector(rightOnclick) forControlEvents:UIControlEventTouchDown];//点击事件
    [self.view addSubview:navButton];
*/
}

-(void)rightOnclick{
    //[self.navigationController pushViewController:[[ECGViewController alloc] init] animated:YES];
    self.tabBarController.selectedIndex = 2;
    self.view.backgroundColor=[UIColor purpleColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
