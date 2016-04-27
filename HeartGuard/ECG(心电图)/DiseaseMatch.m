//
//  DiseaseMatch.m
//  HeartGuard
//
//  Created by MM on 16/3/20.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "DiseaseMatch.h"

/**
 * QRS大于0.12m 为室性，即42个数据点，取39偏差3个数据
 */
int FLAG = 40;//private final int FLAG = 40;
/**
 * 当RR间期大于120时认为出现早搏
 */
int Internal = 100;//private final int Internal = 100;
/**
 * 心率小于20
 */
int SinusArrest = 20;//private int SinusArrest = 20;

@interface DiseaseMatch ()


@end

@implementation DiseaseMatch

-(instancetype)init:(ResultData *)resultData{
    if (self = [super init]) {
        self.resultData = resultData;
    }
    return self;
}

/**
 * 根据方差判断是否存在早搏，并且将早搏个数加一
 * @return
 */
-(Boolean)ifPrematureBeat{
    //public  boolean ifPrematureBeat(){
    Boolean isPrematureBeat = false;
//    for(int i = 0; i <resultData.getVariance().count; i++){
//        if(resultData.getVariance.get(i)>1018){
//            self.resultData.setPrematureBeat(resultData.getPrematureBeat() + 1);
//        }
//    }
//    if(resultData.getPrematureBeat()>0)
//        isPrematureBeat = true;
    
    return isPrematureBeat;
}

/**
 * 根据方差判断是否存在早搏，并且在此基础上根据每个R波的QRS时限鉴别室上性，室性期前收缩
 * @return
 */
