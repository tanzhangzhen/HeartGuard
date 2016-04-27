//
//  FineR.m 寻找R波类
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "FindR.h"

/**
 * 完成分析
 */
static int END = -1;//private static final int END = -1;
/**
 * 小于R-R间期门限最小值
 */
static int LOWERMINRR = 1;//private static final int LOWERMINRR = 1; // lowerminrr
/**
 * 大于R-R间期门限最大值
 */
static int OVERMAXRR = 2;//private static final int OVERMAXRR = 2; // overmaxrr

@interface FindR()
/**
 * 2s采集点的个数（2*360）
 */
@property(nonatomic, assign) int POINTNUM;

/**
 * 读入点的总数
 */
@property(nonatomic, assign) int ALLPOINT;
/**
 * R-R间期门限最大值
 */
@property(nonatomic, assign) float MaxRRInternal; // 主要的值
/**
 * R-R间期门限最小值
 */
@property(nonatomic, assign) float MinRRInternal;

/**
 * 阀值递增值ChangePer = 0.05f;
 */
@property(nonatomic, assign) float ChangePer; // 主要的值
/**
 * 斜率阀值
 */
@property(nonatomic, assign) float SlopePer; // 主要的值
/**
 * 斜率阀值缓存
 */
@property(nonatomic, assign) float tempSlopePer;
/**
 * 数值阀值
 */
@property(nonatomic, assign) float DataPer; // 主要的值
/**
 * 数值阀值缓存
 */
@property(nonatomic, assign) float tempDataPer;
@property(nonatomic, assign) float  MaxSlope, MaxData, MaxSlopeGate, MaxDataGate; // 主要的值
@property(nonatomic, strong) NSMutableArray  *Data;//float
/**
 * 测试用打印信息：门限值
 */
@property(nonatomic, assign) float logData_dateGate, logData_slopeGate;
/**
 * 测试用打印信息：平均值及偏移值,
 */
@property(nonatomic, strong) NSMutableArray *avgList, *max_avg, *min_avg;//    private List<Float> avgList, max_avg, min_avg;
@property(nonatomic, assign) int LastRPoint, LastOperate;
/**
 * R波下标
 */
@property(nonatomic, strong) NSMutableArray *RPoint;//    List<Integer> RPoint;

//有问题
@property(nonatomic, assign) Boolean finishAnalyse;//private boolean finishAnalyse = false;

@property(nonatomic, assign) int startIndex;//private int startIndex = 0;



@end

@implementation FindR



-(void)setALLPOINT:(int)point_num{
    _ALLPOINT = point_num;
}
/**
 * 构造函数，初始化数据
 *
 * @param data
 */
-(instancetype)initWithData:(NSMutableArray *)data WithStartIndex:(int)startIndex{
    //public FindR(List<Float> data,int startIndex)
    if (self = [super init]) {
        if (data.count < 540) {
            _POINTNUM = (int)data.count; //2s采集点的个数（2*360）
        } else {
            _POINTNUM = 540;
        }
        _ALLPOINT = (int)data.count;//读入点的总数
        NSLog(@"FindR初始化完成,读入点的数量ALLPOINT=%d", _ALLPOINT);
        _MaxRRInternal = 1.6f * 360;
        _MinRRInternal = 0.3f * 360;
        _ChangePer = 0.05f;
        _SlopePer = 0.55f;
        _tempSlopePer = _SlopePer;
        _DataPer = 0.7f;
        _tempDataPer = _DataPer;
        _LastRPoint = 0;
        _LastOperate = 0;
        _avgList = [NSMutableArray array];//        avgList =  new ArrayList<Float>();
        _max_avg = [NSMutableArray array];//        max_avg = new ArrayList<Float>();
        _min_avg = [NSMutableArray array];//        min_avg = new ArrayList<Float>();
        _startIndex = startIndex;
        _Data = [NSMutableArray array];//        Data = new float[data.size()];
        for (int i = 0; i < data.count; i++) {
            _Data[i] = data[i];//Data[i] = data.get(i);
        }
        _RPoint = [NSMutableArray array];//        RPoint = new ArrayList<Integer>();
        _finishAnalyse = false;
        [self absDataIfNeed:0];//倒置 R 波的寻找
    }
    return self;
}
/**
 * 获取R点的SparseArray
 *
 * @return list返回 R 波下标对应的峰值
 */
