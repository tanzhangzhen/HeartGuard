//
//  ECGViewController.h
//  智能云心电仪
//
//  Created by MM on 16/3/12.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "ECGViewController.h"
#import "HomeViewController.h"
#import "NetWorkTool.h"

/**
 * 每次分析心电数据的单元，目前以5秒为一个单位
 */
//static int ALLPOINT = 1620;

@interface ECGViewController ()

@property (nonatomic, strong) NSTimer *timer;//计时器
/**
 * 保存滤波前R波峰值的表
 */
@property (nonatomic, strong) NSMutableArray *prelist;// private List<SparseArray<Float>> prelist;
@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, assign) NSInteger flag;

@end

@implementation ECGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航条标题
    [self.navigationItem setTitle:@"测量中"];
    //隐藏导航条
    [self.navigationController  setNavigationBarHidden:NO animated:YES];
    //设置心电绘制背景亮灰
    self.view.backgroundColor = [UIColor lightGrayColor];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    [self playECG];//心电图页面导航右边按钮
    //清空屏幕
    [self.view setNeedsDisplay];
    //[self.translationMoniterView setNeedsDisplay];
    //添加要显示的视图
    [self.view addSubview:self.translationMoniterView];//平移视图
    //__weak ECGViewController *SELF = self;//处理内存泄露
    //开启定时器
    //[_timer setFireDate:[NSDate distantPast]];
    //数据选择器 获取首页用户选择的测量数据与数据量
    [self selectData:_message DataCount:[(_dataCount)intValue]];
    NSLog(@"ecg页接收到 Home传过来的数据%@",_message);

}


#pragma mark - 数据选择器 参数1：选择查看哪组心电数据 参数2：选择数据量
-(void)selectData:(NSString *)fileName DataCount:(NSInteger)dataCount{
    NSString *reall;//主要处理绘图
    //文件名没有选择，默认产过来一个 nil 这边处理设置默认数据
    if ([fileName length]==0) {
        _fileName = @"data";//该数据是网上找的，格式问题，服务端不解析
        reall = @"data0";//默认绘图数据
        NSLog(@"ecg页接收到 Home传过来的数据为空，选择默认数据data测量诊断");
    }else{
        _fileName = fileName;//_fileName主要处理服务端返回的结果
        reall = @"MLII_108_2-3min";//选择绘图数据
    }
    if (dataCount == 0) {
        dataCount = 1800;//5分钟测1800个数据，0.2s的刷新频率则10s展示出来
    }
    //读取文件 MLII_105_0-1min MLII_106_2-3min MLII_107_2-3min MLII_108_2-3min
    _dataSource = [self handleStringPath:reall ofType:@"xml"];
    
    //中值滤波后去寻找 R 波
    //[self findRData:[self handleWaveData:_dataSource CountNum:dataCount]];

    _dataSource = [self handleData:_dataSource FileName:reall CountNum:dataCount];//数据处理
    [self createWorkDataSourceWithTimeInterval:0.001];//定时器,控制刷新时间
    
    //显示心电波形的同时将用户选择的数据发送服务器做数据分析，分析后的结果返回放到 model 中，因 block 块会先跳出，所有测完弹出页面后数据还没有请求回来，因此设置先请求网络，成功后再弹出结果
    //[self requestDataNet];
}

