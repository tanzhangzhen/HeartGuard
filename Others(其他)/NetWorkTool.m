
#import "NetWorkTool.h"

//一.自定义一个 网络请求 的方法,在NetWorkTool类实现,处理网络请求相关信息

//1.将返回来的json的中的ProjectList键取出来的值（数组）
//2.将数组里面的每一项封装为HourseInfo对象
//3.将全部的HourseInfo对象装在数组里面

//二.自定义一个 登陆传值 的方法loginWithParam,在NetWorkTool类实现,处理登陆传值相关信息

//1.将返回来的json的中的ProjectList键取出来的值（数组）
//2.将数组里面的每一项封装为HomeModel对象
//3.将全部的HomeModel对象装在数组里面

//网上找的测试地址
//https://alpha-api.app.net/stream/0/posts/stream/global
//找房通接口
//http://apinew.zhaofangtong.com/house/interface/i-zhaofangtong/4.0.6/zft_list_recommend.ashx
//搜房网登陆接口
//http://115.28.79.187/sfapp_dev/index.php?m=home&c=user&a=login&number=18520787995&password=121212
//搜房网首页接口
//http://115.28.79.187/sfapp_dev/index.php?m=home&c=building&a=get_list&user_id=1&md5_code=ed7b62d6135b2b5b420ea6f9e40673ad";//&city=东莞&page=1  搜房网首页列表数据



//云心电仪接口
//http://www.heartguard.cn:8080/HeartGuardServer/servlet/
//http://114.215.159.55:8080/HeartGuardServer/servlet/
//http://115.29.146.144:8080/HeartGuardServer/servlet/

//登陆请求
//CenterController?operation=login&format=json&username=13751338740&password=13751338740
//http://115.29.146.144:8080/HeartGuardServer/servlet/CenterController?operation=login&format=json&username=13751338740&password=13751338740
//注册请求
//CenterController?operation=regist&format=json&nick=天意&username=13751338740&password=13751338740&code=477415

//获取验证码请求
//SmsServlet?operation=sendcode&username=13592789639
//获取密码请求
//SmsServlet?/operation=sendpassword&username=13751338740

//获取用户，返回rate_grade
//ResultsController?/operation=queryrategrade&username=13751338740
//发送结果请求resultModel 中所有数据
//ResultsController?operation=addresult&username=13751338740&nick=tianyi&time=2016-03-28&
//查看结果
//ResultsController?operation=queryresult&username=13751338740

//获取用户信息请求，返回当前用户一条数据
//UserServlet?operation=userinfo&username=13751338740
//修改密码请求
//UserServlet?/operation=modifypassword&username=13751338740&old_password=13751338740&new_password=13751338740&ok_new_password=13751338740
//修改用户信息
//UserServlet?/operation=modifyuser/username=13751338740&nick=tianyi&gender=ss&birthday=&high=&weight

//查询所有家人请求
//FamilyController?operation=queryfamily&username=13751338740
//添加家人请求
//FamilyController?operation=addfamily&username=&nick&=&gender=&birthday=&high=&weight
//删除家人请求
//FamilyController?operation=deletefamily&username=13592789639&nick=tianyi



@implementation NetWorkTool


//http://115.29.146.144:8080/HeartGuardServer/servlet/CenterController?operation=login&format=json&username=13751338740&password=1234
//云心电仪登陆请求
+(void)loginWithParamHeart:(NSDictionary *)parm Success:(void(^)(UserLoginModel *))success Failture:(void(^)(NSError *))failture{
    
    NSString *loginString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/CenterController?operation=login&format=json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:loginString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NetWork:云心电仪登陆接口返回JSON数据的 title : %@", responseObject[0][@"title"]);
        if (success) {
            UserLoginModel *info =[UserLoginModel mj_objectWithKeyValues:responseObject[0]];
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:云心电仪登陆接口登陆失败，错误原因: %@", error);
        if (failture) {
            failture(error);
        }
    }];
    
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/UserServlet?operation=modifypassword&username=admin&old_password=admin&new_password=1234&ok_new_password=1234
//云心电仪修改密码请求
+(void)changePassNetParm:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/UserServlet?operation=modifypassword";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"NetWork:我的家页面密码修改成功%@",responseObject[0]);
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            MineModel *info  = [MineModel mj_objectWithKeyValues:responseObject[0]];
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:我的家页面密码失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}


