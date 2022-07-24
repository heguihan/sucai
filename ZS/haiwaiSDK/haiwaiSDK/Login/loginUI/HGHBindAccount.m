//
//  HGHBindAccount.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHBindAccount.h" 
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHLogin.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHGoogleLoginViewController.h"
#import <UIKit/UIKit.h>
#import "HGHFacebookLogin.h"
#import "HGHAlertview.h"

@implementation HGHBindAccount

+(instancetype)shareinstance
{
    static HGHBindAccount *bind = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bind = [[HGHBindAccount alloc]init];
    });
    return bind;
}

-(void)gotoBindAccount
{
    self.isFirst = YES;
    self.isFirstClick = YES;
    self.plamt = @"fb";
    self.platType = @"3";
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat labX = (VIEWWIDTH-[HGHUIFrame adapterWidth:360])/2;
    CGFloat labY = [HGHUIFrame adapterWidth:15];
    CGFloat labWidth = [HGHUIFrame adapterWidth:360];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labWidth, 25)];
    titleLab.text = GuoJiHua(@"绑定账号");
    titleLab.font = [UIFont systemFontOfSize:25];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:titleLab];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, labY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat  textFTY = labY + 35+[HGHUIFrame adapterWidth:10];
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat heightAndxxx = 40+[HGHUIFrame adapterHeight:8];
    
    CGFloat btnW = [HGHUIFrame adapterWidth:342]/3;
    CGFloat btnwAndxx = btnW + [HGHUIFrame adapterWidth:10];
    NSArray *arr = @[@"FB",GuoJiHua(@"GUEST"),GuoJiHua(@"GOOGLE")];
//    NSArray *btnArr = @[self.btnFB,self.btnGUEST,self.btnGOOGLE];
//    for (int i =0; i<3; i++) {
//        btnArr[i] = [[UIButton alloc]initWithFrame:CGRectMake(textFieldX+btnwAndxx*i, textFTY, btnW, 40)];
//        btnArr[i].selected = YES;
//        [btnArr[i] setTitle:arr[i] forState:UIControlStateNormal];
//        [btnArr[i] setImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
//        [btnArr[i] setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateSelected];
//        [btnArr[i].layer setCornerRadius:20];
//        btnArr[i].layer.masksToBounds = YES;
//        [self.imageView addSubview:btn];
//    }
//
    
    self.btnFB = [[UIButton alloc]initWithFrame:CGRectMake(textFieldX, textFTY, btnW, 40)];
    self.btnFB.selected = NO;
//    [self.btnFB setImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
//    [self.btnFB setImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateSelected];
    [self.btnFB.layer setCornerRadius:20];
    self.btnFB.layer.masksToBounds=YES;
    [self.btnFB.layer setBorderColor:[UIColor blueColor].CGColor];
    self.btnFB.layer.borderWidth = 1.6;
    [self.btnFB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnFB.backgroundColor = [UIColor blueColor];
    [self.btnFB setTitle:@"FB" forState:UIControlStateNormal];
    [self.imageView addSubview:self.btnFB];
    [self.btnFB addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnGUEST = [[UIButton alloc]initWithFrame:CGRectMake(textFieldX+btnwAndxx, textFTY, btnW, 40)];
    self.btnGUEST.selected=NO;
    [self.btnGUEST.layer setCornerRadius:20];
    self.btnGUEST.layer.masksToBounds=YES;
    [self.btnGUEST.layer setBorderColor:[UIColor blueColor].CGColor];
    self.btnGUEST.layer.borderWidth = 1.6;
    [self.btnGUEST setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    self.btnGUEST.backgroundColor = [UIColor whiteColor];
    [self.btnGUEST setTitle:GuoJiHua(@"GUEST") forState:UIControlStateNormal];
    [self.btnGUEST addTarget:self action:@selector(clickGUEST:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.btnGUEST];
    
    self.btnGOOGLE = [[UIButton alloc]initWithFrame:CGRectMake(textFieldX+btnwAndxx*2, textFTY, btnW, 40)];
    self.btnGOOGLE.selected=NO;
    [self.btnGOOGLE.layer setCornerRadius:20];
    [self.btnGOOGLE.layer setBorderColor:[UIColor blueColor].CGColor];
    self.btnGOOGLE.layer.borderWidth=1.6;
    [self.btnGOOGLE setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnGOOGLE.layer.masksToBounds=YES;
    self.btnGOOGLE.backgroundColor = [UIColor whiteColor];
    [self.btnGOOGLE setTitle:GuoJiHua(@"GOOGLE") forState:UIControlStateNormal];
    [self.btnGOOGLE addTarget:self action:@selector(clickGOOGLE:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:self.btnGOOGLE];
    
    
    CGFloat userTFY = textFTY + 40+[HGHUIFrame adapterWidth:15];
    UITextField *userTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, userTFY, textFieldWidth, 40)];
    CGFloat pwdTFY = userTFY+40+[HGHUIFrame adapterWidth:10];
    UITextField *pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, pwdTFY, textFieldWidth, 40)];
    userTF.placeholder = GuoJiHua(@"请输入邮箱地址");
    userTF.backgroundColor = [UIColor whiteColor];
    pwdTF.backgroundColor = [UIColor whiteColor];
//    pwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
    [userTF.layer setCornerRadius:20];
    userTF.layer.masksToBounds = YES;
    [pwdTF.layer setCornerRadius:20];
    pwdTF.layer.masksToBounds=YES;
    [self.imageView addSubview:userTF];
    [self.imageView addSubview:pwdTF];
    self.usernameTF = userTF;
    self.pwdTF = pwdTF;
    UIView *leftAccountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    userTF.leftViewMode = UITextFieldViewModeAlways;
    userTF.leftView = leftAccountView;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageV.image = [UIImage imageNamed:@"outSea.bundle/user.png"];
    [leftAccountView addSubview:imageV];
    
    UIView *leftPwdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.leftView = leftPwdView;
    UIImageView *imagePwdV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imagePwdV.image = [UIImage imageNamed:@"outSea.bundle/password.png"];
    [leftPwdView addSubview:imagePwdV];
    
    
    CGFloat sureBtnW=[HGHUIFrame adapterWidth:200];
    CGFloat sureBtnY = pwdTFY+40+[HGHUIFrame adapterWidth:25];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-sureBtnW)/2, sureBtnY, sureBtnW, 40)];
    [sureBtn.layer setCornerRadius:20];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = [UIColor blueColor];
    [sureBtn setTitle:GuoJiHua(@"确认") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:sureBtn];
    
    
}