-(NSMutableArray *)StartToSearchQRS{
    
    int NewR;
    // 第一步：找到斜率最大的 三个点求一次斜率  斜率阈值系数：0.55 发现其他 R 波的时候使用
    _MaxSlopeGate = [self GetMaxSlopeGate]; // 获取最大斜率门限值
    NSLog(@"最大斜率为%f",_MaxSlope);
    // 第二步：找到最大的数，取阀值 初始化第一个数,*100+500 遍历数组比较 数值阈值：0.7
    _MaxDataGate = [self GetMaxDataGate]; // 获取最大值门限值
    NSLog(@"最大值门限值为%f",_MaxDataGate);
    // 第三步：找第一个R波 返回R波下标 先找到超出MaxSlope的值的下标，再找出该下标后20个数内的最大值的下标，假如这个值大于最大门限值那么就是R值，否则下标+1继续找后20个数的最大值
    NewR = [self FindRPoint:0];//NewR = FindRPoint(0);
    //把找到的R波加到_RPoint中 在指定的位置上插入特定元素，也可以直接 add[_RPoint addObject:[NSNumber numberWithInt:NewR]];
    [_RPoint insertObject:[NSNumber numberWithInt:NewR] atIndex:_LastRPoint];//RPoint.add(LastRPoint, NewR);
    NSLog(@"寻找到的第一个R波在第%d个数据点，峰值为%@", [(NSNumber *)[_RPoint objectAtIndex:_RPoint.count-1] intValue], [_Data objectAtIndex:[(NSNumber *)[_RPoint objectAtIndex:_RPoint.count-1] intValue]]);
    //寻找其他R波 内部循环调用该方法，设置最多执行10次
    int isEnd = 0;
    //int s = [(NSNumber *)[_RPoint objectAtIndex:_LastRPoint] intValue];
    while ([(NSNumber *)[_RPoint objectAtIndex:_LastRPoint] intValue] + 100<_ALLPOINT && isEnd != END) {//while (RPoint.get(LastRPoint) + 100 < ALLPOINT && isEnd != END)
        isEnd = [self FindRestRPoint:[(NSNumber *)[_RPoint objectAtIndex:_LastRPoint] intValue]+100];//isEnd = FindRestRPoint(RPoint.get(LastRPoint) + 100);
        NSLog(@"从%d 开始寻找其他 R 波",[(NSNumber *)[_RPoint objectAtIndex:_LastRPoint] intValue]+100);
    }
    NSMutableArray *list = [NSMutableArray array];//List<SparseArray<Float>> list
    for (int i = 0; i < _RPoint.count; i++) {
        NSMutableArray *m = [NSMutableArray array];// SparseArray<Float> m = new SparseArray<Float>();
        //在指定的位置上插入特定元素   使用这个报错:index 385 beyond bounds for empty array 因为数组为空，不能插入
        //[m insertObject:[_Data objectAtIndex:i] atIndex:[(NSNumber *)[_RPoint objectAtIndex:i]intValue]+_startIndex];
        [m addObject:[_Data objectAtIndex:i]];//m.put(RPoint.get(i) + startIndex, Data[RPoint.get(i)]);
        [list addObject:m];// list.add(m);
    }
     _finishAnalyse = true;
    return list;
}

/**
 * 当波形倒置时处理,对R波倒置取绝对值
 *
 * @param startPosition
 */
