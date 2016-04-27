/**
 * @file FindTQS.java
 * @description 寻找TQS波类
 * @author Aries
 * @date 2015-6-19 下午9:46:44
 * @version 1.0
 */
#import "FindTQS.h"
/**
 * 在平均心率normalRR左右的偏移量对应c3-c4
 */
static int  OFFSET = 30; //private static final int OFFSET = 30;
/**
 * 大于波峰范围的值
 */

@interface FindTQS()
    /**
     * 待定t波起点
     */
@property(nonatomic, assign) float tStart;
    /**
     * 待定t波终点
     */
@property(nonatomic, assign) float tEnd;
    /**
     * R波点
     */
@property(nonatomic, assign) int rPoint;
@property(nonatomic, assign) int Qpoint, Spoint;
@property(nonatomic, assign) int QStart, SEnd;
    /**
     * 确定T波的常量，根据RR间期来适配c1-c2,c3-c4,c5-c6
     */
@property(nonatomic, assign) float c1, c2, c3, c4, c5, c6;
    /**
     * 本次检测的平均RR间期值
     */
@property(nonatomic, assign) float normalRR;

    /**
     * 实际RR间期
     */
@property(nonatomic, assign) float realRR;
    /**
     * 基线
     */
@property(nonatomic, assign) float baseLine;
    /**
     * tStart和tEnd之间的最大最小值
     */
@property(nonatomic, assign) float tMax, tMin;
    /**
     * tStart和tEnd之间的最大最小值对应的下标
     */
@property(nonatomic, assign) int tMaxPoint, tMinPoint;
    /**
     * 数据
     */
@property(nonatomic, strong) NSMutableArray *data;// private List<Float> data;
    // private float sfrequency; //采样频率
    /**
     * 波形方向
     */
@property(nonatomic, assign) Boolean  isUp;// private boolean isUp;
    /**
     * t波波峰所在点
     */
@property(nonatomic, assign) int tPoint;
    /**
     * 待定找出来的t波起点和终点
     */
@property(nonatomic, assign) int tempStart, tempEnd;
    /**
     * 最后找出来的t波起点和终点
     */
@property(nonatomic, assign) int tFinalStart, tFinalEnd;

@end


@implementation FindTQS
    /**
     * @param normalRR
     *            心搏平均值，用来对每次的心搏做评估
     * @param realRR
     * @param data
     */
-(instancetype)initWithNormalRR:(float)normalRR WithRealRR:(float)realRR WithData:(NSMutableArray *)data{
    //public FindTQS(float normalRR, float realRR, List<Float> data)
    if(self = [super init]){
        _data = data;//this.data=data;
        _realRR = realRR;//this.realRR=realRR;
        _normalRR = normalRR;//this.normalRR=normalRR;
        
        // 以下四个参数待定
        // c1,c2对应的状态：小于normalRR
        _c1 = 0.18f;
        _c2 = 0.5f;
        // c3,c4对应的状态：约等于normalRR
        _c3 = 0.12f;
        _c4 = 0.6f;
        // c5,c6对应的状态：大于normalRR
        _c5 = 0.1f;
        _c6 = 0.6f;
        // 以上四个参数要通过经验慢慢调节
    }
    return self;
}
    
    /**
     * 分析T波相关参数总入口 执行该方法后通过gettPoint获取t波波峰所在点,通过gettFinalStart
     * 和gettFinalEnd分别获取t波起点和终点 通过isUp()获取波形,true代表正向波，false代表负向波
     */
