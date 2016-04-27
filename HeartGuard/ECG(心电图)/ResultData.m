//
//  ResultData.m
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "ResultData.h"

@interface ResultData()

@property(nonatomic, strong) NSMutableArray * logData_dataGate;//    private List<Float> logData_dataGate;
@property(nonatomic, strong) NSMutableArray * logData_slopeGate;//    private List<Float> logData_slopeGate;
@property(nonatomic, strong) NSMutableArray * logData_ifPositive;//    private List<String> logData_ifPositive;
@property(nonatomic, strong) NSMutableArray * avgList;//    private List<Float> avgList;
@property(nonatomic, strong) NSMutableArray * max_avg;//    private List<Float> max_avg;
@property(nonatomic, strong) NSMutableArray * min_avg;//    private List<Float> min_avg;
@property(nonatomic, strong) NSMutableArray * Tstart;//    private ArrayList<Integer> Tstart;
@property(nonatomic, strong) NSMutableArray * Tend;//    private ArrayList<Integer> Tend;
@property(nonatomic, strong) NSMutableArray * tempTstart;//    private ArrayList<Integer> tempTstart;
@property(nonatomic, strong) NSMutableArray * tempTend;//    private ArrayList<Integer> tempTend;
@property(nonatomic, assign) int R_Answer;					//R点的导诊答案
@property(nonatomic, assign) int T_Answer;					//T点的导诊答案
@property(nonatomic, assign) int P_Answer;					//P点的导诊答案
@property(nonatomic, assign) int SEQUENCE_Answer;			//顺序问题的导诊答案
    /**
     * 双峰P波，或者说是P波增宽的下标值
     */
@property(nonatomic, strong) NSMutableArray * DoubleP;//private ArrayList<Integer> DoubleP;
    /**
     * P波的方向
     */
@property(nonatomic, strong) NSMutableArray * PIsUp;//    private ArrayList<Boolean> PIsUp;
@property(nonatomic, strong) NSMutableArray * Pstart;//    private ArrayList<Integer> Pstart;
@property(nonatomic, strong) NSMutableArray * Pend;//    private ArrayList<Integer> Pend;
    /**
     * T波的方向
     */
@property(nonatomic, strong) NSMutableArray * TIsUp;//    private ArrayList<Boolean> TIsUp;
@property(nonatomic, strong) NSMutableArray * tempPstart;//    private ArrayList<Integer> tempPstart;
@property(nonatomic, strong) NSMutableArray * tempPend;//    private ArrayList<Integer> tempPend;
@property(nonatomic, strong) NSMutableArray * Qpoint;//    private ArrayList<Integer> Qpoint;
@property(nonatomic, strong) NSMutableArray * Qstart;//    private ArrayList<Integer> Qstart;
@property(nonatomic, strong) NSMutableArray * Spoint;//    private ArrayList<Integer> Spoint;
@property(nonatomic, strong) NSMutableArray * Rpoint;//    private ArrayList<Integer> Rpoint;
@property(nonatomic, strong) NSMutableArray * Tpoint;//    private ArrayList<Integer> Tpoint;
@property(nonatomic, strong) NSMutableArray * Ppoint;//    private ArrayList<Integer> Ppoint;
    /**
     * TP段，基线值
     */
@property(nonatomic, strong) NSMutableArray *Baseline;//    private ArrayList<Float> Baseline;
//    public ArrayList<Float> getBaseline() {
//        return Baseline;
//    }
//    public void setBaseline(ArrayList<Float> baseline) {
//        Baseline = baseline;
//    }
    
    /**
     * 平均PR间期
     */
@property(nonatomic, assign) float AveragePR;

    /**
     * 主要病症
     */
@property(nonatomic, strong) NSString *Symptoms;
    /**
     * 存放方差
     */
@property(nonatomic, strong) NSMutableArray *Variance;//ArrayList<Float> Variance=new ArrayList<Float>();
    /**
     * 存放QRS的平均值，方便与方差配对使用，鉴别室上性，室性
     */