-(void)absDataIfNeed:(int)startPosition{
    float avg = 0;
    float max = [(NSNumber *)[_Data objectAtIndex:startPosition]floatValue];//float max = Data[startPosition]
    float min = [(NSNumber *)[_Data objectAtIndex:startPosition]floatValue];//min = Data[startPosition];
    for (int i = startPosition; (i < startPosition + _POINTNUM && i < _Data.count); i++) {
        float s = [(NSNumber *)[_Data objectAtIndex:i]floatValue];
        avg += s;
        if (max < s) { // 求两秒内最大值和最小值及其下标
            max = s;
        }
        if (min > s) {
            min = s;
        }
    }
    avg = avg / _POINTNUM; // 求2秒内平均值
    float a = max - avg;
    float b = min - avg;
    [_avgList addObject:[NSNumber numberWithFloat:avg]];// avgList.add(avg);
    [_max_avg addObject:[NSNumber numberWithFloat:a]];// max_avg.add(max - avg); // 保存信息打印
    [_min_avg addObject:[NSNumber numberWithFloat:b]];// min_avg.add(min - avg);
    NSMutableArray *dzR = [NSMutableArray array];
    if (ABS(max - avg) < ABS(min - avg)) {
        // R波倒置
        NSLog(@"倒置%d", startPosition+_startIndex);
        for (int i = startPosition; (i < startPosition + _POINTNUM && i < _Data.count); i++) { // 绝对值化
            //Data[i] = -Data[i];
            float a = -[(NSNumber *)[_Data objectAtIndex:i]floatValue];
            [dzR addObject:[NSNumber numberWithFloat:a]];
            //在指定的位置上插入特定元素
            [_Data insertObject:[NSNumber numberWithFloat:a] atIndex:i];
            
        }
    }
    //NSLog(@"倒置的 R 波集合：%@，倒置的 R 波的数量%lu",dzR, dzR.count);
}

/**
 * 获取最大斜率门限值 初始化,3个点求一次斜率
 *
 * @return 第一组数的最大斜率*SlopePer
 */
-(float)GetMaxSlopeGate{
    int i;
    _MaxSlope = [(NSNumber *)[_Data objectAtIndex:2]floatValue] - [(NSNumber *)[_Data objectAtIndex:0]floatValue];
    //MaxSlope = Data[2] - Data[0];
    for (i = 3; i < _ALLPOINT; i++) {
        float s = [(NSNumber *)[_Data objectAtIndex:i]floatValue];
        float ss = [(NSNumber *)[_Data objectAtIndex:i - 2]floatValue];
        if (_MaxSlope < s - ss) {
            _MaxSlope = s - ss;
        }
    }
    float s = _MaxSlope * _SlopePer;
    [self setLogData_slopeGate:s];
    NSLog(@"MaxSlope最大的斜率 未乘上阀值:%f,乘上阀值:%f",_MaxSlope,s);
    return s;
}
-(void)setLogData_slopeGate:(float)logData_slopeGate{
    _logData_slopeGate = logData_slopeGate;
}
/**
 * 获取最大峰值门限值 初始化第一个数*100+500
 *
 * @return 第一组数的最大值*DataPer
 */
-(float)GetMaxDataGate{
    int i;
    _MaxData = [(NSNumber *)[_Data objectAtIndex:0]floatValue] * 100 + 500;
    float s = [(NSNumber *)[_Data objectAtIndex:i]floatValue];
    for (i = 1; i < _ALLPOINT; i++) {
        if (_MaxData < s * 100 + 500) {
            _MaxData = s * 100 + 500;
        }
    }
    float ss = _MaxData * _DataPer;//数值阈值：0.7
    [self setLogData_dateGate:ss];
    return ss;
}
-(void)setLogData_dateGate:(float)logData_dateGate{
    _logData_dateGate = logData_dateGate;
}
/**
 * 获取从s到ALLPOINT个数中斜率大于最大斜率门限的第一个数的下标
 *
 * @param s
 * @return
 */
-(int)FindOverMaxSlopeGate:(int)s{
    if (s != END) {
        do {
            if (s >= _ALLPOINT - 2)
                return END;
            s++;
        }
        while ([(NSNumber *)[_Data objectAtIndex:s+1]floatValue]-[(NSNumber *)[_Data objectAtIndex:s-1]floatValue]<_MaxSlopeGate);//        while (Data[s + 1] - Data[s - 1] < MaxSlopeGate);
    }
    
    // print("Over1这是第几个数啊："+s+"数值是"+Data[s]);
    return s;
}

