//
//  ECGController.m
//  HeartGuard
//
//  Created by MM on 16/3/24.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "ECGController.h"
#import "FindP.h"
#import "FindR.h"
#import "FindTQS.h"
#import "ResultData.h"


/**
 * 每次分析心电数据的单元，目前以5秒为一个单位
 */
static int ALLPOINT = 1620;

/**
 * 刷新心率的频率，目前以4秒为一个单位,为了画图跟心率的检测能同步做的延时
 */
static int DELEYSHOWRATE = 3500;


/**
 * 控制画图的数率，具体怎么算出来的不知道，反正能1分钟的数据能在1分钟左右跑玩
 */
static int RATE = 100;

@interface ECGController()

@property (nonatomic, assign) int refreshCount;//int refreshCount=0;
@property (nonatomic, strong) ResultData *resultData;
@property (nonatomic, assign) Boolean isDestroyed;
@property (nonatomic, assign) int POINTNUM;
/**
 * 保存滤波前R波峰值的表
 */
@property (nonatomic, strong) NSMutableArray *prelist;// private List<SparseArray<Float>> prelist;
/**
 * 保存R波峰值的表
 */
@property (nonatomic, strong) NSMutableArray *list; //private List<SparseArray<Float>> list;


/**
 * 画笔对象
 */
//private Paint linePaint = new Paint();
/**
 * 心电数据数组
 */
@property (nonatomic, strong) NSMutableArray * dataY;//private  ArrayList<Float> dataY = new ArrayList<Float>();
/**
 * 心电数据集合
 */
@property (nonatomic, strong) NSMutableArray * dataListY;//private ArrayList<Float> dataListY = new ArrayList<Float>();
/**
 * 滤波后并处理完倒置R波后心电数据集合
 */
@property (nonatomic, strong) NSMutableArray * newsDataListY;//private ArrayList<Float> newDataListY = new ArrayList<Float>();
/**
 * 滤波后心电数据集合
 */
@property (nonatomic, strong) NSMutableArray * DataListY;//private ArrayList<Float> DataListY ;
/**
 * 标示是否是第一次画图
 */
@property (nonatomic, assign) Boolean  isFirstDraw;//private boolean isFirstDraw = true;
/**
 * 在画布上正在显示的数据集合
 */
@property (nonatomic, strong) NSMutableArray * showedList;//private ArrayList<Float> showedList = new ArrayList<Float>();
/**
 * 已经显示的数据波形 最多能够显示的单位格数量(横坐标 15px 为一个单位格)
 */
@property (nonatomic, assign) int maxNum; //private int maxNum = 0;

/**
 * 显示的波形每个单元格开始的位置(X轴坐标)
 */
@property (nonatomic, assign) int showedBeginX;//private int showedBeginX = 0;
/**
 * 显示的波形每个单元格结束的位置(X轴坐标)
 */
@property (nonatomic, assign) int showedEndX;//private int showedEndX = 0;
/**
 * 显示的波形每个单元格开始的时候波形长度的值(Y轴坐标)
 */
@property (nonatomic, assign) float showedBeginY;//private float showedBeginY = 0;
/**
 * 显示的波形每个单元格结束的时候波形长度的值(Y轴坐标)
 */
@property (nonatomic, assign) float showedEndY; //private float showedEndY = 0;
@property (nonatomic, assign) int lineNum;//public static int lineNum;

@property (nonatomic, assign) int dp;//private static final int dp = 72;

//private MyLoop myLoop;
/**
 * 控制是否刷新屏幕
 */
@property (nonatomic, assign) Boolean  isrun;//private boolean isrun = true;

@property (nonatomic, strong) NSURLConnection* aSynConnection;
@property (nonatomic, strong) NSInputStream *inputStreamForFile;
@property (nonatomic, strong) NSString *localFilePath;

@end

@implementation ECGController
- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(startLoadData) object:kURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:operation];


}
-(Boolean)isDestroyed{
    return _isDestroyed;
}
-(Boolean)isrun{
    return _isrun;
}