@property(nonatomic, strong) NSMutableArray *QRSAverage;//private ArrayList<Float> QRSAverage=new ArrayList<Float>();
    /**
     * 存放QRS的平均值，方便与方差配对使用，鉴别室上性，室性
     */
@property(nonatomic, strong) NSMutableArray *NewQRSAverage;//private ArrayList<ArrayList<Float>> NewQRSAverage ;

    /**
     * 存放心室期前收缩的R波下标
     */
@property(nonatomic, strong) NSMutableArray *PrematureVentricualrContractionIndex;//private ArrayList<Integer> PrematureVentricualrContractionIndex ;
    
    /**
     * 存放心房期前收缩的对应R波下标
     */
@property(nonatomic, strong) NSMutableArray *AtrialPrematureBeatIndex;//private ArrayList<Integer> AtrialPrematureBeatIndex ;
    
    /**
     * 整段数据的RR间期的差值（心室率）
     */
@property(nonatomic, strong) NSMutableArray *RRInternal;//private ArrayList<Integer> RRInternal ;
    /**
     * 整段数据的存在多少个窦性停搏
     */
@property(nonatomic, assign) int SinusArrest ;
    /**
     * 存放每个方差对应的R波
     */
@property(nonatomic, strong) NSMutableArray *NewRpointList;//private ArrayList<ArrayList<Integer>> NewRpointList ;
    
    /**
     * 存放RR间期的平均值
     */
@property(nonatomic, assign) float RRAverage;
    /**
     * 弃用
     * 早搏个数（包括室上性，室性）
     */
@property(nonatomic, assign) int PrematureBeat;//int PrematureBeat=0;
    /**
     * 室上性个数   小于42
     */
@property(nonatomic, assign) int AtrialPrematureBeat;//int AtrialPrematureBeat = 0
    /**
     * 室性个数 大于42
     */
@property(nonatomic, assign) int PrematureVentricualrContraction;//int PrematureVentricualrContraction = 0
    /**
     * RR平均心率
     */
@property(nonatomic, assign) int AverageHeart_rate;//int AverageHeart_rate = 0
    /**
     * 整段数据的RR平均心率
     */
@property(nonatomic, strong) NSMutableArray *AllAverageHeart_rate;//private ArrayList<Integer> AllAverageHeart_rate ;
    /**
     * 每4.5秒数据的RR平均心率
     */
@property(nonatomic, strong) NSMutableArray *ItemAverageHeart_rate;//private ArrayList<Integer> ItemAverageHeart_rate ;
    
    /**
     * R心跳个数
     */
@property(nonatomic, assign) int R;//int R = 0
    /**
     * QRS平均时间
     */
@property(nonatomic, assign) float AverageQRS;//float AverageQRS = 0
    /**
     * QT平均时间
     */
@property(nonatomic, assign) float AverageQT;// float AverageQT = 0
    /**
     * QTcB平均时间
     */
@property(nonatomic, assign) double AverageQTcB;//double AverageQTcB = 0

@end

@implementation ResultData

