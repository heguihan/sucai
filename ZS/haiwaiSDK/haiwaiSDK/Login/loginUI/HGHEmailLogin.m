//
//  HGHEmailLogin.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/11.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHEmailLogin.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHEmailRegister.h"
#import "HGHAccountManager.h"
#import "HGHFacebookLogin.h"
#import "HGHGoogleLoginViewController.h"
#import "HGHTourists.h"
#import "HGHForgotPassword.h"
#import "HGHLogin.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHAlertview.h"
#import "HGHConfig.h"
#import "HGHAppleLogin.h"
@implementation HGHEmailLogin
+(instancetype)shareInstance
{
    static HGHEmailLogin *email = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        email = [[HGHEmailLogin alloc]init];
    });
    return email;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    }
    return _imageView;
}

-(void)emailLogin
{
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [HGHLogin shareinstance].baseImageview = self.imageView;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat btnW = 65;
    if ([GuoJiHua(@"语言")isEqualToString:@"2"]) {
        btnW = 140;
    }
    CGFloat loginBtnX = (VIEWWIDTH-[HGHUIFrame adapterWidth:50])/2-[HGHUIFrame adapterWidth:btnW];
//    if ([GuoJiHua(@"语言")isEqualToString:@"2"]) {
//        loginBtnX = (VIEWWIDTH-[HGHUIFrame adapterWidth:50])/2-[HGHUIFrame adapterWidth:btnW];
//    }
    CGFloat loginBtnY = [HGHUIFrame adapterWidth:15];
//    CGFloat loginBtnWidth = [HGHUIFrame adapterWidth:65];
    CGFloat registerBtnX = (VIEWWIDTH+[HGHUIFrame adapterWidth:30])/2;
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtnX, loginBtnY, btnW, 40)];
    /*
     ceshi
     */
//    loginBtn.backgroundColor = [UIColor orangeColor];
    
    
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(registerBtnX, loginBtnY, btnW, 40)];
    [loginBtn setTitle:GuoJiHua(@"登录") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:30];

    [registerBtn setTitle:GuoJiHua(@"注册") forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    [self.imageView addSubview:loginBtn];
    [self.imageView addSubview:registerBtn];
    
    [registerBtn addTarget:self action:@selector(registEmail:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(emailLoginss:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat userinfoX = [HGHUIFrame adapterWidth:VIEWWIDTH-20];
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(userinfoX, loginBtnY, 40, 40)];
    [self.imageView addSubview:userInfoBtn];
    [userInfoBtn setImage:[UIImage imageNamed:@"outSea.bundle/accountCenter.png"] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(getUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, loginBtnY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat textFieldY = 30+[HGHUIFrame adapterHeight:40];
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, 40)];
    [self.imageView addSubview:userTextField];
    [userTextField setBackground:[UIImage imageNamed:@"outSea.bundle/white.png"]];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    userImage.image = [UIImage imageNamed:@"outSea.bundle/user.png"];
    [userTextField addSubview:userImage];
    userTextField.placeholder = GuoJiHua(@"请输入邮箱地址");
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    userTextField.leftViewMode = UITextFieldViewModeAlways;
//    userTextField.textColor = [UIColor blackColor];
    userTextField.leftView = leftView;
    userTextField.delegate = self;
    CGFloat pwdFieldY = textFieldY+40+[HGHUIFrame adapterHeight:10];
    CGFloat pwdFieldWidth = [HGHUIFrame adapterWidth:210];//136   16
    UITextField *pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, pwdFieldY, textFieldWidth, 40)];
//    [pwdTF setBackground:[UIImage imageNamed:@"white.png"]];205209211
    [pwdTF.layer setCornerRadius:20];
//    pwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
    pwdTF.layer.masksToBounds = YES;
    [pwdTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    pwdTF.layer.borderWidth = 1.6;
    UIView *leftPwdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.leftView = leftPwdView;
//    pwdTF.leftView = leftView;
//    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.secureTextEntry = YES;
    [pwdTF setBackgroundColor:[UIColor whiteColor]];
    self.userNameTF = userTextField;
    self.pwdTF = pwdTF;
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    pwdImage.image = [UIImage imageNamed:@"outSea.bundle/password.png"];
    [pwdTF addSubview:pwdImage];
    [self.imageView addSubview:pwdTF];
    
    CGFloat searchX = textFieldX + [HGHUIFrame adapterWidth:226];
    CGFloat searchWidth = [HGHUIFrame adapterWidth:136];
    UIButton *searchBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchX, pwdFieldY, searchWidth, 40)];
    [searchBackBtn.layer setCornerRadius:20];
    searchBackBtn.layer.masksToBounds = YES;
    [searchBackBtn.layer setBorderColor:[UIColor blueColor].CGColor];
    [searchBackBtn.layer setBorderWidth:2.0];
    [searchBackBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchBackBtn setTitle:GuoJiHua(@"找回密码") forState:UIControlStateNormal];
    [searchBackBtn addTarget:self action:@selector(searchPwd:) forControlEvents:UIControlEventTouchUpInside];