/**
 * 以start为起始下标，获取其后20个数的最大值的下标
 *
 * @param start
 * @return 其后20个数的最大值的下标
 */
-(int)GetMaxData:(int)start{
    int i, M;
    if (start == END) {
        return END;
    }
     if (start >= _ALLPOINT) {
     start--;
     }
    M = start;
    float MData = [(NSNumber *)[_Data objectAtIndex:start]floatValue];//Data[start];
    for (i = 1; i < 20; i++) {
        float s = [(NSNumber *)[_Data objectAtIndex:start+i]floatValue];//Data[start + i]
        if (start + i >= _ALLPOINT)
            break;
        if (MData < s) {
            MData = s;
            M = start + i;
        }
    }
    
    return M;
}

/**
 * 先找到超出MaxSlope的值的下标，再找出该下标后20个数内的最大值的下标，假如这个值大于最大门限值那么就是R值，否则下标+1
 * 继续找后20个数的最大值
 *
 * @param start
 * @return R波下标
 */
-(int)FindRPoint:(int)start{
    int n = END; // = -1, 完成分析
    if (start != END) {
        if (start < _ALLPOINT) {
            n = [self GetMaxData:[self FindOverMaxSlopeGate:start]];// n = GetMaxData(FindOverMaxSlopeGate(start));
            if (n == END) {
                return END;
            }
            while ([(NSNumber *)[_Data objectAtIndex:n]floatValue] * 100 + 500 < _MaxDataGate && n + 1 < _ALLPOINT) {
                int s = ++n;
                n = [self GetMaxData:s];//n = GetMaxData(++n); // 从下一个点开始循环查找
            }
        } else {
            n = start + 1;
        }
    }
    return n;
}

/** 此处有深度递归，当第四次以后会不断循环获取重复的 R 波 已修改
 * 1、由MakeSureRPoint方法演变而来，将递归调用修改为循环调用，防止深度递归引发的bug
 * 2、为了防止FindRestRPoint一直执行下去，规定只能执行10次；
 *
 * @param start
 * @return R值的下标
 */
-(int)FindRestRPoint:(int)start{
    int NewR = [self FindRPoint:start];  //R波下标
    int i = 0;
    if (NewR != END) {
        int s = [(NSNumber *)[_RPoint objectAtIndex:_LastRPoint]floatValue];//_RPoint.get(LastRPoint)
        while (i < 5 && ((NewR - s< _MinRRInternal || NewR - s > _MaxRRInternal))) {
            if (NewR - s < _MinRRInternal) {
                if (_LastOperate == 0 || _LastOperate == LOWERMINRR) {
                    _LastOperate = LOWERMINRR;
                    _SlopePer = _SlopePer + _ChangePer;
                    _MaxSlopeGate = _MaxSlope * _SlopePer;
                    //NSLog(@"上次小等，这次小了啦");
                    NewR = [self FindRPoint:start];
                    if (NewR == END){
                        return NewR;
                    }
                } else {
                    _LastOperate = LOWERMINRR;
                    _SlopePer = _SlopePer + _ChangePer / 10;
                    _MaxSlopeGate = _MaxSlope * _SlopePer;
                    //NSLog(@"上次大，这次小了啦");
                    NewR = [self FindRPoint:start];
                    if (NewR == END){
                        return NewR;
                    }
                }
            } else if (NewR - s > _MaxRRInternal) {
                if (_LastOperate == 0 || _LastOperate == OVERMAXRR) {
                    _LastOperate = OVERMAXRR;
                    _SlopePer = _SlopePer - _ChangePer;
                    _MaxSlopeGate = _MaxSlope * _SlopePer;
                    //NSLog(@"上次大等，这次大了啦");
                    NewR = [self FindRPoint:(s + 100)];
                    if (NewR == END){
                        return NewR;
                    }
                } else {
                    _LastOperate = OVERMAXRR;
                    _SlopePer = _SlopePer - _ChangePer / 10;
                    _MaxSlopeGate = _MaxSlope * _SlopePer;
                    //NSLog(@"上次小，这次大了啦");
                    NewR = [self FindRPoint:(s + 100)];
                    if (NewR == END){
                        return NewR;
                    }
                }
            }
            i++;
        }
    }
    
    _ChangePer = 0.05f;//斜率阈值系数：0.55
    _LastOperate = 0;
    
    if (NewR != END) {
        ++_LastRPoint;
        //++_LastRPoint 后相当于顺序往_RPoint中加元素
        //在指定的位置上插入特定元素
        [_RPoint insertObject:[NSNumber numberWithInt:NewR] atIndex:_LastRPoint];
        //[_RPoint addObject:[NSNumber numberWithInt:NewR]];
        //[[_RPoint reverseObjectEnumerator] allObjects];
        //RPoint.add(LastRPoint, NewR);原操作把发现的 R 点放到LastRPoint的 index0里，LastRPoint初始化为0
        int rIndex = [(NSNumber *)[_RPoint objectAtIndex:_RPoint.count-1]intValue];
        NSLog(@"R波第%d个数据点，峰值为%@", rIndex, [_Data objectAtIndex:rIndex]);
    }
    _DataPer = _tempDataPer;
    _SlopePer = _tempSlopePer;
    _MaxSlopeGate = _MaxSlope * _SlopePer;
    //index 3394 beyond bounds [0 .. 1619]
    return NewR;
    
}

