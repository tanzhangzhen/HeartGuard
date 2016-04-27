
//自定义一个Button类,实现Home页面热点信息栏 左文字－右图片，比例为：3/4 : 1/4 文字分两行，大小、颜色均不同

#import "TYButton.h"

@implementation TYButton

//-(void)layoutSubviews{
//    [super layoutSubviews];
//}

//自定义Button类,实现文字分两行，大小、颜色均可设置
-(TYButton *)initWithTopText:(NSString *)topText BottomText:(NSString *)bottomText BtnImage:(NSString *)btnImage{
    if (self = [super init]) {
        
        self.titleLabel.numberOfLines=0;//设置Button文字换行
        self.titleLabel.font = [UIFont systemFontOfSize:12];//设置Button字体大小
        self.titleLabel.textAlignment = NSTextAlignmentLeft;//设置Button文字居左
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;//设置顶部Button按钮图片适配
        [self setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];//设置Button图片
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];//设置Button颜色
        NSString *totalStr = [NSString stringWithFormat:@"%@\n\n%@",topText,bottomText];//设置字符串拼接totalStr＝text＋text2
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc ]initWithString:totalStr];//初始化、分配内存
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(topText.length, bottomText.length)];//设置对应文字大小
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(topText.length,bottomText.length+2)];//设置对应文字颜色
        [self setAttributedTitle:str forState:UIControlStateNormal];//设置Button文字
        
    }
    return self;
}

// 重写titleRectForContentRect和imageRectForContentRect实现图片与文字高度3:1
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    //文字x＝0，y＝0 宽占整体3/4，高为文字高
    return CGRectMake(10,0, contentRect.size.width *3 / 4 - 10, contentRect.size.height);
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    //图片x＝3/4，y＝0 宽占整体1/4，高为图片高
    return CGRectMake(contentRect.size.width *3/ 4 -10, 0, contentRect.size.width*1/ 4, contentRect.size.height);
}

@end
