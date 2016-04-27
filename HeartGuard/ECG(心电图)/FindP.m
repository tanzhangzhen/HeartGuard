//
//  FindP.m
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "FindP.h"
#import <UIKit/UIKit.h>
/**
 * 在平均心率normalRR左右的偏移量对应c3-c4
 */
static int  OFFSET = 30; //private static final int OFFSET = 30;
/**
 * 大于波峰范围的值
 */
static int FLAG = 6; //private final int FLAG = 6;

@interface FindP ()
/**
 * 待定t波起点
 */
@property(nonatomic, assign) float pStart;
/**
 * 待定t波终点
 */
@property(nonatomic, assign) float pEnd;
/**
 * R波点
 */
@property(nonatomic, assign) int rPoint;
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
@property(nonatomic, assign) float pMax, pMin;
/**
 * tStart和tEnd之间的最大最小值对应的下标
 */
@property(nonatomic, assign) int pMaxPoint, pMinPoint;
/**
 * 数据
 */
@property(nonatomic, strong) NSMutableArray * data;//private List<Float> data;
/**
 * 波形方向
 */
@property(nonatomic, assign) Boolean isUp;//private boolean isUp;
/**
 * t波波峰所在点
 */
@property(nonatomic, assign) int pPoint;
/**
 * 待定找出来的t波起点和终点
 */
@property(nonatomic, assign) int tempStart, tempEnd;
/**
 * 最后找出来的t波起点和终点
 */
@property(nonatomic, assign) int pFinalStart, pFinalEnd;

@end


@implementation FindP


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
        _c1 = 0.62f;
        _c2 = 0.9f;
        // c3,c4对应的状态：约等于normalRR
        _c3 = 0.6f;
        _c4 = 0.9f;
        // c5,c6对应的状态：大于normalRR
        _c5 = 0.58f;
        _c6 = 0.9f;
        // 以上四个参数要通过经验慢慢调节
    }
    return self;
}
/**
 * 分析P波相关参数总入口 执行该方法后通过gettPoint获取t波波峰所在点,通过gettFinalStart
 * 和gettFinalEnd分别获取t波起点和终点 通过isUp()获取波形,true代表正向波，false代表负向波
 */