-(Boolean)ifPremature{
//public boolean ifPremature(){
    Boolean isPrematureBeat = false;
//    resultData.getAtrialPrematureBeatIndex().clear();
//    resultData.getPrematureVentricualrContractionIndex().clear();
    //		for(int i = 0; i <resultData.getSpoint().size(); i++){
    //			Log.d("QRSAverage", "每个QRS的差值"+(resultData.getSpoint().get(i)-resultData.getQpoint().get(i)));
    //		}
    //		for(int i = 0; i <resultData.getRRInternal().size(); i++){
    //			Log.d("QRSAverage", "每个RR-RR"+resultData.getRRInternal().get(i));
    //		}
    //		for(int i = 0; i <resultData.getNewQRSAverage().size(); i++){
    //			for(int j=0; j<resultData.getNewRpointList().get(i).size();j++){
    //				if(j+2<resultData.getNewRpointList().get(i).size()){
    //					Log.e("QRSAverage", "每个RR-RR---------------------"+(
    //						(resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
    //						(resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))));
    //				}
    //
    //			}
    //		}
//    for(int z = 0; z<resultData.getRRInternal().size(); z++){
//        Log.d("QRSAverage", "(resultData.getRRInternal().get(z)----------------------"+resultData.getRRInternal().get(z));
//    }
//    for(int i = 0; i <resultData.getVariance().size(); i++){
//        
//        if(resultData.getVariance().get(i)>1018){
//            Log.d("QRSAverage", "QRS的平均值----------------------"+resultData.getQRSAverage().get(i));
//            Log.d("QRSAverage", "你的方差是多少啊====="+resultData.getVariance().get(i));
//            //				for(int z = 0; z<resultData.getNewQRSAverage().get(i).size(); z++){
//            //					Log.d("QRSAverage", "(resultData.getNewQRSAverage().get(i).get(z)----------------------"+resultData.getNewQRSAverage().get(i).get(z));
//            //				}
//            float RRAverage = (resultData.getNewRpointList().get(i).get(resultData.getNewRpointList().get(i).size()-1)-
//                               resultData.getNewRpointList().get(i).get(0))/(resultData.getNewRpointList().get(i).size()-1);
//            Log.d("QRSAverage", "对应的RRAverage"+RRAverage);
//            int j = 0;
//            for(j = 0; j<resultData.getNewQRSAverage().get(i).size(); j++ ){
//                Log.d("QRSAverage", "对应的R"+(resultData.getNewRpointList().get(i).get(j)));
//                Log.d("QRSAverage", "对应的R大小是？"+(resultData.getNewRpointList().get(i).size()));
//                //					Log.d("QRSAverage", "每个RR-RR---------------------"+(
//                //							(resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                //							(resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))));
//                //一个方差对应一个NewRpointList，NewRpointList代表的是4.5s数据内的R波下标值
//                if(j+2<resultData.getNewRpointList().get(i).size()){
//                    Log.e("QRSAverage", "每个RR-RR---------------------"+(
//                                                                        (resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                                                        (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))));
//                    
//                    //逻辑判断，若RR(i)-RR(i+1)的绝对值大于100满足早搏条件，这认为这3个R波内最少出现一个早搏
//                    if(Math.abs((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                )
//                       >Internal){
//                        
//                        //为了区分是房性、室性做的一个判断
//                        if(resultData.getNewQRSAverage().get(i).get(j)>FLAG
//                           ||resultData.getNewQRSAverage().get(i).get(j+1)>FLAG
//                           ||resultData.getNewQRSAverage().get(i).get(j+2)>FLAG){
//                            //								for(int o=j;o<j+3;o++){
//                            //									if(resultData.getNewQRSAverage().get(i).get(o)>FLAG
//                            //											&&Math.abs((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                            //													(resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                            //													)>Internal){
//                            //										if(resultData.getPrematureVentricualrContractionIndex().size()==0||resultData.getPrematureVentricualrContractionIndex().get(resultData.getPrematureVentricualrContractionIndex().size()-1)
//                            //												!=resultData.getNewRpointList().get(i).get(o)){
//                            //											resultData.getPrematureVentricualrContractionIndex().add(resultData.getNewRpointList().get(i).get(o));
//                            //											Log.d("QRSAverage", "vvv----------------------"+resultData.getNewQRSAverage().get(i).get(o));
//                            //										}
//                            //
//                            //									}
//                            //								}
//                            //早搏个数加一
//                            resultData.setPrematureBeat(resultData.getPrematureBeat() + 1);
//                            
//                            //为了区分是哪个R波是早搏只能逐个判断其QRS实现
//                            if(resultData.getNewQRSAverage().get(i).get(j)>FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )<-80){
//                                   if(resultData.getPrematureVentricualrContractionIndex().size()==0||resultData.getPrematureVentricualrContractionIndex().get(resultData.getPrematureVentricualrContractionIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j)){
//                                       resultData.getPrematureVentricualrContractionIndex().add(resultData.getNewRpointList().get(i).get(j));
//                                       Log.d("QRSAverage", "vvv----------------------"+resultData.getNewQRSAverage().get(i).get(j));
//                                   }
//                                   
//                               }
//                            if(resultData.getNewQRSAverage().get(i).get(j+1)>FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )>Internal){
//                                   if(resultData.getPrematureVentricualrContractionIndex().size()==0||resultData.getPrematureVentricualrContractionIndex().get(resultData.getPrematureVentricualrContractionIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j+1)){
//                                       resultData.getPrematureVentricualrContractionIndex().add(resultData.getNewRpointList().get(i).get(j+1));
//                                       Log.d("QRSAverage", "vvv----------------------"+resultData.getNewQRSAverage().get(i).get(j+1));
//                                   }
//                                   
//                               }
//                            if(resultData.getNewQRSAverage().get(i).get(j+2)>FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )<-80){
//                                   if(resultData.getPrematureVentricualrContractionIndex().size()==0||resultData.getPrematureVentricualrContractionIndex().get(resultData.getPrematureVentricualrContractionIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j+2)){
//                                       resultData.getPrematureVentricualrContractionIndex().add(resultData.getNewRpointList().get(i).get(j+2));
//                                       Log.d("QRSAverage", "vvv----------------------"+resultData.getNewQRSAverage().get(i).get(j+2));
//                                   }
//                                   
//                               }
//                        }else{
//                            Log.d("QRSAverage", "aaa----------------------"+resultData.getNewQRSAverage().get(i).get(j));
//                            if(resultData.getNewQRSAverage().get(i).get(j)<FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )<-80){
//                                   if(resultData.getAtrialPrematureBeatIndex().size()==0||resultData.getAtrialPrematureBeatIndex().get(resultData.getAtrialPrematureBeatIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j)){
//                                       resultData.getAtrialPrematureBeatIndex().add(resultData.getNewRpointList().get(i).get(j));
//                                       Log.d("QRSAverage", "aaa----------------------"+resultData.getNewQRSAverage().get(i).get(j));
//                                   }
//                                   
//                               }
//                            if(resultData.getNewQRSAverage().get(i).get(j+1)<FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )>Internal){
//                                   if(resultData.getAtrialPrematureBeatIndex().size()==0||resultData.getAtrialPrematureBeatIndex().get(resultData.getAtrialPrematureBeatIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j+1)){
//                                       resultData.getAtrialPrematureBeatIndex().add(resultData.getNewRpointList().get(i).get(j+1));
//                                       Log.d("QRSAverage", "aaa----------------------"+resultData.getNewQRSAverage().get(i).get(j+1));
//                                   }
//                                   
//                               }
//                            if(resultData.getNewQRSAverage().get(i).get(j+2)<FLAG
//                               &&((resultData.getNewRpointList().get(i).get(j+2)-resultData.getNewRpointList().get(i).get(j+1))-
//                                  (resultData.getNewRpointList().get(i).get(j+1)-resultData.getNewRpointList().get(i).get(j))
//                                  )<-80){
//                                   if(resultData.getAtrialPrematureBeatIndex().size()==0||resultData.getAtrialPrematureBeatIndex().get(resultData.getAtrialPrematureBeatIndex().size()-1)
//                                      !=resultData.getNewRpointList().get(i).get(j+2)){
//                                       resultData.getAtrialPrematureBeatIndex().add(resultData.getNewRpointList().get(i).get(j+2));
//                                       Log.d("QRSAverage", "aaa----------------------"+resultData.getNewQRSAverage().get(i).get(j+2));
//                                   }
//                                   
//                               }
//                            //								for(int o=j;o<j+3;o++)
//                            //									if(resultData.getNewQRSAverage().get(i).get(o)<FLAG){
//                            //										if(resultData.getAtrialPrematureBeatIndex().size()==0||resultData.getAtrialPrematureBeatIndex().get(resultData.getAtrialPrematureBeatIndex().size()-1)
//                            //												!=resultData.getNewRpointList().get(i).get(o)){
//                            //											resultData.getAtrialPrematureBeatIndex().add(resultData.getNewRpointList().get(i).get(o));
//                            //											Log.d("QRSAverage", "aaa----------------------"+resultData.getNewQRSAverage().get(i).get(o));
//                            //										}
//                            //
//                            //									}
//                        }
//                    }
//                    
//                }
//                
//            }
//        }
//    }
//    
//    resultData.setAtrialPrematureBeat(resultData.getAtrialPrematureBeatIndex().size());
//    resultData.setPrematureVentricualrContraction(resultData.getPrematureVentricualrContractionIndex().size());
//    
//    if(resultData.getPrematureBeat()>0)
//        isPrematureBeat = true;
    return isPrematureBeat;
}

