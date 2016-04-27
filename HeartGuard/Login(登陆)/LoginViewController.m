//
//  LoginViewController.m
//  智能云心电仪
//
//  Created by DGSCDI on 15/10/18.
//  Copyright © 2015年 com.dgut.edu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *sinaBtn;
    NSString * l_Message;
    NSUserDefaults *userInfo;
}
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    //设置导航栏的颜色-全局,当前页navgation隐藏
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
    l_Message = nil;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keepPass) name:@"keepPass" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogon) name:@"autoLogon" object:nil];
    userInfo = [NSUserDefaults standardUserDefaults];
    user.text = [userInfo objectForKey:@"UserName"];
    pwd.text = [userInfo objectForKey:@"PassWord"];

}
-(void)keepPass{
    user.text = [userInfo objectForKey:@"UserName"];
    pwd.text = [userInfo objectForKey:@"PassWord"];
}
-(void)autoLogon{
    [self landClick];
}

//自定义view
-(void)createView
{
    #define Start_X 60.0f            // 第一个按钮的X坐标
    #define Start_Y 440.0f           // 第一个按钮的Y坐标
    #define Width_Space 50.0f        // 2个按钮之间的横间距
    #define Height_Space 20.0f       // 竖间距
    #define Button_Height 50.0f      // 高
    #define Button_Width 50.0f       // 宽
    
    UILabel *iconlabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-130, 30, 300, 100)];
    iconlabel.text=@"HeartGuard";
    iconlabel.textColor=[UIColor blueColor];
    iconlabel.textAlignment = UITextAutocapitalizationTypeAllCharacters;
    iconlabel.font=[UIFont systemFontOfSize:50];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, iconlabel.frame.origin.x+80, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    user =[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:15] placeholder:@"手机号13751338740"];
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:15]  placeholder:@"密   码13751338740" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd.keyboardType=UIKeyboardTypeNumberPad;
    pwd.secureTextEntry=YES;//密文样式

    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.origin.y+bgView.frame.size.height+10, self.view.frame.size.width-30, 40) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:20] target:self action:@selector(landClick)];
    landBtn.backgroundColor= [UIColor blueColor];
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn=[self createButtonFrame:CGRectMake(15, landBtn.frame.origin.y+landBtn.frame.size.height+10, 70, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor blueColor] font:[UIFont systemFontOfSize:15] target:self action:@selector(registration:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width-85, newUserBtn.frame.origin.y, 60, 30) backImageName:nil title:@"找回密码" titleColor:[UIColor blueColor] font:[UIFont systemFontOfSize:15] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];

    //第三方账号快速登录一栏
    UIImageView *line1=[self createImageViewFrame:CGRectMake(2, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line2=[self createImageViewFrame:CGRectMake(self.view.frame.size.width-100-4, line1.frame.origin.y, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-140)/2+5, line1.frame.origin.y-10, 140, 21)];
    label.text=@"第三方账号快速登录";
    label.textColor=[UIColor grayColor];
    label.textAlignment = UITextAutocapitalizationTypeAllCharacters;
    label.font=[UIFont systemFontOfSize:14];
    //QQ、微信、微博快捷登陆
    QQBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2-100, line1.frame.origin.y+20, 50, 50)];
    //QQBtn.tag = UMSocialSnsTypeMobileQQ;
    QQBtn.layer.cornerRadius=25;
    QQBtn=[self createButtonFrame:QQBtn.frame backImageName:@"ic_landing_qq" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, QQBtn.frame.origin.y, 50, 50)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    weixinBtn.layer.cornerRadius=25;
    weixinBtn=[self createButtonFrame:weixinBtn.frame backImageName:@"ic_landing_wechat" title:nil titleColor:nil font:nil target:self action:@selector(onClickWX:)];
    sinaBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2+100, QQBtn.frame.origin.y, 50, 50)];
    //xinlangBtn.tag = UMSocialSnsTypeSina;
    sinaBtn.layer.cornerRadius=25;
    sinaBtn=[self createButtonFrame:sinaBtn.frame backImageName:@"ic_landing_microblog" title:nil titleColor:nil font:nil target:self action:@selector(onClickSina:)];
    
    //HeartGuart文本Label
    [self.view addSubview:iconlabel];
    //bgview 用户名、密码框
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line];
    //登录、注册、忘记密码
    [self.view addSubview:landBtn];
    [self.view addSubview:newUserBtn];
    [self.view addSubview:forgotPwdBtn];
    //第三方账号快速登录一栏
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:label];
    [self.view addSubview:weixinBtn];
    [self.view addSubview:QQBtn];
    [self.view addSubview:sinaBtn];
}
#pragma mark - 事件处理
- (void)onClickQQ:(UIButton *)button
{
}
- (void)onClickWX:(UIButton *)button
{
}
- (void)onClickSina:(UIButton *)button
{
}
//登录
-(void)landClick
{
    NSString *name = user.text;
    NSString *pass = pwd.text;
    if ([name isEqualToString:@""])
    {
        l_Message = @"亲,用户名为空,请输入用户名";
        NSLog(@"请输入用户名！user:%@pass:%@msg%@",name,pass,l_Message);
    }
    else if (name.length < 11)
    {
        l_Message = @"亲,您输入的手机号码格式不正确";
        NSLog(@"手机号码格式不正确！user:%@pass:%@msg%@",name,pass,l_Message);
    }
    else if ([pass isEqualToString:@""])
    {
        l_Message = @"亲,请输入密码";
        NSLog(@"请输入密码！user:%@pass:%@msg%@",name,pass,l_Message);
    }
    else if (pass.length < 6)
    {
        l_Message = @"亲,密码长度至少六位";
        NSLog(@"密码长度至少六位!user:%@pass:%@msg%@",name,pass,l_Message);
    }
    
    //云心电仪登陆请求
    NSDictionary *dic = @{@"username":name,@"password":pass};
    [NetWorkTool loginWithParamHeart:dic Success:^(UserLoginModel *result) {
        //存在的问题：loginWithParmHeart 方法跳着走的，第一次执行没有返回数据给 model，第二次才返回，所以第一次的 info 是空的，l——message也是空的
        NSString *lt = result.title;
        NSString *lsucc = @"登录成功！";
        NSString *lerro = @"错误的用户名或密码";
        if ([lt isEqualToString:lsucc]) {
            NSLog(@"登陆界面：%@",lsucc);
            //将用户名、密码存储到 NSUserDefaults 中 保存到result中再看结果页面拿到的数据为空
            [userInfo setObject:name forKey:@"UserName"];
            [userInfo setObject:pass forKey:@"PassWord"];
            [userInfo synchronize];
            //成功登陆后跳转到Storyboard
            UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *controller =  [mainBoard instantiateViewControllerWithIdentifier:@"main"];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = controller;
            [self loadNetData];//登陆成功后获取用户组主用户昵称头像
        }else if([lt isEqualToString:lerro]){
            l_Message = lerro;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:l_Message  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"登陆界面：%@",lerro);
        }
    } Failture:^(NSError *error) {
        l_Message = @"网络请求失败，请检查网络";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:l_Message  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"登陆界面：登陆失败，错误原因: %@", error);
    }];
    
    //成功登陆后跳转到Storyboard
