//
//  MineSetViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "MineSetViewController.h"

@interface MineSetViewController ()
{
    NSString * message;//消息内容
    int tag;//消息内容标识
    UITextField * pass;//密码文本
}
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *phone;
- (IBAction)quitBtn:(id)sender;
- (IBAction)ChangePWD:(id)sender;
- (IBAction)keepPass:(id)sender;
- (IBAction)autoLogon:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *keepPassSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@end

@implementation MineSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    message = nil;
    tag = 1;
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    //获取 switch 状态
    BOOL passStatus = _keepPassSwitch.on;
    BOOL loginStatus = _keepPassSwitch.on;
    [_keepPassSwitch setOn:YES animated:YES];
    [_autoLoginSwitch setOn:NO animated:YES];

    
    // Do any additional setup after loading the view.
}
//修改密码
-(void)changePassNetData{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userInfo objectForKey:@"UserName"];
    NSString *passWord = [userInfo objectForKey:@"PassWord"];
    NSDictionary *p = @{@"username":userName,@"old_password":passWord,@"new_password":pass.text,@"ok_new_password":pass.text};
    [NetWorkTool changePassNetParm:p Success:^(MineModel *result) {
        NSLog(@"密码修改成功，修改后的密码为：%@",pass.text);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改成功" message:nil  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } Failture:^(NSError *error) {
        NSLog(@"密码修改失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改失败,请检查网络" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
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

- (IBAction)quitBtn:(id)sender {
    self.view.backgroundColor=[UIColor whiteColor];
    message = @"确定退出程序吗？";
    tag = 1;
    [self showMsg:message];
}

- (IBAction)ChangePWD:(id)sender {
    message = @"请输入新密码";
    tag = 2;
    [self showMsg:message];
}

-(void)showMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    if(tag == 1){//quitBtn退出按钮-确定直接 exit
        alert.alertViewStyle=UIAlertViewStyleDefault; //一般确定、取消窗口
    }else if (tag == 2) {//修改密码按钮-确定 无操作
        alert.alertViewStyle=UIAlertViewStyleSecureTextInput; //加密文本框
        pass = [alert textFieldAtIndex:0];
    }else{
        
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonInde{
    
    if(tag == 1){//标准取消
        if (buttonInde == 0) {
            exit(0);
        }
    }else if(tag == 2){//修改密码
        if (buttonInde == 0) {
            NSLog(@"修改后的密码为%@",pass.text);
            message = [@"修改后的密码为:" stringByAppendingString:pass.text];//字符串拼接
            tag = 3;
            [self showMsg:message];
            [self changePassNetData];
        }
    }else{
    
    }
}

- (IBAction)keepPass:(id)sender {
    BOOL passStatus = _keepPassSwitch.on;
    if(!passStatus){
        [_keepPassSwitch setOn:YES animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"keepPass" object:self];
    }
}

- (IBAction)autoLogon:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"autoLogon" object:self ];
    }else {
        
    }
}
@end