/**
 * 判断一共有多少个两房负荷
 * 
 * 判断P波是否存在异常（增宽，双峰，增高）
 * 应该建立在这样的前提下：
 * 
 * 增宽：原本P波大于0.11s
 * 
 * 增高：原本P波波峰高于0线值，P波峰高于0线2.5mm，即0.25mv
 * 
 * @return
 */
-(int)isBaoLoad{
//public int isBaoLoad(ArrayList<Float> dataY){
    int bao = 0;
//    for(int i=0; i<resultData.getPpoint().size(); i++){
//        if(resultData.getDoubleP().get(i)>0){
//            if(Math.abs(resultData.getBaseline().get(i)-dataY.get(resultData.getPpoint().get(i)))>0.25){
//                bao++;
//            }
//        }
//    }
    return bao;
    
}

/**
 * 计算最大心率，最小心率 ，同时找停搏个数
 * @return
 * 		minmax
 */
//public int[] findMinMax(){
//    int min=220;
//    int max=0;
//    int[] minmax = new int[2];
//    for(int i=0; i<resultData.getAllAverageHeart_rate().size();i++){
//        Log.d("123", "getAllAverageHeart_rate.get(i)是"+resultData.getAllAverageHeart_rate().get(i));
//        if(max<resultData.getAllAverageHeart_rate().get(i)){			//求最大值和最小值
//            max=resultData.getAllAverageHeart_rate().get(i);
//        }
//        if(min>resultData.getAllAverageHeart_rate().get(i)){
//            min=resultData.getAllAverageHeart_rate().get(i);
//        }
//        if(SinusArrest>resultData.getAllAverageHeart_rate().get(i)){
//            resultData.setSinusArrest(resultData.getSinusArrest()+1);
//        }
//    }
//    minmax[0] = min;
//    minmax[1] = max;
//    return minmax;
//    
//}