//    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *controller =  [mainBoard instantiateViewControllerWithIdentifier:@"main"];
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    delegate.window.rootViewController = controller;
    
}
//登陆成功后获取用户组主用户昵称头像
-(void)loadNetData{
    NSDictionary *p = @{@"username":[userInfo objectForKey:@"UserName"]};
    [NetWorkTool mineDataNetParm:p Success:^(MineModel *mine) {
        [userInfo setObject:mine.nick forKey:@"MainUser"];//保存头像、昵称
        [userInfo synchronize];
        NSLog(@"登陆界面登陆成功后保存用户名:%@昵称:%@",[userInfo objectForKey:@"UserName"],[userInfo objectForKey:@"MainUser"]);
    } Failture:^(NSError *error) {
        NSLog(@"登陆页面获取主用户昵称头像失败");
    }];
}

//快速注册
-(void)registration:(UIButton *)button
{
    [self.navigationController pushViewController:[[Register1ViewController alloc]init] animated:YES];
}
//忘记密码
-(void)fogetPwd:(UIButton *)button
{
    [self.navigationController pushViewController:[[RetrievePwd1ViewController alloc]init] animated:YES];
}
//回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//退出事件
-(void)quitBtn:(UIButton *)button
{
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}

//弹出窗口 iOS7.0弹出会飞掉
- (void)showMsgAlert :(NSString *)msg{
    //一个确定按钮
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];//按钮标题，按钮样式，点击事件
//    [alert addAction:action];//把按钮添加到弹出框
//    [self presentViewController:alert animated:YES completion:nil];//弹出对话框
    //两个确定、取消按钮
    NSString *title = NSLocalizedString(@"温馨提示", nil);
    NSString *message = msg;
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 自定义控件frame

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

#pragma mark - 自定义工具
//手机号格式化
-(NSString*)getHiddenStringWithPhoneNumber:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    
    if (number.length<countHiiden) {
        return number;
    }
    NSInteger count=countHiiden;
    NSInteger leftCount=number.length/2-count/2;
    NSString *xings=@"";
    for (int i=0; i<count; i++) {
        xings=[NSString stringWithFormat:@"%@%@",xings,@"*"];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(leftCount, count) withString:xings];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

//手机号格式化后还原
-(NSString*)getHiddenStringWithPhoneNumber1:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    if (number.length<countHiiden) {
        return number;
    }
//    NSString *xings=@"";
    for (int i=0; i<1; i++) {
        //xings=[NSString stringWithFormat:@"%@",[CheckTools getUser]];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@""];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//界面跳转
//[self.navigationController popViewControllerAnimated:YES];//返回
//[self.navigationController pushViewController:[[ECGViewController alloc]init] animated:YES];


//    //搜房网登陆请求接口数据
//    //NSDictionary *dic = @{@"number":user.text,@"password":pwd.text};
//    NSDictionary *dic = @{@"number":@"18520787995",@"password":@"121212"};
//    [NetWorkTool loginWithParam:dic success:^(UserLoginModel *result) {
//        NSLog(@"登陆界面：获取用户名密码成功，登陆成功");
//        //保存服务器返回的数据user_id和md5_code
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:result.md5_code forKey:@"md5_code"];
//        [defaults setObject:result.user_id forKey:@"user_id"];
//        [defaults synchronize];
//        //成功登陆后跳转到Storyboard
//        UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *controller =  [mainBoard instantiateViewControllerWithIdentifier:@"main"];
//        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//        delegate.window.rootViewController = controller;
//
//    } failture:^(NSError *error) {
//        NSLog(@"登陆界面：登陆失败，错误原因: %@", error);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];

/*
 //验证账号密码与数据库存储的是否相同
 for (int i = 0; i<self.dataSourse.count; i++) {
 //NSLog(@"%@",self.dataSourse[i][@"title"]);
 if ([name isEqualToString:self.dataSourse[i][@"phone"]]&&
 [pass isEqualToString:self.dataSourse[i][@"pass"]]) {
 //            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
 //            [user setObject:name forKey:@"userName"];
 
 //保存服务器返回的数据user_id和md5_code
 NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
 [defaults setObject:user forKey:@"user"];
 [defaults setObject:pwd forKey:@"pass"];
 [defaults synchronize];
 
*/
@end
