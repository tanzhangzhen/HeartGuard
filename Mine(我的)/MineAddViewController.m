//
//  MineAddViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "MineAddViewController.h"

@interface MineAddViewController ()

@end

@implementation MineAddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _phone.text = [userInfo objectForKey:@"UserName"];
    [_headImage setImage:[UIImage imageNamed:[userInfo objectForKey:@"HeadLable"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    //设置导航栏的颜色-全局,当前页navgation隐藏
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    //确定scrollView能滚动多大范围CGRectGetMaxY(self.view.frame)+10
    self.scrollView.contentSize=CGSizeMake(320,500);
    //在scrollView周边增加滚动区域top为负主要是 ios7显示问题
    self.scrollView.contentInset=UIEdgeInsetsMake(-60, 0, 49, 0);
    //设置scrollView里的控件的移动位置
    self.scrollView.contentOffset=CGPointMake(0, -60);
    self.view.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1];
    if (_mine.tag == 1) {
        [_save setTitle:@"删除当前用户" forState: UIControlStateNormal];
        [self.headImage setImage:[UIImage imageNamed:_mine.nick]];
        _phone.text = _mine.username;
        self.phone.text = _mine.username;
        self.name.text = _mine.nick;
        self.birth.text = _mine.birthday;
        self.high.text = _mine.high;
        self.weight.text = _mine.weight;
    }
    [self.headImage setImage:[UIImage imageNamed:@"天意"]];
}


//我的家页面请求网络查到当前用户信息
-(void)addFamilyNetData{
    NSDictionary *p = @{@"username":_phone.text,@"nick":_name.text,@"gender":@"男",@"birthday":_birth.text,@"high":_high.text,@"weight":_weight.text,@"familygroup":@"否"};
    [NetWorkTool addFamilyNetParm:p Success:^(MineModel *result) {
        NSLog(@"%@",result);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result.title message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        MineFamilyViewController *family = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"family"];
        [family loadNetData];
        [self.navigationController pushViewController:family animated:YES];
        
    } Failture:^(NSError *error) {
        NSLog(@"添加家人信息失败%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加家人信息失败,请检查网络" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
-(void)delCuiFamilyNetData{
    if([_name.text  isEqual: @"天意"]||[_name.text  isEqual: @"小冠"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前用户为用户组主用户，不允许删除" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSDictionary *p = @{@"username":_phone.text,@"nick":_name.text,@"gender":@"男",@"birthday":_birth.text,@"high":_high.text,@"weight":_weight.text};
        [NetWorkTool delCuiFamilyNetData:p Success:^(MineModel *result) {
            NSLog(@"%@",result);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户删除成功，请选择用户切换" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            MineFamilyViewController *family = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"family"];
            [family loadNetData];
            [self.navigationController pushViewController:family animated:YES];
            
        } Failture:^(NSError *error) {
            NSLog(@"删除家人信息失败%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除家人信息失败,请检查网络" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

-(void)clickbackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//从上个页面 push 过来的在 set 方法里面设置没用需要在前边调用 mine 里面有数据 赋值后_mine 也有数据，但是就是更新不到界面上，要在viewWillAppear设置
-(void)setMine:(MineModel *)mine{
    _mine = mine;
    [_headImage setImage:[UIImage imageNamed:_mine.nick]];
    _phone.text = _mine.username;
    _name.text = _mine.nick;
    _high.text = _mine.high;
    _weight.text = _mine.weight;
}
#pragma mark --界面出现加载详情数据
//回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

- (IBAction)save:(id)sender {
    if (_mine.tag == 1) {
        [self delCuiFamilyNetData];//删除当前用户
    }else{
        [self addFamilyNetData];//新增
    }
}
@end