#pragma mark -心电图视图 平移视图的尺寸位置
- (HeartLive *)translationMoniterView
{
    if (!_translationMoniterView) {
        //刷新视图view的frame
        _translationMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _translationMoniterView.backgroundColor = [UIColor blackColor];
    }
    return _translationMoniterView;
}
#pragma mark -定时器，绘制心电图 刷新时间控制
- (void)createWorkDataSourceWithTimeInterval:(NSTimeInterval )timeInterval
{
    //定时器   参数1：时间间隔s 参数2：目标，一般为self 参数3：选择器，选择执行某个方法 选择执行的方法,方法名需要用@selector（）转换为sel类型 参数4：附加参数，一般为nil 参数5：重复
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerTranslationFun) userInfo:nil repeats:YES];//平移
//    _timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(timerTranslationFun) userInfo:nil repeats:YES];
//    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
//    [runloop addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 平移方式绘制
- (void)timerTranslationFun
{
    //增加点到点容器中
    [[PointContainer sharedContainer] addPointAsTranslationChangeform:[self bubbleTranslationPoint]];
    //设置画心电图的点的数量  参数1：容器的点   参数2：当前的点元素数量
    [self.translationMoniterView fireDrawingWithPoints:[[PointContainer sharedContainer] translationPointContainer] pointsCount:[[PointContainer sharedContainer] numberOfTranslationElements]];
}
#pragma mark - 平移视图的点 将数据转化为点
- (CGPoint)bubbleTranslationPoint
{
    CGPoint targetPointToAdd;//定义当前的点
    static NSInteger xCoordinateInMoniter = 1;//X坐标显示
    static NSInteger dataSourceCounterIndexY = 0;//数据源下标计数器
    NSInteger dataSourceCount = [self.dataSource count];//数据源数据个数
    
    dataSourceCounterIndexY %= dataSourceCount;
    xCoordinateInMoniter %= dataSourceCount;
    //为了节省测试时间，将数据量缩减
    if (dataSourceCount > 10000) {
        dataSourceCount /= 4;
    }else if(dataSourceCount > 2000) {
        dataSourceCount /= 2;
    }
    if(dataSourceCounterIndexY == dataSourceCount-1){
        NSLog(@"心电图绘制结束，数据总量：%ld",(long)dataSourceCounterIndexY);
        //取消定时器 是永久的停止 停止后，一定要将timer赋空，否则还是没有释放
        [_timer invalidate];
        _timer = nil;
        //关闭定时器
        //[_timer setFireDate:[NSDate distantFuture]];
        dataSourceCounterIndexY=0;
        [self requestDataNet];
        
    }else{
        //点的位置
        targetPointToAdd = (CGPoint){xCoordinateInMoniter,[self.dataSource[dataSourceCounterIndexY] floatValue]};
        xCoordinateInMoniter += 1;
        dataSourceCounterIndexY ++;
        
    }
    //NSLog(@"当前的点数为%d,当前的点的坐标:%@, X=%f Y=%f",dataSourceCounterIndexY,NSStringFromCGPoint(targetPointToAdd),targetPointToAdd.x,targetPointToAdd.y);
    return targetPointToAdd;
}
#pragma mark - 平移视图的点 将采集的心电数据转化为点
- (CGPoint)bubbleTranslationPoint1
{
    static float  x = 1;
    static int mIndexY = 1;
    float y = [self.dataSource[mIndexY] floatValue];
    CGPoint targetPointToAdd;
    if(mIndexY == [self.dataSource count]-1){
        NSLog(@"心电图绘制结束，数据总量：%ld",(long)mIndexY);
        targetPointToAdd = (CGPoint){0,260};
        
    }else{
        //点的位置
        targetPointToAdd = (CGPoint){x,y};
        x += 0.03;
        mIndexY ++;
        //y =[self.dataSource[mIndexY] floatValue];
        //NSLog(@"自加后下次的点的坐标:X=%f Y=%f",x,y);
    }
    NSLog(@"当前的点的坐标:X=%f Y=%f",targetPointToAdd.x,targetPointToAdd.y);
    return targetPointToAdd;
}

