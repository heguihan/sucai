//
//  AWLogoutView.m
//  AWSDKDemo
//
//  Created by admin on 2021/3/30.
//

#import "AWLogoutView.h"

@implementation AWLogoutView

+(instancetype)factory_awlogoutview
{
    AWLogoutView *logoutview = [[AWLogoutView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [logoutview configUI];
    return logoutview;
}

-(void)configUI
{
    [self addLogo];
    [self addContent];
}

-(void)addLogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(100), ViewWidth-MarginX*2, 20)];
    
    [self addSubview:lab];
    
    lab.text = @"确定要退出游戏吗？";
    
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    cancelBtn.titleLabel.font = FONTSIZE(14);
    cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = TFHeight/2.0;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    confirmBtn.titleLabel.font = FONTSIZE(14);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickgotoSetting) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:cancelBtn];
    [self addSubview:confirmBtn];
    
}

-(void)clickCancel
{
    NSLog(@"logout cancel");
}

-(void)clickgotoSetting
{
    NSLog(@"logout confirm");
}

@end
