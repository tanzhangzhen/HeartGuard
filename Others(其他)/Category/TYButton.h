

#import <UIKit/UIKit.h>

//自定义一个Button类,实现Home页面热点信息栏 左文字－右图片，比例为：3/4 : 1/4 文字分两行，大小、颜色均不同

@interface TYButton : UIButton

@property(nonatomic,copy)NSString *topText;//上行文字
@property(nonatomic,copy)NSString *bottomText;//下行文字
@property(nonatomic,copy)NSString *btnImage;//button图片

-(TYButton *)initWithTopText:(NSString *)topText BottomText:(NSString *)bottomText BtnImage:(NSString *)btnImage;//button上下行文字和图片

@end