//http://115.29.146.144:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult&username=13751338740
//云心电仪result结果请求 返回 json 数组，有多组数据
+(void)resultWithParam:(NSDictionary *)param Success:(void(^)(NSArray *result))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/ResultsController?operation=queryresult";//心电仪结果
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:resultString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NetWork:结果页面接口返回JSON数组包含多组数据: %@", responseObject);
        if (success) {
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            NSArray *ARRAY = [ResultModel mj_objectArrayWithKeyValuesArray:responseObject];
            NSLog(@"NetWork:结果页面接口返回的Array转成对象是：%@",ARRAY);
            success(ARRAY);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:结果页面接口获取失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/ResultsController?operation=addresult&username=13592789639&nick=ABC
//云心电仪上传检测结果的方法
+(void)submitDataNetParm:(NSDictionary *)parm Success:(void(^)(NSString *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/ResultsController?operation=addresult";//心电仪结果
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"NetWork:结果详细页面提交数据成功%@",responseObject);
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:结果详细页面提交数据失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/UserServlet?operation=userinfo&username=13751338740 根据用户名查询用户信息
//云心电仪我的家页面请求网络查到当前用户信息 返回 json 数组，当前用户的一组数据
+(void)mineDataNetParm:(NSDictionary *)param Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/UserServlet?operation=userinfo";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NetWork:我的家人用户信息接口返回JSON数组包含一组数据: %@", responseObject[0]);
        if (success) {
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            MineModel *info =[MineModel mj_objectWithKeyValues:responseObject[0]];
            NSLog(@"NetWork:我的家人用户信息接口返回的数据已存入MineModel：%@",info);
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:我的家人用户信息接口获取失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=queryfamily&username=13592789639
//云心电仪我的家页面请求网络查询所有用户信息 返回 json 数组，当前用户组下的多组数据
+(void)familyDataNetParm:(NSDictionary *)param Success:(void(^)(NSArray *result))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=queryfamily";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NetWork:获取所有家人接口返回JSON数组包含多组数据: %@", responseObject);
        if (success) {
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            NSArray *ARRAY = [MineModel mj_objectArrayWithKeyValuesArray:responseObject];
            NSLog(@"NetWork:获取所有家人接口返回的Array转成对象是：%@",ARRAY);
            success(ARRAY);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:获取所有家人接口获取失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=addfamily&username=13751338740&nick=tnssy&gender=girl&birthday=1992.7.28&high=166cm&weight=68kg&familygroup=
//云心电仪添加家人请求
+(void)addFamilyNetParm:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=addfamily";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"NetWork:添加家人页面提交数据成功%@",responseObject[0]);
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            MineModel *info  = [MineModel mj_objectWithKeyValues:responseObject[0]];
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:添加家人页面提交数据失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=deletefamily&username=13751338740&nick=tianyi
//云心电仪删除家人请求
+(void)delCuiFamilyNetData:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://115.29.146.144:8080/HeartGuardServer/servlet/FamilyController?operation=deletefamily";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"NetWork:添加家人页面提交数据成功%@",responseObject[0]);
            //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
            MineModel *info  = [MineModel mj_objectWithKeyValues:responseObject[0]];
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:添加家人页面提交数据失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}
//http://172.31.10.3:8080/read/heart/getHeart?filename=data&username=13592789639
//云心电仪获取分析结果请求
+(void)requestDataWithParam:(NSDictionary *)parm Success:(void(^)(ResultModel *))success Failture:(void(^)(NSError *))failture{
    NSString *resultString = @"http://172.31.10.3:8080/read/heart/getHeart?";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:resultString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSLog(@"NetWork:分析结果数据返回成功，message为%@",responseObject[@"message"]);
            ResultModel *info = [[ResultModel alloc]init];
            if ((NSNull *)responseObject[@"data"] != [NSNull null]) {
                //把返回的内容封装成Model对象,把对象放到数组中,成功则回调给控制器
                info = [ResultModel mj_objectWithKeyValues:responseObject[@"data"]];
                NSLog(@"ResultModel%@",info);
                info.message = @"";
            }else{
                info.message = responseObject[@"message"];
            }
            success(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:分析结果页面返回数据失败，返回Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}

//搜房网登陆请求
+(void)loginWithParam:(NSDictionary *)dic success:(void (^)(UserLoginModel *))success failture:(void (^)(NSError *))failture{
    //http://115.28.79.187/sfapp_dev/index.php?m=home&c=user&a=login&number=18520787995&password=121212
    NSString *loginString = @"http://115.28.79.187/sfapp_dev/index.php?m=home&c=user&a=login";//搜房网接口
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:loginString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NetWork:搜房网登陆接口返回JSON数据content: %@", responseObject[@"content"]);
        NSNumber *code = responseObject[@"code"];
        if ([code intValue] == 203) {
            if (failture) {
                failture(nil);
            }
            return;
        }
        if (success) {
            //回调给控制器
            UserLoginModel *info =[UserLoginModel mj_objectWithKeyValues:responseObject[@"content"]];
            success(info);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"NetWork:搜房网登陆接口登陆失败，错误原因: %@", error);
        if (failture) {
            failture(error);
        }
    }];
    
}

+(void)reqestHomeDataSuccess:(void (^)(NSArray *))success failture:(void (^)(NSError *))failture{
    //http://apinew.zhaofangtong.com/house/interface/i-zhaofangtong/4.0.6/zft_list_recommend.ashx?/imageQuality=320&
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"imageQuality": @"320, 568",@"cityId":@"2",@"deviceId":@"MDA1QTUxNzAtMEI4OC00OEIyLTg2QzctQUVCNDVCNDAzNTA5"};
    [manager POST:@"http://apinew.zhaofangtong.com/house/interface/i-zhaofangtong/4.0.6/zft_list_recommend.ashx" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *ARRAY = [ResultModel mj_objectArrayWithKeyValuesArray:responseObject[@"ProjectList"]];
        NSLog(@"JSON: %@", ARRAY);
        if (success) {
            //回调给控制器
            success(ARRAY);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failture) {
            failture(error);
        }
    }];
}



@end