/**
 *
 * 以下方法在其他类中调用
 *
 */

/**
 * 获取R值下标的平均差
 *
 * @return
 */
-(float)GetRRInternal{
    if (_finishAnalyse) { // finishAnalyse = true;
        int period = 0;
        for (int i = 0; i < _RPoint.count - 1; i++) {
            int s = [(NSNumber *)[_RPoint objectAtIndex:i+1]intValue];
            int ss = [(NSNumber *)[_RPoint objectAtIndex:i]intValue];
            period = period + s - ss;
        }
        period = period / _RPoint.count - 1;
        return period;
    } else
        return 0;
}

/**
 * 得到本次数据的R波下标
 *
 * @return 返回真实的 R 波的下标
 */
-(NSMutableArray *)getAllRPoint{
    //public List<Integer> getAllRPoint()
    NSMutableArray * rPoint = [NSMutableArray array];
    for (int i = 0; i < _RPoint.count; i++) {
        int s = [(NSNumber *)[_RPoint objectAtIndex:i] intValue] + _startIndex;
        [rPoint addObject:[NSNumber numberWithInteger:s]];
        //执行以下方法cpu 和内存会爆掉，不能直接加到_RPoint中去
        //[_RPoint addObject:[NSNumber numberWithInt:s]];
        //[_RPoint insertObject:ss atIndex:i];//RPoint.set(i, RPoint.get(i) + startIndex);
    }
    NSLog(@"FindR检测后的 R 波下标是%@",_RPoint);
    NSLog(@"FindR检测后真实的 R 波下标是%@",rPoint);
    return rPoint;
}

/**
 * 计算心率 rate = (60 * (RPoint.size() - 1) * 360)/ ((RPoint.get(RPoint.size() - 1) - RPoint.get(0))
 *
 * @return
 */
-(int)getHeartRate{
    int rate = 0;
    if (_RPoint.count > 1) {
        int a = (int)_RPoint.count - 1;
        int s = [(NSNumber *)[_RPoint objectAtIndex:(_RPoint.count - 1)]intValue];//RPoint.get(RPoint.count - 1)
        int ss = [(NSNumber *)[_RPoint objectAtIndex:0]intValue];//RPoint.get(0)
        int sss = s-ss;
        rate = (60 * a * 360) / sss;
    }
    return rate;
}

/**
 * @return RR间期的方差值 (平均值-x)^2求和再除以 N
 */
