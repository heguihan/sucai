//
//  HGHLoginAlertview.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/10.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHLoginAlertview.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHAccessApi.h"
#import "HGHLogin.h"
@implementation HGHLoginAlertview
- (UIView *)alertView
{
    if (!_alertView) {
        CGFloat alertWidth = SCREENWIDTH -20;
        NSLog(@"alertWidth=%f screenw=%f",alertWidth,SCREENWIDTH);
        if (SCREEN_IS_LANDSCAPE||SCREEN_IS_LANDSCAPE) {
            alertWidth = [HGHUIFrame alertWidth:560];
        }
        CGFloat alertHeight = 110;
        _alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-alertWidth)/2, (SCREENHEIGHT-alertHeight)/2, alertWidth, alertHeight)];
//        _alertView
    }
    return _alertView;
}
+(instancetype)shareinstance
{
    static HGHLoginAlertview *login = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[HGHLoginAlertview alloc]init];
    });
    return login;
}



-(void)showLoginmeg:(NSString *)msg
{
//    CGFloat alertWidth = SCREENWIDTH * 480 / 810;
//    CGFloat alertHeight = 110;
//    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-alertWidth)/2, (SCREENHEIGHT-alertHeight)/2, alertWidth, alertHeight)];
    [self creatTimer];
    [[HGHTools getCurrentViewcontronller].view addSubview:self.alertView];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.alertView.bounds];
    NSLog(@"imageV_width=%f alertW=%f",imageV.frame.size.width,self.alertView.frame.size.width);
    imageV.image = [UIImage imageNamed:@"outSea.bundle/bgwhite.png"];
    imageV.userInteractionEnabled = YES;
    [self.alertView addSubview:imageV];
//    alertView.backgroundColor = [UIColor redColor];
    
    CGFloat labY = 35;
    CGFloat blabX = [HGHUIFrame alertWidth:30];
//    CGFloat blabW =[HGHUIFrame alertWidth:120];
    CGFloat blabW =120;
    if ([GuoJiHua(@"语言")isEqualToString:@"2"]) {
        blabW = 150;
    }
    
    
    UILabel *bLab = [[UILabel alloc]initWithFrame:CGRectMake(blabX, labY, blabW, 40)];
    //测试
//    bLab.backgroundColor = [UIColor redColor];
    bLab.text = GuoJiHua(@"欢迎回来");
    CGFloat aLabX = blabX + blabW +[HGHUIFrame alertWidth:5];
    UILabel *aLab = [[UILabel alloc]initWithFrame:CGRectMake(aLabX, labY, [HGHUIFrame alertWidth:180], 40)];
    bLab.font = [UIFont systemFontOfSize:20];
    aLab.font = [UIFont systemFontOfSize:20];
    aLab.textColor = [UIColor redColor];
    aLab.text = [NSString stringWithFormat:@"user%@ %@",msg,@""];
    
//    CGFloat bthW = [HGHUIFrame alertWidth:130];
    CGFloat bthW = 130;
//    CGFloat btnX = [HGHUIFrame alertWidth:480] - bthW - [HGHUIFrame alertWidth:20];
    CGFloat btnX = aLabX + aLab.bounds.size.width;
    UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, labY, bthW, 40)];
    changeBtn.backgroundColor = [UIColor blueColor];
    changeBtn.layer.cornerRadius = 20;
    changeBtn.layer.masksToBounds = YES;
    
    [changeBtn setTitle:GuoJiHua(@"切换账号") forState:UIControlStateNormal];
    
//    bLab.backgroundColor = [UIColor greenColor];
//    aLab.backgroundColor = [UIColor greenColor];
//    changeBtn.backgroundColor = [UIColor greenColor];
    
    
    if ([GuoJiHua(@"语言")isEqualToString:@"2"]) {
        changeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
//    changeBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    [imageV addSubview:bLab];
    [imageV addSubview:aLab];
    [imageV addSubview:changeBtn];
    [changeBtn addTarget:self action:@selector(changeAccount:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)creatTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showAlert) userInfo:nil repeats:NO];
}

-(void)showAlert
{
    NSLog(@"alert xxx");
    
    [self.alertView removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)changeAccount:(UIButton *)sender
{
    NSLog(@"changeAccount");
    [self.alertView removeFromSuperview];
    
    [HGHAccessApi logout:^(NSString * _Nonnull result) {
        if ([result isEqualToString:@"success"]) {
            [[HGHLogin shareinstance]Login];
        }
    }];
}



@end
