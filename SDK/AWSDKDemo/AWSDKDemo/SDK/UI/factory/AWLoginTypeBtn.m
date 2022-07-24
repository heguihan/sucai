//
//  AWLoginTypeBtn.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/18.
//

#import "AWLoginTypeBtn.h"

@implementation AWLoginTypeBtn

+(instancetype)factory_BtnWithTitle:(NSString *)title imageName:(NSString *)imageName marginY:(CGFloat)marginY
{
    AWLoginTypeBtn *loginBtn = [[AWLoginTypeBtn alloc]initWithFrame:CGRectMake(MarginX, marginY, ViewWidth-MarginX*2, TFHeight)];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 8, 30, TFHeight-14)];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    iconImage.image = [UIImage imageNamed:imageName];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, ViewWidth-MarginX*2-140, TFHeight)];
    titleLab.textColor = RGBA(49, 49, 49, 1);
    titleLab.font = FONTSIZE(14);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    
    [loginBtn addSubview:iconImage];
    [loginBtn addSubview:titleLab];
    return loginBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    CGFloat height = frame.size.height;
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = height/2.0;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = RGBA(220, 220, 220, 1).CGColor;//设置边框颜色
        self.layer.borderWidth = 0.67;//设置边框颜色
    }
    return self;
}

@end
