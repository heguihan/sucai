//
//  AWHealthNotice.m
//  AWSDKDemo
//
//  Created by admin on 2021/9/23.
//

#import "AWHealthNotice.h"

@implementation AWHealthNotice

+(instancetype)factory_healthNoticeWithMsg:(NSString *)msg
{
    AWHealthNotice *healthNotice = [[AWHealthNotice alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [healthNotice configUIWithMsg:msg];
    return healthNotice;
}

-(void)configUIWithMsg:(NSString *)msg
{
    
    [AWGlobalDataManage shareinstance].isShowingAddiction = YES;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
    titleLab.backgroundColor = RGBA(242, 242, 242, 1);
    titleLab.text = @"健康系统提示";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, ViewWidth-20, 60)];
    contentLab.numberOfLines = 0;
    contentLab.text = msg;
    
    
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    AWHGHALLButton *logoutBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    logoutBtn.titleLabel.font = FONTSIZE(14);
    logoutBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [logoutBtn setTitle:@"退出游戏" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    logoutBtn.layer.cornerRadius = TFHeight/2.0;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
    
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    confirmBtn.titleLabel.font = FONTSIZE(14);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];

    
    [self addSubview:titleLab];
    [self addSubview:contentLab];
    [self addSubview:logoutBtn];
    [self addSubview:confirmBtn];
    
    
    
    
    
}


-(void)clickLogout
{
    //退回到登录界面
    [self closeAllView];
    [AWGlobalDataManage shareinstance].isShowingFourceRealName = NO;
    [AWConfig LogoutWithGame];
}

-(void)clickConfirm
{
    //退出游戏
    [AWTools leaveGame];
}


@end
