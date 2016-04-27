
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UserLoginModel.h"
#import "MineModel.h"
#import "MJExtension.h"
#import "ResultModel.h"


@interface NetWorkTool : NSObject

@property(nonatomic,copy) NSString *url;


//云心电仪登陆网络请求方法
+(void)loginWithParamHeart:(NSDictionary *)parm Success:(void(^)(UserLoginModel *))success Failture:(void(^)(NSError *))error;
//云心电仪修改密码请求
+(void)changePassNetParm:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))error;
//云心电仪获取结果网络请求方法
+(void)resultWithParam:(NSDictionary *)param Success:(void(^)(NSArray *result))success Failture:(void(^)(NSError *))error;
//云心电仪上传检测结果的方法
+(void)submitDataNetParm:(NSDictionary *)parm Success:(void(^)(NSString *))success Failture:(void(^)(NSError *))error;
//云心电仪我的家页面请求网络查到当前用户信息
+(void)mineDataNetParm:(NSDictionary *)param Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))error;
//云心电仪我的家页面请求网络查到所有用户信息 返回 json 数组，有一组数据
+(void)familyDataNetParm:(NSDictionary *)param Success:(void(^)(NSArray *result))success Failture:(void(^)(NSError *))error;
//云心电仪我的家页面请求网络添加家人
+(void)addFamilyNetParm:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))error;
//云心电仪我的家页面请求网络删除家人
+(void)delCuiFamilyNetData:(NSDictionary *)parm Success:(void(^)(MineModel *))success Failture:(void(^)(NSError *))error;
//云心电仪获取分析结果请求
+(void)requestDataWithParam:(NSDictionary *)parm Success:(void(^)(ResultModel *))success Failture:(void(^)(NSError *))error;


//搜房网登陆网络请求方法
+(void)loginWithParam:(NSDictionary *)dic success:(void(^)(UserLoginModel *result))success failture:(void(^)(NSError *))error;
//搜房网获取首页房源信息网络请求方法
+(void)reqestHomeDataSuccess:(void(^)(NSArray *data))success failture:(void(^)(NSError *))error;

@end