//显示心电波形的同时，将用户选择的数据发送服务器做数据分析，分析后的结果返回放到 model 中
-(void)requestDataNet{
    //static  int flag = 1;
    //登陆页面已做网络请求，获取到当前主用户用户名、密码、昵称、头像
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"UserName"];
    //NSString *password = [userInfo objectForKey:@"PassWord"];
    NSString *mainuser = [userInfo objectForKey:@"MainUser"];
    NSString *curruser = [userInfo objectForKey:@"CurrUser"];
    NSDictionary *p = @{@"filename":_fileName,@"username":username};
    [NetWorkTool requestDataWithParam:p Success:^(ResultModel *result) {
        NSLog(@"用户选择了测量数据:%@,云端分析结果转Model为%@",_fileName,result);
        _result = result;
        _result.username = username;
        if ([curruser length]!= 0) {
            _result.nick = curruser;
        }else {
            _result.nick = mainuser;
        }
        _result.time = [self getDate];
        _result.ecgflag = 1;//判断哪个页面跳转到结果页
        [self showResult];
    } Failture:^(NSError *error) {
        NSLog(@"用户选择了测量数据:%@,云端分析结果获取失败",_fileName);
    }];
}
//网络请求得到数据后跳转到详细信息界面 一定要先返回结果才能跳转，不然结果也什么数据也没有 同时将服务器返回的数据重新封装后上传到服务器保存
-(void)showResult{
    //如果是切换过来的页面,会传过来一个值给 model,从 model 取值 push 给下一个页面
    DetailViewController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSLog(@"服务器返回的message为%@",_result.message);
    if([_result.message length]==0){//message等于0,为空则表示从服务端获取到了返回结果，data中有数据，传递给 model 在结果界面显示出来   message不为空则为错误信息，服务器异常
        //成功获取到服务器返回的数据则提交数据到数据存储服务器备份
        [self submitDataNet];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_result.message message:@"请检查网络或稍后再试"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    detail.result = _result;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)submitDataNet{
    //rate_grade存储早搏个数
    NSDictionary *submit = @{@"username":_result.username,@"nick":_result.nick,@"time":[self getDate],@"rate_grade":_result.rate_grade,@"symptoms_rhythm":_result.symptoms_rhythm,@"rate_average":_result.rate_average,@"rate_min":_result.rate_min,@"rate_max":_result.rate_max,@"rhythm_heart":_result.rhythm_heart,@"sinus_arrest":_result.sinus_arrest,@"cardia_heart":_result.cardia_heart,@"heart_beat_number":_result.heart_beat_number,@"psvc_number":_result.psvc_number,@"pvc_number":_result.pvc_number,@"symptoms_heart":_result.symptoms_heart,@"symptoms_heart_left":_result.symptoms_heart_left,@"symptoms_heart_right":_result.symptoms_heart_right,@"symptoms_heart_two":_result.symptoms_heart_two,@"symptoms_heart":_result.symptoms_heart,@"QT":_result.QT,@"QRS":_result.QRS,@"PR":_result.PR,@"QTC":_result.QTC,@"RR":_result.RR};
    [NetWorkTool submitDataNetParm:submit Success:^(NSString *success) {
        NSLog(@"心电测量结果上传成功");
    } Failture:^(NSError *error) {
        NSLog(@"心电测量结果上传失败");
    }];
}
#pragma mark - 获取系统日期时间
-(NSString *)getDate{
    
    NSDate * senddate=[NSDate date];
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];//%4ld年%2ld月%2ld日
    NSString * nsDateString= [NSString stringWithFormat:@"%d年%d月%d日 ",year,month,day];
    //获得系统时间
    NSDateFormatter * dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //[dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //NSString * morelocationString=[dateformatter stringFromDate:senddate];
    NSString *date = [nsDateString stringByAppendingString:locationString];//字符串拼接
    NSLog(@"日期:%@",date);
    return date;//[date release];
}

#pragma mark - 窗口导航条左边按钮返回事件
-(void)backTo{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
#pragma mark - 暂停心电绘图
-(void)pauseECG{
    //心电图页面导航右边按钮
    _timer.fireDate = [NSDate distantFuture];//暂停、关闭定时器
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playECG)];
    self.navigationItem.rightBarButtonItem = barBtnRight;
}
#pragma mark - 重新开始绘图
-(void)playECG{
    _timer.fireDate = [NSDate date];//重新开启定时器[_timer setFireDate:[NSDate distantPast]];
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseECG)];
    self.navigationItem.rightBarButtonItem = barBtnRight;

}