-(void)startToSearchT:(int)rPoint{
    //public void startToSearchT(int rPoint) {
    // Log.e("123", "rPoint========="+rPoint);
    _rPoint = rPoint;
    [self analyseTempStartAndEnd]; // 分析出待定T波区间内的起始和终点值（tStart和tEnd的值）analyseTempStartAndEnd();
    if(_tStart >= _data.count){
        [self setTPoint:0];//setpPoint(0);
        return;
    }
    if (_tEnd >= _data.count) {
        _tEnd = _data.count - 1;
    }
    // 分析出待定T波区间内的最大最小值
    [self analyseMaxAndMin];
    // 基线值
    self.baseLine = [(NSNumber *)[_data objectAtIndex:(int)_tStart] floatValue]+[(NSNumber *)[_data objectAtIndex:(int)_tEnd] floatValue]/2;//baseLine = (data.get((int) pStart) + data.get((int) pEnd)) / 2;
    // Math.abs()返回
    if (ABS(_tMax - _baseLine) > ABS(_tMin - _baseLine)) {
        //if (Math.abs(pMax - baseLine) > Math.abs(pMin - baseLine)) {
        // 参数值的绝对值
        // 设置倒置
        [self setIsUp:true];
        // 设置最大值
        [self setTPoint:_tMaxPoint];//setpPoint(pMaxPoint);
        //        Log.d("123", "我是向上的========pMaxPoint="+pMaxPoint);
    } else {
        [self setIsUp:false];//setUp(false);
        [self setTPoint:_tMinPoint];//setpPoint(pMinPoint);
        //        Log.d("123", "我是向下的========pMinPoint="+pMinPoint);
    }
    //    	Log.e("123", "我是起始点========(int) pStart="+(int) pStart);
    //    	Log.e("123", "我是峰值点========pPoint="+pPoint);
    //    	Log.e("123", "我是结束点========(int) pEnd="+(int) pEnd);
    
    //设置(T波的起点)
    [self setTFinalStart:[self findFinalStartAndEndTPointWithN0:(int)_tStart WithNe:(int)_tPoint]];
    //设置(P波的起点)
    [self setTFinalEnd:[self findFinalStartAndEndTPointWithN0:(int)_tPoint WithNe:(int)_tEnd]];
    //settFinalStart(findFinalStartAndEndTPoint((int) tStart, tPoint));
    //settFinalEnd(findFinalStartAndEndTPoint(tPoint, (int) tEnd));
    // tPoint就是最终找到的t波峰所在点,tFinalStart和tFinalEnd就是最终找到的t波起点和终点 isUp代表t波的波形，true代表正向波，false代表负向波

}
-(void)setTPoint:(int)tPoint{
    self.tPoint = tPoint;
}

-(void)setIsUp:(Boolean)isUp{
    self.isUp = isUp;
}
-(void)setPFinalStart:(int)pFinalStart{
    self.pFinalStart = pFinalStart;
}
-(void)setPFinalEnd:(int)pFinalEnd{
    self.pFinalEnd = pFinalEnd;
}

    /**
     * Q波检测
     */
-(void)findQSpoint{
    //public void findQSpoint() {
        float QslopeGate = 0;
        if (_rPoint - 3 > 0){
            // 经验阀值*斜率=斜率门限值
            float t  = [(NSNumber *)[_data objectAtIndex:_rPoint]floatValue];//data.get(rPoint)
            float tt = [(NSNumber *)[_data objectAtIndex:_rPoint-3]floatValue];//data.get(rPoint - 3)
            QslopeGate =  0.3f *(t - tt)/3;//QslopeGate = 0.3f * (data.get(rPoint) - data.get(rPoint - 3)) / 3;
        }
        for (int i = _rPoint; i >= 0; i--) {
            float a = [(NSNumber *)[_data objectAtIndex:i]floatValue];//data.get(i)
            float aa = [(NSNumber *)[_data objectAtIndex:(i-3)]floatValue];//data.get(i - 3)
            if (i - 3 >= 0 && (a - aa) / 3 < 0) {
                // 确认Q波。i是从R波下标往回确认
                if ([self makeSureQpoint:i WithSlopeGate:QslopeGate]) {//makeSureQpoint(i, QslopeGate)
                    [self setQpoint:i];
                    // 寻找Q波起点
                    [self setQStart:[self findQStart:i]];
                    break;
                }
            }
        }
        if (_rPoint + 5 < _data.count) {
        }
        for (int i = _rPoint + 2; i < _data.count; i++) {
            float b = [(NSNumber *)[_data objectAtIndex:i+5]floatValue];//data.get(i + 5)
            float bb = [(NSNumber *)[_data objectAtIndex:i]floatValue];// data.get(i)
            if (i + 5 < _data.count && (b - bb) > 0) {
                [self setSpoint:(i + 3)];
                break;
            }
        }
    }
    
    /**
     * 确认Q波下标
     *
     * @param Qpoint
     * @param slopeGate
     * @return
     */
-(Boolean)makeSureQpoint:(int)Qpoint WithSlopeGate:(float)slopeGate{
    //public boolean makeSureQpoint(int Qpoint, float slopeGate) {
        int start = Qpoint;
        int maxPoint = Qpoint;
        if (start - 10 >= 0) {
            for (int i = start; i > start - 10; i--) {
                float a = [(NSNumber *)[_data objectAtIndex:maxPoint]floatValue];//data.get(maxPoint)
                float aa = [(NSNumber *)[_data objectAtIndex:i]floatValue];//data.get(i)
                if (a < aa) {
                    // 设置点前10个数中最大值
                    maxPoint = i;
                }
            }
        }
        int prePoint = maxPoint;
        if (maxPoint - 5 >= 0) {
            prePoint = maxPoint - 5;
        } else {
            return true;
        }
        // 主要判断标准
        float b = [(NSNumber *)[_data objectAtIndex:maxPoint]floatValue];//(data.get(maxPoint)
        float bb = [(NSNumber *)[_data objectAtIndex:prePoint]floatValue];//data.get(prePoint)
        if ((b - bb) / 5 > slopeGate) {
            return false;
        } else {
            return true;
        }
    }
    
    /**
     * 确认S波下标
     *
     * @param Spoint
     * @param slopeGate
     * @return
     */
