//
//  MineViewController.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/19.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "ResultViewController.h"
#import "DetailViewController.h"
#import "ECGViewController.h"
#import "LoginViewController.h"
#import "MineFamilyViewController.h"
#import "NetWorkTool.h"
#import "MJExtension.h"
#import "MineAddViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation MineViewController
-(void)setHeadLable:(UILabel *)headLable{
}
//只有在页面init的时候会调用一次
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的家庭";
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    //设置一个 UITableViewStyleGrouped 形式的 tableview 分组
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];//初始化
    self.automaticallyAdjustsScrollViewInsets = YES;
    //self.tableView.rowHeight = 50;//行高
    self.tableView.center = self.view.center;
    //把tableview添加到view中
    [self.view addSubview:self.tableView];
    //实现tableview代理协议
    self.tableView.delegate = self;//实现tableview的delegate代理协议
    self.tableView.dataSource = self;//实现tableview的dataSource代理协议
    //设置tableView背景色backgroundColor为颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    //注册ResultTableViewCell
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineCell"];
    //新建一个path对象，通过plist文件中数组字典获取变化的首页数据，后期通过网络获取并解析 pathForResource:@"result" ofType:@"plist"  pathForAuxiliaryExecutable:@"result.plist"
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mine" ofType:@"plist"];
    self.datas = [NSArray arrayWithContentsOfFile:path];//字典中的数据转数组
    //self.datas = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];//字典中的数据转数组再转可变数组
    //数据后期通过字典转模型 self.datas = [MineModel mj_objectArrayWithFilename:@"result.plist"];
    //NSLog(@"%@",self.datas);//查看字典转模型对象内容
    //登陆页面已做网络请求，获取到当前主用户昵称头像
    _userInfo = [NSUserDefaults standardUserDefaults];//_userInfo需要先做初始化
    _headImage.image = [UIImage imageNamed:[_userInfo objectForKey:@"MainUser"]];
    _headLable.text = [_userInfo objectForKey:@"MainUser"];
    [self loadNetData];//网络请求查询当前用户信息
    [self creatHeadView];//创建第一行 cell 头部
}
//每次都会调viewWillAppear和viewDidAppear方法
-(void)viewWillAppear:(BOOL)animated{
    //切换用户发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChange:) name:@"changeUserClick" object:nil];
}