/**
 * 判断是否房性早搏 单位为毫秒，面积单位随意
 * @param HRV1	心室率之差1（心室率即RR间期）
 * @param HRV2	心室率之差2（心室率即RR间期）
 * @param HRV3	心室率之差3（心室率即RR间期）
 * @param RR_duration	RR间期
 * @param avg_RR_duration	平均RR间期
 * @param s		QRS波曲线面积
 * @param avg_s	平均QRS波曲线面积
 * @return
 */
//public boolean ifAtrialPrematureBeat(float HRV1,float HRV2,float HRV3,
//                                     float RR_duration,float avg_RR_duration,float s,float avg_s){
//    if(HRV1<120&&HRV2<120&&HRV3<120&&RR_duration<0.88*avg_RR_duration&&s<1.5*avg_s)
//        return true;
//    else
//        return false;
//}
/**
 * 判断是否停搏	
 * 已完成
 * @param RR_duration  RR间期，时间为毫秒
 * @return
 */
-(Boolean)ifStopBeat:(float)RR_duration{
//private boolean ifStopBeat(float RR_duration){
    if(RR_duration>3000)
        return true;
    else
        return false;
}
/**
 * 判断是否漏搏	
 * 已完成
 * @param RR_duration  RR间期，时间为毫秒
 * 		  avg_RR_duration 平均RR间期，时间单位为毫秒
 * @return
 */
-(Boolean) ifMissBeat:(float)RR_duration Avg_RR_duration:(float)avg_RR_duration{
//public boolean ifMissBeat(float RR_duration,float avg_RR_duration){
    if(RR_duration>2.3*avg_RR_duration&&RR_duration<2.6*RR_duration)
        return true;
    else
        return false;
}
/**
 * 判断是否RonT 在心室复极化期间，出现室性早搏，而且检测到R波落在T波上
 * @return
 */
-(Boolean)ifRonT{
//public boolean ifRonT(){
    return false;
}
/**
 * 判断是否室性早搏
 * @param HRV1	心室率之差1（心室率即RR间期）
 * @param HRV2	心室率之差2（心室率即RR间期）
 * @param HRV3	心室率之差3（心室率即RR间期）
 * @param QRS_duration	QRS时长 单位毫秒
 * @return
 */
-(Boolean)ifPrematureVentricualrContraction:(float)HRV1 HRV2:(float)HRV2 HRV3:(float)HRV3 QRS_duration:(float)QRS_duration{
//public boolean ifPrematureVentricualrContraction(float HRV1,float HRV2,float HRV3,float QRS_duration){
    if(HRV1>120&&HRV2>120&&HRV3>120&&QRS_duration>=120)
        return true;
    else
        return false;
}
/**
 * 判断是否心动过速
 * @param RR_duration 单位毫秒
 * @return
 */
-(Boolean)ifTachyrhythm:(float)RR_duration{
//public boolean ifTachyrhythm(float RR_duration){
    if(RR_duration<500)
        return true;
    else
        return false;
}
/**
 * 判断是否心动过缓
 * @return
 */
-(Boolean)ifBradycardia:(float)RR_duration{
//public boolean ifBradycardia(float RR_duration){
    if(RR_duration>1500)
        return true;
    else
        return false;
}

@end