-(Boolean)makeSureSpoint:(int)Qpoint WithSlopeGate:(float)slopeGate{
    //public boolean makeSureSpoint(int Spoint, float slopeGate) {
        int start = _Spoint;
        int maxSoint = _Spoint;
        if (start + 3 < _data.count) {
            for (int i = start; i < start + 3; i++) {
                float a = [(NSNumber *)[_data objectAtIndex:maxSoint]floatValue];//(data.get(maxSoint)
                float aa = [(NSNumber *)[_data objectAtIndex:i]floatValue];//data.get(i)
                if (a < aa) {
                    maxSoint = i;
                }
            }
        }
        int endSoint = maxSoint;
        if (maxSoint + 1 < _data.count) {
            endSoint = maxSoint + 1;
        } else
            return true;
        float b = [(NSNumber *)[_data objectAtIndex:endSoint]floatValue];//data.get(endSoint)
        float bb = [(NSNumber *)[_data objectAtIndex:maxSoint]floatValue];//data.get(maxSoint))
        if ((b - bb) < 0) {
            
            return false;
        } else {
            return true;
        }
    }
    
    /**
     * Q波起止点检测，斜率最大的点视为Q波起点
     *
     * @param minQ
     *            Q波的谷值及下标
     * @return
     */
-(int) findQStart:(int)minQ{
    //public int findQStart(int minQ) {
        int start = minQ;
        float slope;
        if (minQ - 2 >= 0) {
            // 后一点的斜率
            float a = [(NSNumber *)[_data objectAtIndex:(minQ - 2)]floatValue];//data.get(minQ - 2)
            float aa = [(NSNumber *)[_data objectAtIndex:(minQ - 1)]floatValue];//data.get(minQ - 1)
            slope = a-aa;
            for (int i = minQ - 2; i > minQ - 10; i--) {
                if (i - 1 < 0 || i + 1 > _data.count) {
                    break;
                }
                // 前一点的斜率
                float b = [(NSNumber *)[_data objectAtIndex:(i - 1)]floatValue];//data.get(i - 1)
                float bb = [(NSNumber *)[_data objectAtIndex:(i + 1)]floatValue];//data.get(i + 1)
                if (slope < b - bb) {
                    start = i;
                }
            }
        }
        return start;
    }
    
    /**
     * 返回这段数据的QRS波群的下标差
     *
     * 改 利用Spoint-QStart
     *
     * @return
     */
-(float)getQRSAverage{
    //public float getQRSAverage() {
        float QRSAverage = 0;
        QRSAverage = _Spoint - _QStart;
        return QRSAverage;
    }
    
//    public int getQpoint() {
//        return Qpoint;
//    }
//    
//    public void setQpoint(int qpoint) {
//        Qpoint = qpoint;
//    }
//    
//    public int getSpoint() {
//        return Spoint;
//    }
//    
//    public void setSpoint(int spoint) {
//        Spoint = spoint;
//    }
    
    /**
     * 分析出待定T波区间内的起始和终点值（tStart和tEnd的值）
     */
-(void)analyseTempStartAndEnd{
    //public void analyseTempStartAndEnd() {
        // 首先这里realRR 代表的是此次心搏所包含的采样个数，而不是心率（时间上）
        if (_realRR < _normalRR - OFFSET) {
            _tStart = _rPoint + _c1 * _realRR;
            _tEnd = _rPoint + _c2 * _realRR;
            [self setTempStart:(int)_tStart];
            [self setTempEnd:(int)_tEnd];
            // Log.e("123", "realRR<<<<<<<<~~normalRR=====TTTTTTTTTT");
        } else if (_realRR > _normalRR - OFFSET && _realRR < _normalRR + OFFSET) {
            _tStart = _rPoint + _c3 * _realRR;
            _tEnd = _rPoint + _c4 * _realRR;
            [self setTempStart:(int) _tStart];
            [self setTempEnd:(int) _tEnd];
            // Log.e("123", "realRR===========~~normalRR======TTTTTTTTTT");
        } else {
            _tStart = _rPoint + _c5 * _realRR;
            _tEnd = _rPoint + _c6 * _realRR;
            [self setTempStart:(int) _tStart];
            [self setTempEnd:(int) _tEnd];
            // Log.e("123", "realRR>>>>>>>>>>~~normalRR======TTTTTTTTTT");
        }
    }
    
    /**
     * 分析出待定T波区间内的最大最小值
     */