-(instancetype)init{
    if (self = [super init]) {
        _logData_dataGate = [NSMutableArray array]; //        logData_dataGate= new ArrayList<Float>();
        _logData_slopeGate = [NSMutableArray array];//        logData_slopeGate= new ArrayList<Float>();
        _logData_ifPositive = [NSMutableArray array];//        logData_ifPositive= new ArrayList<String>();
        _avgList = [NSMutableArray array];//        avgList=new ArrayList<Float>();
        _max_avg = [NSMutableArray array];//        max_avg=new ArrayList<Float>();
        _min_avg = [NSMutableArray array];//        min_avg=new ArrayList<Float>();
        _Tstart = [NSMutableArray array];//        Tstart=new ArrayList<Integer>();
        _Tend = [NSMutableArray array];//        Tend=new ArrayList<Integer>();
        _tempTstart = [NSMutableArray array];//        tempTstart=new ArrayList<Integer>();
        _tempTend = [NSMutableArray array];//        tempTend=new ArrayList<Integer>();
     
        _DoubleP = [NSMutableArray array];//        DoubleP=new ArrayList<Integer>();
        _Pstart = [NSMutableArray array];//        Pstart=new ArrayList<Integer>();
        _Pend = [NSMutableArray array];//        Pend=new ArrayList<Integer>();
        _tempPstart = [NSMutableArray array];//        tempPstart=new ArrayList<Integer>();
        _tempPend = [NSMutableArray array];//        tempPend=new ArrayList<Integer>();
        _Qpoint = [NSMutableArray array];//        Qpoint=new ArrayList<Integer>();
        _Spoint = [NSMutableArray array];//        Spoint=new ArrayList<Integer>();
        _Rpoint = [NSMutableArray array];//        Rpoint=new ArrayList<Integer>();
        _Tpoint = [NSMutableArray array];//        Tpoint=new ArrayList<Integer>();
        _Ppoint = [NSMutableArray array];//        Ppoint=new ArrayList<Integer>();
        _TIsUp = [NSMutableArray array];//        TIsUp=new ArrayList<Boolean>();
        _PIsUp = [NSMutableArray array];//        PIsUp=new ArrayList<Boolean>();
      
        _Qstart = [NSMutableArray array];//        Qstart=new ArrayList<Integer>();
        _Baseline = [NSMutableArray array];//        Baseline=new ArrayList<Float>();
        _NewQRSAverage = [NSMutableArray array];//        NewQRSAverage=new ArrayList<ArrayList<Float>>();
        _RRInternal = [NSMutableArray array];//        RRInternal=new ArrayList<Integer>();
        _NewRpointList = [NSMutableArray array];//        NewRpointList=new ArrayList<ArrayList<Integer>>();
  
        _PrematureVentricualrContractionIndex = [NSMutableArray array];//        PrematureVentricualrContractionIndex=new ArrayList<Integer>();
        _AtrialPrematureBeatIndex = [NSMutableArray array];//        AtrialPrematureBeatIndex=new ArrayList<Integer>();
        _AllAverageHeart_rate = [NSMutableArray array];//        AllAverageHeart_rate=new ArrayList<Integer>();
        _ItemAverageHeart_rate = [NSMutableArray array];//        ItemAverageHeart_rate=new ArrayList<Integer>();

    }
        return self;
}

-(void)countAverageQRS{
    //public void countAverageQRS() {
    float sum = 0;
    for (int i = 0; i < _QRSAverage.count; i++) {
        float s = [(NSNumber *)[_QRSAverage objectAtIndex:i]floatValue];//QRSAverage.get(i)
        sum += s;
    }
    _AverageQRS = sum / _QRSAverage.count / 360 * 1000;
}
-(void)countAverageQT{
    //public void countAverageQT() {
    float sum = 0;
    int index = 0;
    for (int i = 0; i < _Qpoint.count; i++) {
//        try {
//            float s = [(NSNumber *)[_Qpoint objectAtIndex:i]floatValue];//(Qpoint.get(i)
//            float ss = [(NSNumber *)[_Tpoint objectAtIndex:i]floatValue];//(Tpoint.get(i)
//            if (s != 0 && ss != 0) {
//                sum += ss - s;//sum += Tpoint.get(i) - Qpoint.get(i);
//                index++;
//            }
//        } catch (Exception e) {
//            // Tpoint.size()<=i
//        }
    }
    _AverageQT = sum / index / 360 * 1000;
}
-(void)countAveragePR{
    //public void countAveragePR() {
    float sum = 0;
    int index = 0;
    for (int i = 0; i < _Ppoint.count; i++) {
        
//        try {
//            float s = [(NSNumber *)[_Rpoint objectAtIndex:i]floatValue];//(Rpoint.get(i)
//            float ss = [(NSNumber *)[_Ppoint objectAtIndex:i]floatValue];//(Ppoint.get(i)
//            float sss = [(NSNumber *)[_Ppoint objectAtIndex:i+1]floatValue];//Rpoint.get(i + 1)
//            if (s!= 0 && ss != 0
//                && i + 1 < _Rpoint.count) {//Rpoint.get(i) != 0 && Ppoint.get(i) != 0 && i + 1 < Rpoint.size()) {
//                sum += sss - ss;//sum += Rpoint.get(i + 1) - Ppoint.get(i);
//                index++;
//            }
//        } catch (Exception e) {
//            // Tpoint.size()<=i
//        }
    }
    _AveragePR = sum / index / 360 * 1000;
}
-(void)countAverageQTcB{
    //public void countAverageQTcB() {
//q1    _AverageQTcB = _AverageQT / Math.sqrt(RRAverage / 1000);
}
-(NSMutableArray *)getVariance{
    //public ArrayList<Float> getVariance() {
    return _Variance;
}
-(NSMutableArray *)getLogData_ifPositive{
    return _logData_ifPositive;
}
@end

