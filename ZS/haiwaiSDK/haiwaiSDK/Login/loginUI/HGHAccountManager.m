//
//  HGHAccountManager.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHAccountManager.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHForgotPassword.h"
#import "HGHChangePassword.h"
#import "HGHBindAccount.h"
#import "HGHLogin.h"
#import "HGHConfig.h"
@implementation HGHAccountManager
+(instancetype)shareInstance
{
    static HGHAccountManager *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[HGHAccountManager alloc]init];
    });
    return account;
}

-(void)accountManager
{
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat LabW = [HGHUIFrame adapterWidth:300];
    CGFloat LabY = [HGHUIFrame adapterWidth:30];
    CGFloat LabX = (VIEWWIDTH-LabW)/2;
    CGFloat BtnW = [HGHUIFrame adapterWidth:367];
    CGFloat BtnX = (VIEWWIDTH - BtnW)/2;
    CGFloat BtnY = LabY + 30+[HGHUIFrame adapterWidth:25];
    CGFloat btnheightAndxx = 60+[HGHUIFrame adapterWidth:10];
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(LabX, LabY, LabW, 30)];
    headerLab.backgroundColor = [UIColor clearColor];
    [self.imageView addSubview:headerLab];
    headerLab.text=GuoJiHua(@"账号管理");
    headerLab.font = [UIFont systemFontOfSize:27];
    headerLab.textAlignment = NSTextAlignmentCenter;
    NSArray *arr = @[GuoJiHua(@"忘记密码"),GuoJiHua(@"修改密码"),GuoJiHua(@"绑定账号")];
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(BtnX, BtnY+btnheightAndxx*i, BtnW, 60)];
        [btn.layer setCornerRadius:30];
        btn.layer.masksToBounds = YES;
        [btn.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
        [btn.layer setBorderWidth:1.6];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        if ([HGHConfig getFacebookClose]&&[HGHConfig getGoogleClose]&&i==2) {
            //
        }else{
            [self.imageView addSubview:btn];
        }
        
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, LabY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            NSLog(@"Email信箱绑定");
            break;
        case 101:
            NSLog(@"找回密码");
            [self searchPwd];
            break;
        case 102:
            NSLog(@"修改密码");
            [self changePwd];
            break;
        case 103:
            NSLog(@"账号绑定");
            [self accountBind];
            break;
            
        default:
            break;
    }
}

-(void)searchPwd
{
    [[HGHForgotPassword shareInstance] gotoForgotPassword];
}

-(void)changePwd
{
    [[HGHChangePassword shareinstance] gotoChangePassword];
}

-(void)accountBind
{
    [[HGHBindAccount shareinstance] gotoBindAccount];
}

-(void)goback:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
}

@end