-(void)analyseMaxAndMin{
    //public void analyseMaxAndMin() {
        float tempMax, tempMin;
        tempMax = [(NSNumber *)[_data objectAtIndex:(int)_tStart] floatValue];//tempMax = data.get((int) tStart);
        tempMin = [(NSNumber *)[_data objectAtIndex:(int)_tStart] floatValue];//tempMin = data.get((int) tStart);
        for (int i = (int) _tStart; i < _tEnd; i++) {
            float a = [(NSNumber *)[_data objectAtIndex:i] floatValue];//data.get(i))
            if (tempMax < a) {
                tempMax = a;
                _tMaxPoint = i;
            }
            if (tempMin > a) {
                tempMin = a;
                _tMinPoint = i;
            }
        }
        // tMax=tempMax;
        // tMin=tempMin;
        // 这个地方就是最大的错误
        _tMax = [(NSNumber *)[_data objectAtIndex:_tMaxPoint]floatValue];// tMax = data.get(tMaxPoint);
        _tMin = [(NSNumber *)[_data objectAtIndex:_tMinPoint]floatValue];// tMin = data.get(tMinPoint);
        // Log.e("123", "tMaxPoint最大值下标========"+tMaxPoint);
        // Log.e("123", "tMinPoint最小值下标========"+tMinPoint);
    }
    
    /**
     * Z(n)=f(n0)+(n-n0)(f(ne)-f(n0))/(ne-n0) n0<=n<=ne
     * 
     * @param n0
     *            ,ne为常量,n自变量
     * @return D(n),D(n)=|f(n)-z(n)|
     */
-(float)changeEquationWithN0:(int)n0 WithNe:(int)ne WithN:(int)n{
    //public float changeEquation(int n0, int ne, int n) {
        float z, d;
        z = [(NSNumber *)[_data objectAtIndex:n0] floatValue]+(n-n0)*([(NSNumber *)[_data objectAtIndex:ne] floatValue]-[(NSNumber *)[_data objectAtIndex:n0] floatValue])/(ne-n0);
        //z = data.get(n0) + (n - n0) * (data.get(ne) - data.get(n0)) / (ne - n0);
        d = ABS([(NSNumber *)[_data objectAtIndex:n] floatValue]-z);//d = Math.abs(data.get(n) - z);
        return d;
        
    }
    
    /**
     * n0为tPoint,ne为tEnd时，返回终点，n0为tStart,ne为tPoint时，返回起点 ne>n0
     * 
     * @param n0
     * @param ne
     * @return
     */
-(int)findFinalStartAndEndTPointWithN0:(int)n0 WithNe:(int)ne{
    //private int findFinalStartAndEndTPoint(int n0, int ne) {
        float result = [self changeEquationWithN0:n0 WithNe:ne WithN:n0];
        int m = n0;
        for (int i = n0; i <= ne; i++) {
            float a = [self changeEquationWithN0:n0 WithNe:ne WithN:i];//changeEquation(n0, ne, i)
            if (result < a) {
                result = a;
                m = i;
            }
        }
        return m;
        
    }
-(Boolean)isUpM{
    //public boolean isUp() {
        return _isUp;
    }
//    
//    public void setUp(boolean isUp) {
//        this.isUp = isUp;
//    }
//    
//    public int getTempStart() {
//        return tempStart;
//    }
//    
//    public void setTempStart(int tempStart) {
//        this.tempStart = tempStart;
//    }
//    
//    public int getTempEnd() {
//        return tempEnd;
//    }
//    
//    public void setTempEnd(int tempEnd) {
//        this.tempEnd = tempEnd;
//    }
//    
//    public int gettFinalStart() {
//        return tFinalStart;
//    }
//    
//    public void settFinalStart(int tFinalStart) {
//        this.tFinalStart = tFinalStart;
//    }
//    
//    public int gettFinalEnd() {
//        return tFinalEnd;
//    }
//    
//    public void settFinalEnd(int tFinalEnd) {
//        this.tFinalEnd = tFinalEnd;
//    }
//    
//    public int gettPoint() {
//        return tPoint;
//    }
//    
//    public void settPoint(int tPoint) {
//        this.tPoint = tPoint;
//    }
//    
//    public int getQStart() {
//        return QStart;
//    }
//    
//    public void setQStart(int qStart) {
//        QStart = qStart;
//    }
//    
//    public int getSEnd() {
//        return SEnd;
//    }
//    
//    public void setSEnd(int sEnd) {
//        SEnd = sEnd;
//    }
@end