//public List<Float> getLogData_dataGate() {
//    return logData_dataGate;
//}
//public void setLogData_dataGate(List<Float> logData_dataGate) {
//    this.logData_dataGate = logData_dataGate;
//}
//public List<Float> getLogData_slopeGate() {
//    return logData_slopeGate;
//}
//public void setLogData_slopeGate(List<Float> logData_slopeGate) {
//    this.logData_slopeGate = logData_slopeGate;
//}
//public List<String> getLogData_ifPositive() {
//    return logData_ifPositive;
//}
//public void setLogData_ifPositive(List<String> logData_ifPositive) {
//    this.logData_ifPositive = logData_ifPositive;
//}
//public List<Float> getAvgList() {
//    return avgList;
//}
//public void setAvgList(List<Float> avgList) {
//    this.avgList = avgList;
//}
//public List<Float> getMax_avg() {
//    return max_avg;
//}
//public void setMax_avg(List<Float> max_avg) {
//    this.max_avg = max_avg;
//}
//public List<Float> getMin_avg() {
//    return min_avg;
//}
//public void setMin_avg(List<Float> min_avg) {
//    this.min_avg = min_avg;
//}
//public ArrayList<Integer> getTstart() {
//    return Tstart;
//}
//public void setTstart(ArrayList<Integer> tstart) {
//    Tstart = tstart;
//}
//public ArrayList<Integer> getTend() {
//    return Tend;
//}
//public void setTend(ArrayList<Integer> tend) {
//    Tend = tend;
//}
//public ArrayList<Integer> getTempTstart() {
//    return tempTstart;
//}
//public void setTempTstart(ArrayList<Integer> tempTstart) {
//    this.tempTstart = tempTstart;
//}
//public ArrayList<Integer> getTempTend() {
//    return tempTend;
//}
//public ArrayList<Integer> getTpoint() {
//    return Tpoint;
//}
//public void setTpoint(ArrayList<Integer> tpoint) {
//    Tpoint = tpoint;
//}
//public ArrayList<Integer> getPpoint() {
//    return Ppoint;
//}
//public void setPpoint(ArrayList<Integer> ppoint) {
//    Ppoint = ppoint;
//}
//public void setTempTend(ArrayList<Integer> tempTend) {
//    this.tempTend = tempTend;
//}
//public ArrayList<Integer> getQpoint() {
//    return Qpoint;
//}
//public void setQpoint(ArrayList<Integer> qpoint) {
//    Qpoint = qpoint;
//}
//public ArrayList<Integer> getSpoint() {
//    return Spoint;
//}
//public void setSpoint(ArrayList<Integer> spoint) {
//    Spoint = spoint;
//}
//public ArrayList<Integer> getRpoint() {
//    return Rpoint;
//}
//public void setRpoint(ArrayList<Integer> rpoint) {
//    Rpoint = rpoint;
//}
//
//public ArrayList<Float> getVariance() {
//    return Variance;
//}
//public void setVariance(ArrayList<Float> variance) {
//    Variance = variance;
//}
//public ArrayList<Float> getQRSAverage() {
//    return QRSAverage;
//}
//public void setQRSAverage(ArrayList<Float> qRSAverage) {
//    QRSAverage = qRSAverage;
//}
//public int getPrematureBeat() {
//    return PrematureBeat;
//}
//public void setPrematureBeat(int prematureBeat) {
//    PrematureBeat = prematureBeat;
//}
//public int getAtrialPrematureBeat() {
//    return AtrialPrematureBeat;
//}
//public void setAtrialPrematureBeat(int atrialPrematureBeat) {
//    AtrialPrematureBeat = atrialPrematureBeat;
//}
//public int getPrematureVentricualrContraction() {
//    return PrematureVentricualrContraction;
//}