-(float)getVariance{
    float variance = 0;
    float average = 0;
    NSMutableArray *RRPeriod = [NSMutableArray array]; //int[] RRPeriod = new int[RPoint.size() - 1];
    for (int i = 0; i < _RPoint.count - 1; i++) {
        int s = [(NSNumber *)[_RPoint objectAtIndex:(i+1)]intValue];//RPoint.get(i + 1)
        int ss = [(NSNumber *)[_RPoint objectAtIndex:i]intValue];//RPoint.get(i)
        int sss;//RRPeriod[i]
        sss = s -ss; // RRPeriod[i] = RPoint.get(i + 1) - RPoint.get(i);
        [RRPeriod addObject:[NSNumber numberWithInt:sss]];
        average += sss;//average += RRPeriod[i];
        //NSLog(@"FindR R点Index逐差的集合RRPeriod[i]=====%@",RRPeriod[i]);
    }
    
    average = average / (_RPoint.count - 1);//average = average/(RPoint.size() - 1);

    NSLog(@"average===%f",average);
    for (int i = 0; i < _RPoint.count - 1; i++) {
       double rr = [(NSNumber *)[RRPeriod objectAtIndex:i]doubleValue];//RRPeriod[i]
        variance += pow(rr, 2); //variance += Math.pow(RRPeriod[i] - average, 2);

    }
    variance = variance / (_RPoint.count - 1);
    return variance;
}

/**
 * 从start下标开始先FindRPoint，得到一个R点下标后和前一个R点进行比较，如果超出正常的RR间期，则修正数据重新查找。
 * LastOperate==0代表上次的判断在正常RR间期内，==1代表小于最小RR间期，==2代表大于最大RR间期
 * 太深的递归调用会引起崩溃，已弃用
 *
 * @param start
 */
-(void) MakeSureRPoint:(int)start{
    int NewR = [self FindRPoint:start];
    int s = [(NSNumber *)[_RPoint objectAtIndex:_LastRPoint]intValue];//RPoint.get(LastRPoint)
    if (NewR - s < _MinRRInternal) {
        if (_LastOperate == 0 || _LastOperate == LOWERMINRR) {
            _LastOperate = LOWERMINRR;
            _SlopePer = _SlopePer + _ChangePer;
            _MaxSlopeGate = _MaxSlope * _SlopePer;
            //print("上次大等，这次小了啦");
            [self MakeSureRPoint:NewR];//MakeSureRPoint(NewR);
        } else {
            _LastOperate = LOWERMINRR;
            _SlopePer = _SlopePer + _ChangePer / 10;
            _MaxSlopeGate = _MaxSlope * _SlopePer;
            //print("上次小，这次小了啦");
            [self MakeSureRPoint:NewR];
        }
        
    } else if (NewR - s > _MaxRRInternal) {
        if (_LastOperate == 0 || _LastOperate == OVERMAXRR) {
            _LastOperate = OVERMAXRR;
            _SlopePer = _SlopePer - _ChangePer;
            _MaxSlopeGate = _MaxSlope * _SlopePer;
            //print("上次大等，这次大了啦");
            [self MakeSureRPoint:(s+100)];//MakeSureRPoint(RPoint.get(LastRPoint) + 100);
        } else {
            _LastOperate = OVERMAXRR;
            _SlopePer = _SlopePer - _ChangePer / 10;
            _MaxSlopeGate = _MaxSlope * _SlopePer;
            //print("上次小，这次小了啦");
            [self MakeSureRPoint:(s + 100)];//MakeSureRPoint(RPoint.get(LastRPoint) + 100);
        }
    } else {
        _ChangePer = 0.05f;
        _LastOperate = 0;
        
        ++_LastRPoint;
        //在指定的位置上插入特定元素
        [_RPoint insertObject:[NSNumber numberWithInt:NewR] atIndex:_LastRPoint];//RPoint.add(LastRPoint, NewR);
        int rIndex = [(NSNumber *)[_RPoint objectAtIndex:_RPoint.count-1]intValue];
        NSLog(@"R波第%d个数据点，峰值为%@", rIndex, [_Data objectAtIndex:rIndex]);

    }
}
-(NSMutableArray *)getAvgList{
    return _avgList;
}
-(NSMutableArray *)getMin_avg{
    return _min_avg;
}
-(NSMutableArray *)getMax_avg{
    return _max_avg;
}
-(float)getLogData_slopeGate{
    return _logData_slopeGate;
}
-(float)getLogData_dateGate{
    return _logData_dateGate;
}

@end

