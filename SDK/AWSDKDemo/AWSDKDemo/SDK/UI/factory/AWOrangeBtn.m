//
//  AWOrangeBtn.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWOrangeBtn.h"

@implementation AWOrangeBtn

+(instancetype)factoryBtnWithTitle:(NSString *)title marginY:(CGFloat)marginY;
{
    AWOrangeBtn *btn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake(MarginX, marginY, ViewWidth-MarginX*2, TFHeight)];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat height = frame.size.height;
        CAGradientLayer *layer = [AWTools setGradualChangingColor:self fromColor:RGBA(239, 165, 105, 1) toColor:RGBA(236, 128, 51, 1)];
        layer.cornerRadius = height/2.0;
        layer.masksToBounds = YES;
        [self.layer addSublayer:layer];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

@end
