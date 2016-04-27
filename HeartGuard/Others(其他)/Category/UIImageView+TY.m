
//  自定义UIImageView+TY 封装扩展系统的UIImageView

#import "UIImageView+TY.h"

@implementation UIImageView (TY)

//1.图片:位置图片封装
-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = frame;
    return imageView;
}

@end