//notification实现点击事件
-(void)userChange:(NSNotification *)note{
    [_curUserBtn setNeedsDisplay];
    NSLog(@"从MineFamilyController传过来的值为: %@", [note userInfo]);
    //把传过来的值给 Model
    [_mine mj_setKeyValues:[note userInfo]];
    //头像昵称切换
    _headImage.image = [UIImage imageNamed:[note userInfo][@"nick"]];
    _headLable.text = [note userInfo][@"nick"];
    [_userInfo setObject:[note userInfo][@"nick"] forKey:@"CurrUser"];//保存头像
    //字符串拼接
    NSString *message = [@"用户切换成功，当前用户为:" stringByAppendingString:_mine.nick];
    NSLog(@"%@",message);
    //执行返回我的家界面
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatHeadView{
    //第一个 cell 自定义按钮
    _curUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _curUserBtn.frame = CGRectMake(0, 73, self.view.frame.size.width, 60);
    _curUserBtn.backgroundColor = [UIColor whiteColor];
    [_curUserBtn addTarget:self action:@selector(curUserBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_curUserBtn];
    //头像、昵称
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    UILabel * l1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 90, 20)];
    l1.text =@"当前用户:";
    l1.textColor = [UIColor blackColor];
    _headLable = [[UILabel alloc]initWithFrame:CGRectMake(l1.frame.origin.x+l1.frame.size.width, l1.frame.origin.y, 60, 20)];
    _headLable.textColor = [UIColor redColor];
    //如果头像和昵称为空就加载登陆时候主用户的信息
    if (_headLable.text == nil) {
        [_headImage setImage:[UIImage imageNamed:[_userInfo objectForKey:@"MainUser"]]];
        [_headLable setText:[_userInfo objectForKey:@"MainUser"]];
    }else{
        _headImage.image = [UIImage imageNamed:_mine.image];
        _headLable.text = _mine.nick;
    }
    [_curUserBtn addSubview:_headImage];
    [_curUserBtn addSubview:l1];
    [_curUserBtn addSubview:_headLable];
}
//点击当前用户跳转到详细信息界面 我的家页面网络请求 查到当前用户信息
-(void)curUserBtn{
    //如果是切换过来的页面,会传过来一个值给 model从 model 取值 push 给下一个页面
    MineAddViewController *mineDetail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mineDetail"];
    _mine.tag = 1;
    mineDetail.mine = _mine;
    [self.navigationController pushViewController:mineDetail animated:YES];
}
//我的家页面网络请求 查询当前用户信息
-(void)loadNetData{
    NSDictionary *p = @{@"username":[_userInfo objectForKey:@"UserName"]};
    [NetWorkTool mineDataNetParm:p Success:^(MineModel *mine) {
        _mine = mine;
        [self.tableView reloadData];
    } Failture:^(NSError *error) {
        NSLog(@"获取当前用户详细信息失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取信息失败,请检查网络" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
//返回有多少个Sections 设置tabView的组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.datas.count;
}
//返回对应的section有多少个元素，也就是多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionData = self.datas[section];
    return sectionData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionData = self.datas[indexPath.section];
    NSDictionary *itemData = sectionData[indexPath.row];
    if([itemData[@"title"]isEqualToString:@"当前用户"]){
        NSLog(@"60------");
        return 55;
    }
    return 50;
}
//返回指定的 section的header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //信号栏20 导航栏44 section12
    if (section == 0) {
        return 142;
    }
    return 8;
}
//返回指定的 section的footer的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

//返回指定的 section header 的view，如果没有，这个函数可以不返回view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //[self creatHeadView];
    }
    return nil;
}

//设置tabView每行显示的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *sectionData = self.datas[indexPath.section];
    NSDictionary *itemData = sectionData[indexPath.row];
    MineTableViewCell * cell = (MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineCell"];
    }
    cell.iconView.image = [UIImage imageNamed:itemData[@"icon"]];//设置图片
    cell.titleView.text = [NSString stringWithFormat:@"%@",itemData[@"title"]];//设置标题
    return cell;
}
/*页面跳转
 1.首先判断cell属于哪一个section[indexPath section]
 2.再得到section中的row [indexPath row]
 3.if([indexPath row]==0)
 {
 }else if([indexPath row]==1)
 {
 }
 可以用 [self performSegueWithIdentifier:@"Detail" sender:indexPath];
 可以用 [self.navigationController pushViewController:vc animated:YES];
 可以用 [self presentModalViewController:ecg animated:YES];
 self.tabBarController.selectedIndex = 2;
 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
 
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"我被点击了%@",self.datas[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击跳动效果
    NSArray *sectionData = self.datas[indexPath.section];
    NSDictionary *itemData = sectionData[indexPath.row];
    NSLog(@"点击了:%@",itemData[@"title"]);
    NSString * item = itemData[@"title"];
    if([item isEqualToString:@"家人信息"]){
        [self performSegueWithIdentifier:@"family" sender:indexPath];
    }else if ([item isEqualToString:@"添加家人"]){
        [self performSegueWithIdentifier:@"add" sender:indexPath];
    }else if ([item isEqualToString:@"账户设置"]){
        [self performSegueWithIdentifier:@"set" sender:indexPath];
    }else if ([item isEqualToString:@"我的心电仪"]){
        ECGViewController *ecg = [[ECGViewController alloc]init];
        [self.navigationController pushViewController:ecg animated:YES];
    }else if ([item isEqualToString:@"关于智能云心电仪"]){
        [self performSegueWithIdentifier:@"about" sender:indexPath];
    }
}




@end