-(void)startToSearchT:(int)rPoint{
    //public void startToSearchT(int rPoint) {
    // Log.e("123", "rPoint========="+rPoint);
    _rPoint = rPoint;
    [self analyseTempStartAndEnd]; // 分析出待定T波区间内的起始和终点值（tStart和tEnd的值）analyseTempStartAndEnd();
        if(_pStart >= _data.count){
            [self setPPoint:0];//setpPoint(0);
        return;
    }
    if (_pEnd >= _data.count) {
        _pEnd = _data.count - 1;
    }
    // 分析出待定T波区间内的最大最小值
    [self analyseMaxAndMin];
    // 基线值
    self.baseLine = [(NSNumber *)[_data objectAtIndex:(int)_pStart] floatValue]+[(NSNumber *)[_data objectAtIndex:(int)_pEnd] floatValue]/2;
    //baseLine = (data.get((int) pStart) + data.get((int) pEnd)) / 2;
    // Math.abs()返回
    if (ABS(_pMax - _baseLine) > ABS(_pMin - _baseLine)) {
        //if (Math.abs(pMax - baseLine) > Math.abs(pMin - baseLine)) {
        // 参数值的绝对值
        // 设置倒置
        [self setIsUp:true];
        // 设置最大值
        [self setPPoint:_pMaxPoint];//setpPoint(pMaxPoint);
        //        Log.d("123", "我是向上的========pMaxPoint="+pMaxPoint);
    } else {
        [self setIsUp:false];//setUp(false);
        [self setPPoint:_pMinPoint];//setpPoint(pMinPoint);
        //        Log.d("123", "我是向下的========pMinPoint="+pMinPoint);
    }
    //    	Log.e("123", "我是起始点========(int) pStart="+(int) pStart);
    //    	Log.e("123", "我是峰值点========pPoint="+pPoint);
    //    	Log.e("123", "我是结束点========(int) pEnd="+(int) pEnd);
    
    //设置(T波的起点)
    [self setPFinalStart:[self findFinalStartTPointWithN0:(int)self.pStart WithNe:(int)self.pPoint]];
    //setpFinalStart(findFinalStartTPoint((int) pStart, pPoint));
    //设置(P波的起点)
    [self setPFinalEnd:[self findFinalEndTPointWithN0:(int)self.pPoint WithNe:(int)self.pEnd]];
    //setpFinalEnd(findFinalEndTPoint(pPoint, (int) pEnd));
    //    		Log.e("123", "pFinalStart========"+pFinalStart);
    //    		Log.e("123", "pFinalEnd========"+pFinalEnd);
    //tPoint就是最终找到的t波峰所在点,tFinalStart和tFinalEnd就是最终找到的t波起点和终点isUp代表t波的波形，true代表正向波，false代表负向波
}
-(void)setPPoint:(int)pPoint{
    self.pPoint = pPoint;
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
 * 分析出待定T波区间内的起始和终点值（tStart和tEnd的值）
 */
-(void)analyseTempStartAndEnd{
    // 首先这里realRR 代表的是此次心搏所包含的采样个数，而不是心率（时间上）
    if (self.realRR < self.normalRR - OFFSET) {
        self.pStart = self.rPoint + self.c1 * self.realRR;
        self.pEnd = self.rPoint + self.c2 * self.realRR;
        [self setTempStart:(int)self.pStart];// setTempStart((int) pStart);
        [self setTempEnd:(int)self.pEnd];// setTempEnd((int) pEnd);
        // Log.d("123", "realRR~~<<<<<<~~normalRR=========");
    } else if (self.realRR > self.normalRR - OFFSET && self.realRR < self.normalRR + OFFSET) {
        self.pStart = self.rPoint + self.c3 * self.realRR;
        self.pEnd = self.rPoint + self.c4 * self.realRR;
        [self setTempStart:(int)self.pStart];// setTempStart((int) pStart);
        [self setTempEnd:(int)self.pEnd];// setTempEnd((int) pEnd);
        // Log.d("123", "realRR~========~normalRR*********");
    } else {
        self.pStart = self.rPoint + self.c5 * self.realRR;
        self.pEnd = self.rPoint + self.c6 * self.realRR;
        [self setTempStart:(int)self.pStart];// setTempStart((int) pStart);
        [self setTempEnd:(int)self.pEnd];// setTempEnd((int) pEnd);
        // Log.d("123", "realRR~>>>>>>>>>~~normalRR=========");
    }
}
-(void)setTempStart:(int)tempStart{
    self.tempStart = tempStart;
}
-(void)setTempEnd:(int)tempEnd{
    self.tempEnd = tempEnd;
}

/**
 * 分析出待定T波区间内的最大最小值，即T波波峰点
 */
-(void)analyseMaxAndMin{
    float tempMax, tempMin;
    tempMax = [(NSNumber *)[_data objectAtIndex:(int)_pStart] floatValue];//tempMax = data.get((int) pStart);
    tempMin = [(NSNumber *)[_data objectAtIndex:(int)_pStart] floatValue];//tempMin = data.get((int) pStart);
    for (int i = (int) _pStart; i < _pEnd; i++) {//for (int i = (int) pStart; i < pEnd; i++)
        if (tempMax < [(NSNumber *)[_data objectAtIndex:i]floatValue]) {//if (tempMax < data.get(i)) {

            tempMax = [(NSNumber *)[_data objectAtIndex:i]floatValue];//tempMax = data.get(i);
            _pMaxPoint = i;//_pMaxPoint = i;
        }
        if (tempMin < [(NSNumber *)[_data objectAtIndex:i]floatValue]) {//if (tempMin > data.get(i)) {
            tempMin = [(NSNumber *)[_data objectAtIndex:i]floatValue];//tempMin = data.get(i);
            _pMinPoint = i;//_pMinPoint = i;
        }
    }
    //这个地方就是最大的错误
    _pMax = [(NSNumber *)[_data objectAtIndex:(int)_pMaxPoint] floatValue];//data.get(pMaxPoint);
    _pMin = [(NSNumber *)[_data objectAtIndex:(int)_pMinPoint] floatValue];//pMin = data.get(pMinPoint);
    // Log.e("123", "tMaxPoint最大值下标========"+pMaxPoint);
    // Log.e("123", "tMinPoint最小值下标========"+pMinPoint);
}


/**
 * Z(n)=f(n0)+(n-n0)(f(ne)-f(n0))/(ne-n0) n0<=n<=ne
 *
 * @param n0
 *            ,ne为常量,n自变量
 * @return D(n),D(n)=|f(n)-z(n)|
 */
-(float)changeEquationStartWithN0:(int)n0 WithNe:(int)ne WithN:(int)n{
    float z, d;
    z = [(NSNumber *)[_data objectAtIndex:n0] floatValue]+(n-n0)*([(NSNumber *)[_data objectAtIndex:ne] floatValue]-[(NSNumber *)[_data objectAtIndex:n0] floatValue])/(ne-n0);
    //z = data.get(n0) + (n - n0) * (data.get(ne) - data.get(n0)) / (ne - n0);
    d = ABS([(NSNumber *)[_data objectAtIndex:n] floatValue]-z);//d = Math.abs(data.get(n) - z);
    // Log.d("123", "data.get(n)========"+data.get(n));
    // Log.d("123", "z========"+z);
    // Log.d("123", "Math.abs(data.get(n)-z)========"+d);
    return d;
}

/**
 * Z(n)=f(n0)+(n-n0)(f(ne)-f(n0))/(ne-n0) n0<=n<=ne
 *
 * @param n0
 *            ,ne为常量,n自变量
 * @return D(n),D(n)=|f(n)-z(n)|
 */
-(float)changeEquationEndWithN0:(int)n0 WithNe:(int)ne WithN:(int)n{
    float z, d;
    z = [(NSNumber *)[_data objectAtIndex:n0] floatValue]+(n-ne)*([(NSNumber *)[_data objectAtIndex:ne] floatValue]-[(NSNumber *)[_data objectAtIndex:n0] floatValue])/(ne-n0);
    //    z = data.get(n0) + (n - ne) * (data.get(ne) - data.get(n0)) / (ne - n0);
    d = ABS([(NSNumber *)[_data objectAtIndex:n] floatValue]-z);//    d = Math.abs(data.get(n) - z);
    return d;
}

/**
 * n0为tPoint,ne为tEnd时，返回终点，n0为tStart,ne为tPoint时，返回起点 ne>n0
 *
 * @param n0
 * @param ne
 * @return
 */
-(int)findFinalStartTPointWithN0:(int)n0 WithNe:(int)ne{
    //private int findFinalStartTPoint(int n0, int ne)
    float result = [self changeEquationStartWithN0:n0 WithNe:ne WithN:n0];//float result = changeEquationStart(n0, ne, n0);
    // Log.e("123", "最大值是多少啊========"+result);
    int m = n0;
    for (int i = n0 + 1; i <= ne; i++) {
        float d = [self changeEquationStartWithN0:n0 WithNe:ne WithN:i]; //float d = changeEquationStart(n0, ne, i);
        if (result < d) {
            result = d;
            m = i;
            // Log.e("123", "最大值是多少啊========"+result);
        }
        // Log.d("123", "findFinalStartTPoint起始值是多少啊========"+m);
    }
    
    return m;
    
}
/**
 * n0为tPoint,ne为tEnd时，返回终点，n0为tStart,ne为tPoint时，返回起点 ne>n0
 *
 * @param n0
 * @param ne
 * @return
 */
-(int) findFinalEndTPointWithN0:(int)n0 WithNe:(int)ne{
    //private int findFinalEndTPoint(int n0, int ne)
    float result = [self changeEquationEndWithN0:n0 WithNe:ne WithN:n0];//    float result = changeEquationEnd(n0, ne, n0);
    int m = n0;
    for (int i = n0; i <= ne; i++) {
        float d = [self changeEquationEndWithN0:n0 WithNe:ne WithN:i];
        if (result < d) {
            result = d;
            m = i;
        }
        // Log.d("123", "findFinalStartTPoint终点值是多少啊========"+m);
    }
    return m;
}

/**
 * 判断P波是否存在异常（增宽，双峰，增高） 应该建立在这样的前提下：
 *
 * 增宽：原本P波大于0.11s
 *
 * 增高：原本P波波峰高于0线值，P波峰高于0线2.5mm，即0.25mv
 *
 * @return 返回双峰p波的下标值
 */
// 在其他函数中调用
-(int)getDoublePpoint{
    // 存放双峰p波的下标值
    int maxpoint1 = _pPoint - FLAG;
    int maxpoint2 = _pPoint + FLAG;
    // 假定最大值
    float max1 = [(NSNumber *)[_data objectAtIndex:_pFinalStart] floatValue];//float max1 = data.get(this.pFinalStart);
    float max2 = [(NSNumber *)[_data objectAtIndex:_pFinalEnd] floatValue];//float max2 = data.get(this.pFinalEnd);
    if (_pFinalEnd - _pFinalStart > 39) {
        // 从pFinalStart向p点偏移FLAG点找最大值，若不是pPoint-FLAG说明可能存在双峰
        for (int i = _pFinalStart; i < _pPoint - FLAG + 1; i++) {
            if (max1 < [(NSNumber *)[_data objectAtIndex:i] floatValue]) {//max1 < data.get(i)
                max1 = [(NSNumber *)[_data objectAtIndex:i] floatValue];//max1 = data.get(i);
                maxpoint1 = i;
                // Log.e("123444444",
                // "max1最大值是什么啊"+max1+"最大值下标呢是什么啊"+maxpoint1);
            }
        }
        // 从p点偏移FLAG点向pFinalEnd找最大值，若不是pPoint+FLAG说明可能存在双峰
        for (int i = _pPoint + FLAG; i < _pFinalEnd; i++) {
            if (max2 < [(NSNumber *)[_data objectAtIndex:i] floatValue]) {//max2 < data.get(i)
                max2 = [(NSNumber *)[_data objectAtIndex:i] floatValue];//max2 = data.get(i);
                maxpoint2 = i;
                // Log.e("123444444",
                // "max2最大值是什么啊"+max2+"最大值下标呢是什么啊"+maxpoint2);
            }
        }
        if ((maxpoint1 != (_pPoint - FLAG))
            && ([(NSNumber *)[_data objectAtIndex:maxpoint1] floatValue] > [(NSNumber *)[_data objectAtIndex:_pPoint-FLAG] floatValue])
            && ABS(max1-[(NSNumber *)[_data objectAtIndex:_pPoint] floatValue]) < 0.05) {//data.get(maxpoint1  //data.get(this.pPoint - FLAG)) //Math.abs(max1 - data.get(this.pPoint))
            return maxpoint1;
        }
        if ((maxpoint2 != (_pPoint + FLAG))
            && ([(NSNumber *)[_data objectAtIndex:maxpoint2] floatValue] > [(NSNumber *)[_data objectAtIndex:_pPoint+FLAG] floatValue])
            && ABS(max2-[(NSNumber *)[_data objectAtIndex:_pPoint] floatValue]) < 0.05) {//data.get(maxpoint2  //data.get(this.pPoint + FLAG)) //Math.abs(max2 - data.get(this.pPoint))
            return maxpoint2;
        }
    }
    
    return 0;
}

-(Boolean)isUpM{
//public boolean isUp() {
    return _isUp;
}

//public void setUp(boolean isUp) {
//    this.isUp = isUp;
//}
//
//public int getTempStart() {
//    return tempStart;
//}
//
//public void setTempStart(int tempStart) {
//    this.tempStart = tempStart;
//}
//
//public int getTempEnd() {
//    return tempEnd;
//}
//
//public void setTempEnd(int tempEnd) {
//    this.tempEnd = tempEnd;
//}
//
//public float getpStart() {
//    return pStart;
//}
//
//public void setpStart(float pStart) {
//    this.pStart = pStart;
//}
//
//public float getpEnd() {
//    return pEnd;
//}
//
//public void setpEnd(float pEnd) {
//    this.pEnd = pEnd;
//}
//
//public int getpPoint() {
//    return pPoint;
//}
//
//public void setpPoint(int pPoint) {
//    this.pPoint = pPoint;
//}
//
//public int getpFinalStart() {
//    return pFinalStart;
//}
//
//public void setpFinalStart(int pFinalStart) {
//    this.pFinalStart = pFinalStart;
//}
//
//public int getpFinalEnd() {
//    return pFinalEnd;
//}
//
//public void setpFinalEnd(int pFinalEnd) {
//    this.pFinalEnd = pFinalEnd;
//}

@end