-(void)startLoadData{
    self.localFilePath = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.inputStreamForFile = [NSInputStream inputStreamWithFileAtPath:self.localFilePath];
    ResultData *resultData = [[ResultData alloc]init];
//    resultData.getLogData_ifPositive addObject:<#(nonnull id)#>
//    getLogData_ifPositive()
    NSInputStream *inputStream = nil;
    
}
//    new Thread(new Runnable() {
//        /* (non-Javadoc)
//         * @see java.lang.Runnable#run()
//         */
//        @Override
//        public void run() {
//            if(!isDestroyed){
//                InputStream inputStream = null;
//                try {
//                    inputStream = MainActivity.inputStream;
//                    BufferedReader reader = new BufferedReader(
//                                                               new InputStreamReader(inputStream));
//                    lineNum = 0;
//                    // reader.readLine();
//                    // reader.readLine();
//                    prelist=new ArrayList<SparseArray<Float>>();
//                    
//                    
//                    for (String s = reader.readLine(); s != null; s = reader
//                         .readLine()) {
//                        if (lineNum >= 3) {
//                            String a=s.substring(17,18);
//                            s = s.substring(16, 23);
//                            if(a.equals("-"))
//                                resultData.getLogData_ifPositive().add(a+lineNum);
//                            synchronized(dataY){
//                                dataY.add(Float.parseFloat(s));
//                            }
//                            if(dataY.size()%ALLPOINT==0) {
//                                StartDraw(dataY.size()- ALLPOINT,dataY.size());
//                                new Thread(new Runnable() {
//                                    @Override
//                                    public void run() {
//                                        if(!isDestroyed){
//                                            int rate;
//                                            FindR fqrs = new FindR(dataY.subList(dataY.size()- ALLPOINT,dataY.size()),
//                                                                   dataY.size() - ALLPOINT);
//                                            prelist.addAll(fqrs.StartToSearchQRS());
//                                            Log.e("123", "R波下标"+ fqrs.getAllRPoint().toString());
//                                            Log.e("123", "R波下标个数"+ fqrs.getAllRPoint().size());
//                                            float variance = 0;
//                                            variance = fqrs.getVariance();
//                                            Log.d("123","R波下标方差" + variance);
//                                            Message m = new Message();
//                                            m.what = EcgtestActivity.CHANGERRINTERNAL;
//                                            // 心率=60*360/R值平均下标差
//                                            rate = fqrs.getHeartRate();
//                                            m.arg1 = rate;
//                                            m.arg2=lineNum-2;
//                                            EcgtestActivity.handler.sendMessageDelayed(m, DELEYSHOWRATE);
//                                        }
//                                    }
//                                }).start();
//                                Thread.sleep(DELEYSHOWRATE); // 为了画图跟心率的检测能同步做的延时
//                                //								}
//                            }
//                        }
//                        lineNum++;
//                    }
//                    // 这是漏读入数据的部分，因为dataY.size()%ALLPOINT 取余数，导致少读了一段数据
//                    // 对固定数据 含有的R波的检测率有一定的提高
//                    // 对读入的数据的R波的检测率还是一样的
//                    if (dataY.size() % ALLPOINT != 0) {
//                        StartDraw(dataY.size()-(dataY.size() % ALLPOINT),dataY.size());
//                        
//                        new Thread(new Runnable() {
//                            @Override
//                            public void run() {
//                                if(!isDestroyed){
//                                    int rate;
//                                    FindR fqrs = new FindR(dataY.subList(dataY.size()- (dataY.size() % ALLPOINT),
//                                                                         dataY.size()), dataY.size()
//                                                           - (dataY.size() % ALLPOINT));
//                                    prelist.addAll(fqrs.StartToSearchQRS());
//                                    Message m = new Message();
//                                    m.what = EcgtestActivity.CHANGERRINTERNAL;
//                                    // 心率=60*360/R值平均下标差
//                                    rate = fqrs.getHeartRate();
//                                    // Log.e("123", j + "心率是===" + rate);
//                                    m.arg1 = rate;
//                                    EcgtestActivity.handler.sendMessageDelayed(m, DELEYSHOWRATE);
//                                }
//                            }
//                        }).start();
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    System.out.println("错就是错，是我咎由自取" + e);
//                }
//            }
//        }
//    }).start();
//}
@end