//public void setPrematureVentricualrContraction(
//                                               int prematureVentricualrContraction) {
//    PrematureVentricualrContraction = prematureVentricualrContraction;
//}

//public int getR() {
//    return R;
//}
//public void setR(int r) {
//    R = r;
//}
//public float getAverageQRS() {
//    
//    return AverageQRS;
//}
//public void countAverageQRS(){
//    float sum = 0;
//    for(int i = 0; i <QRSAverage.size(); i++){
//        sum += QRSAverage.get(i);
//    }
//    AverageQRS=sum/QRSAverage.size()/360*1000;
//}
//public void setAverageQRS(float averageQRS) {
//    AverageQRS = averageQRS;
//}
//public String getSymptoms() {
//    return Symptoms;
//}
//public void setSymptoms(String symptoms) {
//    Symptoms = symptoms;
//}
//public ArrayList<Integer> getDoubleP() {
//    return DoubleP;
//}
//public void setDoubleP(ArrayList<Integer> doubleP) {
//    DoubleP = doubleP;
//}
//public ArrayList<Integer> getPstart() {
//    return Pstart;
//}
//public void setPstart(ArrayList<Integer> pstart) {
//    Pstart = pstart;
//}
//public ArrayList<Integer> getPend() {
//    return Pend;
//}
//public void setPend(ArrayList<Integer> pend) {
//    Pend = pend;
//}
//public ArrayList<Integer> getTempPstart() {
//    return tempPstart;
//}
//public void setTempPstart(ArrayList<Integer> tempPstart) {
//    this.tempPstart = tempPstart;
//}
//public ArrayList<Integer> getTempPend() {
//    return tempPend;
//}
//public void setTempPend(ArrayList<Integer> tempPend) {
//    this.tempPend = tempPend;
//}
//public float getAverageQT() {
//    
//    return AverageQT;
//}
//public void countAverageQT(){
//    float sum = 0;
//    int index=0;
//    for(int i = 0; i <Qpoint.size(); i++){
//        try{
//            if(Qpoint.get(i)!=0&&Tpoint.get(i)!=0){
//                sum += Tpoint.get(i)-Qpoint.get(i);
//                index++;
//            }
//        }catch(Exception e){
//            //Tpoint.size()<=i
//        }
//    }
//    AverageQT=sum/index/360*1000;
//}
//public void setAverageQT(float averageQT) {
//    
//    AverageQT = averageQT;
//}
//public int getAverageHeart_rate() {
//    return AverageHeart_rate;
//}
//public void setAverageHeart_rate(int averageHeart_rate) {
//    AverageHeart_rate = averageHeart_rate;
//}
//public float getRRAverage() {
//    return RRAverage;
//}
//public void setRRAverage(float rRAverage) {
//    RRAverage = rRAverage;
//}
//public float getAveragePR() {
//    return AveragePR;
//}
//
//public void countAveragePR(){
//    float sum = 0;
//    int index=0;
//    for(int i = 0; i <Ppoint.size(); i++){
//        try{
//            if(Rpoint.get(i)!=0&&Ppoint.get(i)!=0&&i+1<Rpoint.size()){
//                sum += Rpoint.get(i+1)-Ppoint.get(i);
//                index++;
//            }
//        }catch(Exception e){
//            //Tpoint.size()<=i
//        }
//    }
//    AveragePR=sum/index/360*1000;
//}
//public void setAveragePR(float averagePR) {
//    AveragePR = averagePR;
//}
//public double getAverageQTcB() {
//    return  AverageQTcB;
//}
//
//public  void countAverageQTcB(){
//    AverageQTcB=AverageQT/Math.sqrt(RRAverage/1000);
//}
//public void setAverageQTcB(double averageQTcB) {
//    AverageQTcB = averageQTcB;
//}
//public ArrayList<Boolean> getPIsUp() {
//    return PIsUp;
//}
//public void setPIsUp(ArrayList<Boolean> pIsUp) {
//    PIsUp = pIsUp;
//}
//public ArrayList<Boolean> getTIsUp() {
//    return TIsUp;
//}
//public void setTIsUp(ArrayList<Boolean> tIsUp) {
//    TIsUp = tIsUp;
//}
//public ArrayList<Integer> getQstart() {
//    return Qstart;
//}
//public void setQstart(ArrayList<Integer> qstart) {
//    Qstart = qstart;
//}
//
//public int getR_Answer() {
//    return R_Answer;
//}
//public void setR_Answer(int r_Answer) {
//    R_Answer = r_Answer;
//}
//public int getT_Answer() {
//    return T_Answer;
//}
//public void setT_Answer(int t_Answer) {
//    T_Answer = t_Answer;
//}
//public int getP_Answer() {
//    return P_Answer;
//}
//public void setP_Answer(int p_Answer) {
//    P_Answer = p_Answer;
//}
//public int getSEQUENCE_Answer() {
//    return SEQUENCE_Answer;
//}
//public void setSEQUENCE_Answer(int sEQUENCE_Answer) {
//    SEQUENCE_Answer = sEQUENCE_Answer;
//}
//
//public ArrayList<ArrayList<Integer>> getNewRpointList() {
//    return NewRpointList;
//}
//public void setNewRpointList(ArrayList<ArrayList<Integer>> newRpointList) {
//    NewRpointList = newRpointList;
//}
//public ArrayList<Integer> getRRInternal() {
//    return RRInternal;
//}
//public void setRRInternal(ArrayList<Integer> rRInternal) {
//    RRInternal = rRInternal;
//}
//
//public ArrayList<Integer> getAtrialPrematureBeatIndex() {
//    return AtrialPrematureBeatIndex;
//}
//
//public void setAtrialPrematureBeatIndex(
//                                        ArrayList<Integer> atrialPrematureBeatIndex) {
//    AtrialPrematureBeatIndex = atrialPrematureBeatIndex;
//}
//
//public ArrayList<Integer> getPrematureVentricualrContractionIndex() {
//    return PrematureVentricualrContractionIndex;
//}
//
//public void setPrematureVentricualrContractionIndex(
//                                                    ArrayList<Integer> prematureVentricualrContractionIndex) {
//    PrematureVentricualrContractionIndex = prematureVentricualrContractionIndex;
//}
//
//public ArrayList<ArrayList<Float>> getNewQRSAverage() {
//    return NewQRSAverage;
//}
//public void setNewQRSAverage(ArrayList<ArrayList<Float>> newQRSAverage) {
//    NewQRSAverage = newQRSAverage;
//}
//
//public ArrayList<Integer> getAllAverageHeart_rate() {
//    return AllAverageHeart_rate;
//}
//public void setAllAverageHeart_rate(ArrayList<Integer> allAverageHeart_rate) {
//    AllAverageHeart_rate = allAverageHeart_rate;
//}
//
//public int getSinusArrest() {
//    return SinusArrest;
//}
//public void setSinusArrest(int sinusArrest) {
//    SinusArrest = sinusArrest;
//}
//
//public ArrayList<Integer> getItemAverageHeart_rate() {
//    return ItemAverageHeart_rate;
//}
//public void setItemAverageHeart_rate(ArrayList<Integer> itemAverageHeart_rate) {
//    ItemAverageHeart_rate = itemAverageHeart_rate;
//}