#pragma mark - 释放内存
-(void)dealloc{
    NSLog(@"释放对象");
}
#pragma mark - 自定义读文件、处理字符串的方法，参数为文件名和文件类型 @"MLII_108_2-3min"
-(NSMutableArray *)handleStringPath:(NSString *)path ofType:(NSString*)type{
    //定义一个可变数组，存放处理后的字符串
    NSMutableArray *tempData = [[NSMutableArray alloc]init];
    //根据文件路径读取文件
    NSString *tempString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:type] encoding:NSUTF8StringEncoding error:nil];
    if ([path isEqualToString:@"data0"]) {
        //字符串切割
        tempData = [[tempString componentsSeparatedByString:@","] mutableCopy];
    }else{
        //切割替换掉头部多余的数据
        tempString = [tempString stringByReplacingCharactersInRange:NSMakeRange(0,103) withString:@""];
        //正则表达式进行过滤掉时间，过滤后数据居中，有\n:最左边 \t:空格 时间和数据中间
        tempString = [tempString stringByReplacingOccurrencesOfRegex:@"[\\s][0-9]+:[0-9.]+" withString:@""];
        //NSLog(@"使用正则表达式进行时间过滤，过滤后的数据内容为:%@",tempString);
        //非法字符串进行二次过滤-\t\n
        tempString = [[tempString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\n "]]componentsJoinedByString:@""];
        //NSLog(@"使用非法字符串进行二次过滤-\t\n，过滤后的数据内容为:%@",tempString);
        //字符串切割
        tempData = [[tempString componentsSeparatedByString:@"\t"] mutableCopy];
        [tempData removeObjectAtIndex:0];//获取到的第0个对象为空，故删除
    }
    NSLog(@"XML文件的数据转数组成功。数组tempData[0]内容为:%@,count:%lu",tempData[0], (unsigned long)tempData.count);
    return tempData;
}

#pragma mark - 自定义读文件、处理字符串的方法，参数为文件名和文件类型 @"MLII_108_2-3min"
-(NSMutableArray *)handleStringPaths:(NSString *)path ofType:(NSString*)type{
    //定义一个可变数组，存放处理后的字符串
    NSMutableArray *tempData = [[NSMutableArray alloc]init];
    //根据文件路径读取文件
    NSString *tempString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:type] encoding:NSUTF8StringEncoding error:nil];
    //切割替换掉头部多余的数据
    tempString = [tempString stringByReplacingCharactersInRange:NSMakeRange(0,103) withString:@""];
    //正则表达式进行过滤掉时间，过滤后数据居中，有\n:最左边 \t:空格 时间和数据中间
    tempString = [tempString stringByReplacingOccurrencesOfRegex:@"[\\s][0-9]+:[0-9.]+" withString:@""];
    //NSLog(@"使用正则表达式进行时间过滤，过滤后的数据内容为:%@",tempString);
    //非法字符串进行二次过滤-\t\n
    tempString = [[tempString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\n "]]componentsJoinedByString:@""];
    //NSLog(@"使用非法字符串进行二次过滤-\t\n，过滤后的数据内容为:%@",tempString);
    //字符串切割
    tempData = [[tempString componentsSeparatedByString:@"\t"] mutableCopy];
    [tempData removeObjectAtIndex:0];//获取到的第0个对象为空，故删除
    NSLog(@"XML文件的数据转数组成功。数组tempData[0]内容为:%@,count:%lu",tempData[0], (unsigned long)tempData.count);
    return tempData;
}

#pragma mark - 自定义中值滤波方法 参数1：要处理的数据源 参数2：要处理的数据量
-(NSMutableArray *)handleWaveData:(NSMutableArray *)data CountNum:(NSInteger)mCount{
    NSMutableArray *newData = [NSMutableArray array];//新数据源中有 data.count-45个元素 200则有155个,下标为0-154
    for (int i = 45; i < mCount; i++) {
        // subList返回一个以i-45为起始索引（包含），以i+45为终止索引（不包含）的子列表（List）。
        NSArray *jq = [data subarrayWithRange:NSMakeRange(i-45,90)];
        // 排序
        NSArray *sortedArray = [jq sortedArrayUsingSelector:@selector(compare:)];
        float mid = [(NSNumber *)[sortedArray objectAtIndex:sortedArray.count/2]floatValue];
        NSNumber *curNum = [data objectAtIndex:i];//滤波前点的值
        float newFloat = [(NSNumber *)[data objectAtIndex:i]floatValue]-mid;
        //NSLog(@"当前循环第%d次,当前数据i=%d 值=%@,截取数组中%d-%d的%lu个元素进行排序,排序得出滤波中值为%f,滤波后当前点值为%f",i-44,i,curNum,i-45,i+45,(unsigned long)jq.count,mid,newFloat);
        //滤波后的数据存入新数组中
        NSNumber *number = [NSNumber numberWithFloat:newFloat];
        [newData addObject:number];
        [data addObject:number];//newDataListY.add((dataY.get(i) - mid));
    }
    NSLog(@"中值滤波完成,新数据源newData[0]的内容为:%@,count:%lu,data[0]的内容为:%@,count:%lu",newData[0], (unsigned long)newData.count, data[0], (unsigned long)data.count);
    return newData;
}
#pragma mark - 数据处理，调整波形 Y 坐标，使波形显示在界面中央
-(NSMutableArray *)handleData:(NSMutableArray *)data FileName:(NSString *)fileName CountNum:(NSInteger)dataCount{
    NSArray *jq = [data subarrayWithRange:NSMakeRange(0,dataCount)];
    NSMutableArray *cutting = [NSMutableArray arrayWithArray:jq];
    [cutting enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *tempData;//数据处理值
        if ([fileName isEqualToString:@"data0"]) {
            //网络数据未滤波第一个是2071，为了使图形居中显示，取负再加2500为正后除2 滤波后则
            tempData = @((-[obj integerValue]+2400)/1.5);
        }else{
            
            //MIT数据*360是因为绘图比例问题,X、Y坐标要对应 +320是为了使图像显示在屏幕中央
            tempData = @([obj floatValue]*360+300);
        }
        //数组替换
        [cutting replaceObjectAtIndex:idx withObject:tempData];
    }];
    NSLog(@"数据处理完成,波形正常显示，替换前data[0]为:%@,数据总量为%lu,替换后cutting[0]为%@,数据总量为%lu",data[0], (unsigned long)data.count,cutting[0],(unsigned long)cutting.count);
    return cutting;
}

