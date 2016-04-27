//
//  MineAboutViewController.m
//  HeartGuard
//
//  Created by MM on 16/3/18.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "MineAboutViewController.h"

@interface MineAboutViewController()

- (IBAction)help:(id)sender;
- (IBAction)contact:(id)sender;
- (IBAction)introduce:(id)sender;

@end

@implementation MineAboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)help:(id)sender {
    
}

- (IBAction)contact:(id)sender {
    NSLog(@"联系我们");
    NSString * message = @"QQ:953357163";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"技术支持" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
}

- (IBAction)introduce:(id)sender {
    
}
@end
