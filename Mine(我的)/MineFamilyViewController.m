//
//  MineFamilyViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "MineFamilyViewController.h"
#import "MineTableViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "NetWorkTool.h"
#import "MineViewController.h"


@interface MineFamilyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;//设置属性tableView
@property(nonatomic,strong)NSArray *datas;//设置属性datas表示数据的数量
@property(nonatomic,strong)NSDictionary *user;
@end

@implementation MineFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"家庭成员信息";
//    self.navigationController.title = @"家庭成员信息";
    self.title =@"家庭成员信息";
    UIBarButtonItem *changeBtn=[[UIBarButtonItem alloc]initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(changeUserClick:)];
    self.navigationItem.rightBarButtonItem=changeBtn;
    //设置一个 UITableViewStyleGrouped 形式的 tableview 分组
    CGRect c1 =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:c1 style:UITableViewStylePlain];//初始化
    self.automaticallyAdjustsScrollViewInsets = YES;
    //行高
    self.tableView.rowHeight = 50;
    self.tableView.center = self.view.center;
    //把tableview添加到view中
    [self.view addSubview:self.tableView];
    //实现tableview代理协议
    self.tableView.delegate = self;//实现tableview的delegate代理协议
    self.tableView.dataSource = self;//实现tableview的dataSource代理协议
    //设置tableView背景色backgroundColor为颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    //注册ResultTableViewCell
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"FamilyCell"];
    
    //新建一个path对象，通过plist文件中数组字典获取变化的首页数据，后期通过网络获取并解析 pathForResource:@"result" ofType:@"plist"  pathForAuxiliaryExecutable:@"result.plist"
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    //self.datas = [NSArray arrayWithContentsOfFile:path];//字典中的数据转数组
    //self.datas = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];//字典中的数据转数组再转可变数组
    //数据后期通过字典转模型
    self.datas = [MineModel mj_objectArrayWithFilename:@"user.plist"];
    //NSLog(@"%@",self.datas);//查看字典转模型对象内容
    [self loadNetData];//先网络请求加载下数据
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"结果页上拉刷新中");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNetData];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}
//notification实现传递 cell 的值
-(void)changeUserClick:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserClick" object:self userInfo: _user];
}
//更新家人列表
-(void)loadNetData{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userInfo objectForKey:@"UserName"];
    NSString *passWord = [userInfo objectForKey:@"PassWord"];
    NSLog(@"家人页面获取信息userName:%@ userName:%@",userName,passWord);
    NSDictionary *p = @{@"username":userName};
    [NetWorkTool familyDataNetParm:p Success:^(NSArray *models) {
        self.datas = [NSMutableArray arrayWithArray:models];
        NSLog(@"获取到的家人数据为：%@",self.datas);
        [self.tableView reloadData];
    } Failture:^(NSError *error) {
        NSLog(@"获取家人列表失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取结果列表失败" message:@"请检查网络"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

//返回指定的 section的header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //信号栏20 导航栏44 section12
    if (section == 0) {
        return 40;
    }
    return 10;
}
//返回指定的 section header 的view，如果没有，这个函数可以不返回view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
        label.text = @"选择其他成员切换";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

#pragma mark -- 数据源方法 tableview 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
#pragma mark -- 数据源方法 tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell * cell = (MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FamilyCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FamilyCell"];
    }
    _mine = self.datas[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:_mine.nick];
    cell.titleView.text = _mine.nick;
//    cell.iconView.image = [UIImage imageNamed:self.datas[indexPath.row][@"head"]];//设置图片
//    cell.titleView.text = [NSString stringWithFormat:@"%@",self.datas[indexPath.row][@"user"]];//设置标题
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
    //NSLog(@"点击了%@",self.datas[indexPath.row][@"user"]);//当使用字典转对象后就不能这样了
    _user = [self.datas[indexPath.row] mj_keyValues];//模型转字典
    NSLog(@"Model 转字典：%@",_user);
}

@end