-(void)goback:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
}

-(void)clickGOOGLE:(UIButton *)sender
{
    self.plamt = @"gp";
    self.platType = @"3";
    self.btnFB.backgroundColor = [UIColor whiteColor];
    [self.btnFB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnGOOGLE.backgroundColor = [UIColor blueColor];
    [self.btnGOOGLE setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnGUEST.backgroundColor = [UIColor whiteColor];
    [self.btnGUEST setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

-(void)clickGUEST:(UIButton *)sender
{
    self.plamt = @"guest";
    self.platType = @"1";
    self.btnFB.backgroundColor = [UIColor whiteColor];
    [self.btnFB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnGOOGLE.backgroundColor = [UIColor whiteColor];
    [self.btnGOOGLE setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnGUEST.backgroundColor = [UIColor blueColor];
    [self.btnGUEST setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)click:(UIButton *)sender
{
    self.plamt = @"fb";
    self.platType = @"3";
    self.btnFB.backgroundColor = [UIColor blueColor];
    [self.btnFB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnGOOGLE.backgroundColor = [UIColor whiteColor];
    [self.btnGOOGLE setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnGUEST.backgroundColor = [UIColor whiteColor];
    [self.btnGUEST setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}
- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.isFirstClick = NO;
    [self.timer invalidate];
    self.timer = nil;
    
}

-(void)confirm:(UIButton *)sender
{
    
    
    if (!self.isFirstClick) {
        return;
    }
    self.isFirstClick = NO;
    self.isFirst = NO;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
    
    if (self.isFirst) {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"游客提示绑定")];
        self.isFirst = NO;
        return;
    }
    
    
    NSString *account = self.usernameTF.text;
    NSString *pwd = self.pwdTF.text;
    
    if ([self.plamt isEqualToString:@"fb"]) {
        //fb
        self.isFirstClick = YES;
        __weak __typeof__(self) weakSelf = self;
        [HGHAccessApi bind:^(NSString * _Nonnull bindInfo) {
            NSLog(@"bindInfo=%@",bindInfo);
            [weakSelf bindWithTpToken:bindInfo account:account pwd:pwd];
        }];
        [[HGHFacebookLogin shareinstance] facebookLogin:NO];
    }else if ([self.plamt isEqualToString:@"gp"])
    {
        self.isFirstClick = YES;
        __weak __typeof__(self) weakSelf = self;
        [HGHAccessApi bind:^(NSString * _Nonnull bindInfo) {
            NSLog(@"bindInfo=%@",bindInfo);
            [weakSelf bindWithTpToken:bindInfo account:account pwd:pwd];
        }];
        HGHGoogleLoginViewController *gvc = [HGHGoogleLoginViewController shareinstance];
        gvc.islogin = NO;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:gvc];
        [[HGHTools getCurrentViewcontronller] presentViewController:navi animated:NO completion:nil];
    }else
    {
        self.isFirstClick=YES;
        [self bindWithTpToken:@"xx" account:account pwd:pwd];
    }
    
}

-(void)bindWithTpToken:(NSString *)tpToken account:(NSString *)account pwd:(NSString *)pwd
{
    if ([account isEqualToString:@""]) {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if ([pwd isEqualToString:@""])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
    }else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else if ([pwd length]<8&&[pwd length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }
        [[HGHHttprequest shareinstance] bindAccountType:self.platType username:account pwd:pwd tp:self.plamt tpToken:tpToken ifSuccess:^(id  _Nonnull response) {
            NSLog(@"绑定成功--%@",response);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"绑定成功")];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
            [[HGHLogin shareinstance]Login];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error=%@",error);
        }];
}

@end
