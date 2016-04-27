//
//  Register1ViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/17.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "Register1ViewController.h"
#import "Register2ViewController.H"
#import "LoginViewController.h"

@interface Register1ViewController ()
{
    UIView *bgView;
    UITextField *phone;
    UITextField *code;
    UINavigationBar *customNavigationBar;
    UIButton *yzButton;
}

@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
//验证码
@property(copy, nonatomic) NSString *smsId;
@end

@implementation Register1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //
    self.title=@"注册1/3";
    self.navigationController.navigationBarHidden = NO;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    
    [self createTextFields];
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"请输入您的手机号码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    
    [self.view addSubview:label];
    
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    phone=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"11位手机号"];
    phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    phone.keyboardType=UIKeyboardTypeNumberPad;
    
    //phone.text=@"15527002684";
    
    code=[self createTextFielfFrame:CGRectMake(100, 60, 90, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"4位数字" ];
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    //code.text=@"mojun1992225";
    //密文样式
    code.secureTextEntry=YES;
    code.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"手机号";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=UITextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    
    UILabel *codelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    codelabel.text=@"验证码";
    codelabel.textColor=[UIColor blackColor];
    codelabel.textAlignment=UITextAlignmentLeft;
    codelabel.font=[UIFont systemFontOfSize:14];
    
    
    yzButton=[[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-100-20, 62, 100, 30)];
    //yzButton.layer.cornerRadius=3.0f;
    //yzButton.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yzButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    yzButton.font=[UIFont systemFontOfSize:13];
    [yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:yzButton];
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(next)];
    landBtn.backgroundColor=[UIColor blueColor];
    landBtn.layer.cornerRadius=5.0f;
    
    
    [bgView addSubview:phone];
    [bgView addSubview:code];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:codelabel];
    [bgView addSubview:line1];
    [self.view addSubview:landBtn];
    
}

- (void)getValidCode:(UIButton *)sender
{
    if ([phone.text isEqualToString:@""])
    {
        return;
    }
    else if (phone.text.length <11)
    {
        return;
    }
    _oUserPhoneNum =phone.text;
    //__weak MMZCHMViewController *weakSelf = self;
    sender.userInteractionEnabled = NO;
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
}

- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [yzButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [yzButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        yzButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lu秒后重新获取", self.timeCount];
        [yzButton setTitle:str forState:UIControlStateNormal];
        yzButton.userInteractionEnabled = NO;
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phone resignFirstResponder];
    
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

//验证码
-(void)next
{
    
    //    if ([phone.text isEqualToString:@""])
    //    {
    //        //[SVProgressHUD showInfoWithStatus:@"亲,请输入注册手机号码"];
    //        return;
    //    }
    //    else if (phone.text.length <11)
    //    {
    //        ///[SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
    //        return;
    //    }
    //    else if ([code.text isEqualToString:@""])
    //    {
    //        //[SVProgressHUD showInfoWithStatus:@"亲,请输入验证码"];
    //        return;
    //    }
    //    else if (self.smsId.length == 0)
    //    {
    //        //[SVProgressHUD showInfoWithStatus:@"验证码错误"];
    //        return;
    //   }
    
    [self.navigationController pushViewController:[[Register2ViewController alloc]init] animated:YES];
    
    
    
    
    
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