//    [self.imageView addSubview:searchBackBtn];
    
    CGFloat changeBtnY =textFieldY+80+[HGHUIFrame adapterHeight:20];
    UIButton *changePasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(textFieldX, changeBtnY, textFieldWidth, 40)];
    [changePasswordBtn setBackgroundColor:[UIColor blueColor]];
//    [changePasswordBtn set]
    [changePasswordBtn.layer setCornerRadius:20];
    changePasswordBtn.layer.masksToBounds=YES;
    [changePasswordBtn setTitle:GuoJiHua(@"确认") forState:UIControlStateNormal];
    [changePasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changePasswordBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [changePasswordBtn addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:changePasswordBtn];
    
    CGFloat labY =textFieldY+120+[HGHUIFrame adapterHeight:40];
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(textFieldX, labY, textFieldWidth, 30)];
//    [self.imageView addSubview:textLab];
//    textLab.text = @"—————其他账号登入方式—————";
    textLab.text = [NSString stringWithFormat:@"————%@————",GuoJiHua(@"其他方式登录")];
    textLab.textAlignment = NSTextAlignmentCenter;
    CGFloat otherBtnY = labY+[HGHUIFrame adapterWidth:10]+30;
    CGFloat otherBtnW = [HGHUIFrame adapterWidth:80];
    CGFloat otherBtnH = 50;
    NSArray *arr = @[@"outSea.bundle/fb_icon.png",@"outSea.bundle/guest_icon.png",@"outSea.bundle/google_icon.png",@"outSea.bundle/apple_icon.png"];
    for (int i=0; i<4; i++) {
        CGFloat otherX = textFieldX+[HGHUIFrame adapterWidth:95]*i;
        if (i==3) {
            otherBtnW = [HGHUIFrame adapterWidth:70];
            otherBtnH = 55;
            otherX = otherX+10;
        }
        UIButton *otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(otherX, otherBtnY, otherBtnW, 50)];
//        [self.imageView addSubview:otherBtn];
//        [otherBtn setBackgroundColor:[UIColor blueColor]];
        [otherBtn.layer setCornerRadius:20];
        otherBtn.layer.masksToBounds=YES;
        otherBtn.tag = 111+i;
        [otherBtn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)getUserInfo:(UIButton *)sender
{
    [[HGHAccountManager shareInstance] accountManager];
}

-(void)goback:(UIButton *)sender
{
    NSLog(@"goback");
    [self.imageView removeFromSuperview];
}

//上层的注册
-(void)registEmail:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
    [[HGHEmailRegister shareInstance] emailRegister];
}
//上层的登录
-(void)emailLoginss:(UIButton *)sender
{
    
}

-(void)otherLogin:(UIButton *)sender
{
    switch (sender.tag) {
        case 111:
            [self facebookLogin];
            break;
        case 112:
            [self touristLogin];
            break;
        case 113:
            [self googleLogin];
            break;
        case 114:
            [self appleLogin];
        default:
            break;
    }
}

-(void)appleLogin
{
    NSLog(@"appleLogin");
    NSLog(@"appleLogin");
    if (@available(iOS 13.0, *)) {
        [[HGHAppleLogin shareinstance] HGHsignInWithApple];
    } else {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"仅限ios13以上用户使用")];
    }
}

-(void)emailLogin:(UIButton *)sender
{
    NSString *account = self.userNameTF.text;
    NSString *pwd = self.pwdTF.text;
    NSLog(@"account=%@, pwd=%@",account,pwd);
    if ([account isEqualToString:@""]) {
        NSLog(@"账号为空");
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if ([pwd isEqualToString:@""]){
        NSLog(@"密码为空");
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
    }else if (![HGHTools checkEmail:account]){
        NSLog(@"邮箱不匹配");
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else if([pwd length]<8||[pwd length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }
    
    [[HGHHttprequest shareinstance]loginWithUserName:account andPassword:pwd andDevice:[HGHTools getUUID] type:@"2" tp:@"email" tpToken:@"shaji" ifSuccess:^(id  _Nonnull response) {
        [HGHAccessApi shareinstance].loginBackBlock(response);
        
//        [[HGHLogin shareinstance].baseView removeFromSuperview];
    } failure:^(NSError * _Nonnull error) {
//        [HGHAccessApi shareinstance].logoutBackBlock();
    }];
}
-(void)searchPwd:(UIButton *)sender
{
    [[HGHForgotPassword shareInstance] gotoForgotPassword];
}
-(void)facebookLogin
{
    [[HGHFacebookLogin shareinstance] facebookLogin:YES];
}

-(void)touristLogin
{
    [HGHTourists touristsLogin];
}

-(void)googleLogin
{
    HGHGoogleLoginViewController *gvc = [[HGHGoogleLoginViewController alloc]init];
    gvc.islogin = YES;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:gvc];
    
    [[HGHTools getCurrentViewcontronller] presentViewController:navi animated:NO completion:nil];
//    [self.hghimagevc removeFromSuperview];
}
@end
