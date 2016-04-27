
//自定义一个Button类,实现更多页面 房产工具栏 上图片－下文字，比例为：3/5 : 2/5

#import "XMButton.h"

@implementation XMButton

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
}

// 重写titleRectForContentRect和imageRectForContentRect实现图片与文字高度3:1
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    //文字x＝0，y＝3/4 宽为文字宽，高占整体1/4
    return CGRectMake(0, contentRect.size.height *3 / 5, contentRect.size.width, contentRect.size.height *2 / 5);
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    //图片x＝0，y＝0 宽为图片宽，高占整体3/4
    return CGRectMake(0, 5, contentRect.size.width, contentRect.size.height *3 / 5);
}

@end

