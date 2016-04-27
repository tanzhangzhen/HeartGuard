//
//  ECGViewController.h
//  智能云心电仪
//
//  Created by MM on 16/3/12.
//  Copyright © 2016年 mm. All rights reserved.
//

#import "HeartLive.h"

static const NSInteger kMaxContainerCapacity = 300;//最大点数

@interface PointContainer ()

@property (nonatomic , assign) CGPoint *translationPointContainer;//点容器
@property (nonatomic , assign) NSInteger numberOfTranslationElements;//平移点元素数

@end

@implementation PointContainer

- (void)dealloc
{
    NSLog(@"HeartLive释放内存");
    free(self.translationPointContainer);
    self.translationPointContainer = NULL;
}
//单例模式
//1. 封装一个共享的资源
//2. 提供一个固定的实例创建方法
//3. 提供一个标准的实例访问接口
+ (PointContainer *)sharedContainer
{
    
    //static变量container_ptr用于存储一个单例的指针，并且强制所有对该变量的访问都必须通过类方法   +(id)sharedContainer，在对   +(id)sharedContainer第一次调用时候完成实例的创建。
    static PointContainer *container_ptr = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container_ptr = [[self alloc] init];
        container_ptr.translationPointContainer = malloc(sizeof(CGPoint) * kMaxContainerCapacity);
        memset(container_ptr.translationPointContainer, 0, sizeof(CGPoint) * kMaxContainerCapacity);
    });
    return container_ptr;
}

//增加点到点容器中 
- (void)addPointAsTranslationChangeform:(CGPoint)point
{
    //NSLog(@"传进来的 point x=%f y=%f",point.x,point.y);
    static NSInteger currentPointsCount = 0;//设置static变量当前点的数量为0
    if (currentPointsCount < kMaxContainerCapacity) {
        self.numberOfTranslationElements = currentPointsCount + 1;
        self.translationPointContainer[currentPointsCount] = point;
        currentPointsCount ++;
        //NSLog(@"currentPointsCount现在是：%ld",(long)currentPointsCount);
    } else {
        NSInteger workIndex = kMaxContainerCapacity - 1;
        while (workIndex != 0) {
            self.translationPointContainer[workIndex].y = self.translationPointContainer[workIndex - 1].y;
            workIndex --;
            //NSLog(@"workIndex现在是：%ld",(long)workIndex);
        }
        self.translationPointContainer[0].x = 0;
        self.translationPointContainer[0].y = point.y;
        self.numberOfTranslationElements = kMaxContainerCapacity;
    }    
}

@end

@interface HeartLive ()

@property (nonatomic , assign) CGPoint *points;//点的集合
@property (nonatomic , assign) NSInteger currentPointsCount;//当前点集合中点的数量

@end

@implementation HeartLive
//初始化视图尺寸
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}
//设置画心电图的点的数量 接收 ecg界面传过来的点集合和点数 在PointContainer设置
- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count
{
    self.points = points;//容器的点
    self.currentPointsCount = count;//当前的点元素数量
}
//点集合中的点 fireDrawingWithPoints传过来的 ecg界面传过来的 在PointContainer设置
- (void)setPoints:(CGPoint *)points
{
    _points = points;
    [self setNeedsDisplay];
}
//画心电图
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawGrid];//画心电格子
    [self drawCurve];//画心电图曲线
}

//画心电格子
- (void)drawGrid
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat full_height = self.frame.size.height;
    CGFloat full_width = self.frame.size.width;
    CGFloat cell_square_width = 30;
    
    CGContextSetLineWidth(context, 0.2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    int pos_x = 1;
    while (pos_x < full_width) {
        CGContextMoveToPoint(context, pos_x, 1);
        CGContextAddLineToPoint(context, pos_x, full_height);
        pos_x += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    CGFloat pos_y = 1;
    while (pos_y <= full_height) {
        
        CGContextSetLineWidth(context, 0.2);
        
        CGContextMoveToPoint(context, 1, pos_y);
        CGContextAddLineToPoint(context, full_width, pos_y);
        pos_y += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    
    CGContextSetLineWidth(context, 0.1);
    
    cell_square_width = cell_square_width / 5;
    pos_x = 1 + cell_square_width;
    while (pos_x < full_width) {
        CGContextMoveToPoint(context, pos_x, 1);
        CGContextAddLineToPoint(context, pos_x, full_height);
        pos_x += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
    pos_y = 1 + cell_square_width;
    while (pos_y <= full_height) {
        CGContextMoveToPoint(context, 1, pos_y);
        CGContextAddLineToPoint(context, full_width, pos_y);
        pos_y += cell_square_width;
        
        CGContextStrokePath(context);
    }
    
}
//画心电图曲线
- (void)drawCurve
{
    if (self.currentPointsCount == 0) {
        return;
    }
    CGFloat curveLineWidth = 0.8;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取上下文
    CGContextSetLineWidth(currentContext, curveLineWidth);//设置线宽
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor greenColor].CGColor);//设置线颜色
    //画图前，首先确定一个start point
    CGContextMoveToPoint(currentContext, self.points[0].x, self.points[0].y);
    //NSLog(@"画心电图函数，当前CGContextMoveToPoint的 x=%f, y=%f",self.points[0].x,self.points[0].y);
    for (int i = 1; i != self.currentPointsCount; ++ i) {
        //NSLog(@"画心电图曲线 for 循环，i != 当前点集合中点的数量则++i, 当前点集合中点的数量为%ld", (long)self.currentPointsCount);
        if (self.points[i - 1].x < self.points[i].x) {
            //如果前一个点x 比当前点 x 小，则到当前点画线
            CGContextAddLineToPoint(currentContext, self.points[i].x, self.points[i].y);
        } else {
            //否则，以当前点为开始点
            CGContextMoveToPoint(currentContext, self.points[i].x, self.points[i].y);
        }
    }
    //画路径轮廓的函数 当前的笔划颜色画出以路径为中心位置的线
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


@end