#pragma mark - findR波
-(void)findRData:(NSMutableArray *)data{
    //每次分析心电数据的单元，目前以5秒为一个单位1620
    //    static int ALLPOINT = 5000;
    //    NSInteger startIndex = data.count-ALLPOINT;
    //    NSMutableArray *intercept = [NSMutableArray arrayWithArray:[data subarrayWithRange:NSMakeRange(startIndex, ALLPOINT)]];//data.count-1是因为元素下标从0开始，100个元素则最后一个下标为99，否则就越界
    //    FindR *fqrs = [[FindR alloc]initWithData:data WithStartIndex:(int)startIndex];
    FindR *fqrs = [[FindR alloc]initWithData:data WithStartIndex:0];
    //保存R波峰值的表
    NSMutableArray *prelist = [NSMutableArray array];
    [prelist addObjectsFromArray:fqrs.StartToSearchQRS];    NSLog(@"R波峰值的集合：%@",prelist);
    NSMutableArray *rB= fqrs.getAllRPoint;  NSLog(@"R波下标的集合%@，R波下标个数%lu",rB,(unsigned long)rB.count);
    float variance = fqrs.getVariance;  NSLog(@"R波下标方差%f" , variance);
    //心率=60*360/R值平均下标差
    int rate = fqrs.getHeartRate;   NSLog(@"心率=60*a*360/R值平均下标差=%d" , rate);
    //_result.time = [NSString stringWithFormat:@"%d",rate];
    //检测 R 波分析出的一些其他数据
    NSMutableArray *AvgList = fqrs.getAvgList;//搜索 R 波获得的平均值
    NSMutableArray *Min_avg = fqrs.getMin_avg;//最小平均值
    NSMutableArray *Max_avg = fqrs.getMax_avg;//最大平均值
    float LogData_slopeGate = fqrs.getLogData_slopeGate;//最大斜率值
    float LogData_dateGate = fqrs.getLogData_dateGate;//最大数据值
    float RRInternal = fqrs.GetRRInternal;//获取R值下标的平均差
    float RRAverage = RRInternal / 360 * 1000; // RR间期的平均值
    float AverageHeart_rate = 60 * 360 / RRInternal; // RR平均心率
    NSLog(@"搜索 R 波获得的平均值%@, 最小平均值%@, 最大平均值%@, 最大斜率值%f, 最大数据值%f ,获取R值下标的平均差%f,RR间期的平均值%f,RR间期平均心率%f",AvgList,Min_avg,Max_avg,LogData_slopeGate,LogData_dateGate, RRInternal,RRAverage,AverageHeart_rate);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"resultsDetail"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        DetailViewController *detail =(DetailViewController *)segue.destinationViewController;
//        detail.nick = @"Garvey";
//        detail.time = @"110";
    }
}
#pragma mark - 在页面消失的时候关闭定时器，然后等页面再次打开的时候，又开启定时器。(主要是为了防止它在后台运行，占用CPU) 每次都会调viewWillAppear和viewDidAppear方法
//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
}
//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)xmlParses{
    //0:00.036-0.155str	__NSCFString *	@"   Elapsed time\t   MLII\t     V1\r\n01234567890123456789012345678901223\r\n   hh:mm:ss.mmm\t   (mV)\t   (mV)\r\n       0:00.000\t -0.445\r\n       0:00.003\t -0.445\r\n       0:00.006\t -0.445\r\n       0:00.008\t -0.445\r\n       0:00.011\t -0.445\r\n       0:00.014\t -0.445\r\n       0:00.017\t -0.445\r\n       0:00.019\t -0.445\r\n       0:00.022\t -0.450\r\n       0:00.025\t -0.430\r\n       0:00.028\t -0.435\r\n       0:00.031\t -0.405\r\n       0:00.033\t -0.385\r\n       0:00.036\t -0.365\r\n       0:00.039\t -0.355\r\n       0:00.042\t -0.340\r\n       0:00.044\t -0.325\r\n       0:00.047\t -0.305\r\n       0:00.050\t -0.285\r\n       0:00.053\t -0.260\r\n       0:00.056\t -0.245\r\n       0:00.058\t -0.225\r\n       0:00.061\t -0.240\r\n       0:00.064\t -0.225\r\n       0:00.067\t -0.210\r\n       0:00.069\t -0.195\r\n       0:00.072\t -0.190\r\n       0:00.075\t -0.195\r\n       0:00.078\t -0.205\r\n       0:00.081\t -0.205\r\n       0:00.083\t -0.200\r\n       0:00.086\t -0.205\r\n       0:00.089\t -0.210\r\n       0:00.092\t -0.215\r\n       0:00.094\t -0.235\r\n       0:00.097\t -0.235\r\n       0:00.100\t -0."	0x00007f97fb449c60
    NSURL *path = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MLII_105_0-1min" ofType:@"xml"]];
    NSError *error = nil;
    NSMutableString *str =  [NSMutableString stringWithString:[NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:&error]];
    
    [str replaceOccurrencesOfString:@"\t " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length-1)];
    NSArray *array = [str componentsMatchedByRegex:@"[0-9]+:[0-9.]+[\\s]?-[0-9.]+"];
    //    [0-9]+:[0-9.]+[\\s]?-[0-9.]+
    NSLog(@"%@",array);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *s in array) {
        NSArray *a = [s componentsSeparatedByString:@"-"];
        [dic setObject:a[1] forKey:a[0]];
    }
    
    NSLog(@"dic:%@",dic);
    [self createWorkDataSourceWithTimeInterval:0.02];//定时器，控制刷新时间
}
////block块实现心电数据的读取、心电图绘制
//void (^createData)(void) = ^{
//    //读取文件
//    NSString *tempString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    //字符串切割
//    NSMutableArray *tempData = [[tempString componentsSeparatedByString:@","] mutableCopy];
//    NSLog(@"XML文件的数据转数组成功。数组tempData[0]内容为:%@",tempData);
//    //数组遍历
//    [tempData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        //测试数据第一个是2071，为了使图形居中显示，取负再加2500为正
//        NSNumber *tempDataa = @(-[obj integerValue] +2350);
//        //数组替换
//        [tempData replaceObjectAtIndex:idx withObject:tempDataa];
//    }];
//    SELF.dataSource = tempData;
//    NSLog(@"心电数据初步处理，数组遍历替换成功。数据源dataSource[0]数据为：%@ 数据源dataSource的数据总数为%lu",SELF.dataSource[0],(unsigned long)SELF.dataSource.count);
//    [SELF createWorkDataSourceWithTimeInterval:0.02];//定时器，控制刷新时间
//};

@end