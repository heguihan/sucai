//
//  HGHEmailBand.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHEmailBand.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHLogin.h"

@implementation HGHEmailBand
+(instancetype)shareInstance
{
    static HGHEmailBand *emailBd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emailBd = [[HGHEmailBand alloc]init];
    });
    return emailBd;
}

-(void)emailBand
{
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat labX = (VIEWWIDTH-[HGHUIFrame adapterWidth:200])/2;
    CGFloat labY = [HGHUIFrame adapterWidth:15];
    CGFloat labWidth = [HGHUIFrame adapterWidth:200];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labWidth, 25)];
    titleLab.text = @"Email信箱绑定";
    titleLab.font = [UIFont systemFontOfSize:25];
    [self.imageView addSubview:titleLab];
    //    CGFloat loginBtnWidth = [HGHUIFrame adapterWidth:65];
//    CGFloat registerBtnX = (VIEWWIDTH+[HGHUIFrame adapterWidth:50])/2;
//    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtnX, loginBtnY, 65, 40)];
//
//    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(registerBtnX, loginBtnY, 65, 40)];
//    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    loginBtn.titleLabel.font = [UIFont systemFontOfSize:30];
//
//    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    registerBtn.titleLabel.font = [UIFont systemFontOfSize:30];
//
//    [self.imageView addSubview:loginBtn];
//    [self.imageView addSubview:registerBtn];
//
//    [registerBtn addTarget:self action:@selector(registEmail:) forControlEvents:UIControlEventTouchUpInside];
//    [loginBtn addTarget:self action:@selector(emailLoginss:) forControlEvents:UIControlEventTouchUpInside];
//
//    CGFloat userinfoX = [HGHUIFrame adapterWidth:415];
//
//    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(userinfoX, loginBtnY, 40, 40)];
//    [self.imageView addSubview:userInfoBtn];
//    userInfoBtn.backgroundColor = [UIColor redColor];
    
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, labY, 20, 20)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    // register----------------
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat textFieldY = 25+[HGHUIFrame adapterHeight:30];
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, 40)];
    [self.imageView addSubview:userTextField];
    [userTextField setBackground:[UIImage imageNamed:@"outSea.bundle/white.png"]];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    userImage.image = [UIImage imageNamed:@"outSea.bundle/user.png"];
    [userTextField addSubview:userImage];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    userTextField.leftViewMode = UITextFieldViewModeAlways;
    userTextField.leftView = leftView;
    userTextField.delegate = self;
    
    
    CGFloat pwdFieldY = textFieldY+40+[HGHUIFrame adapterHeight:5];
    CGFloat pwdFieldWidth = [HGHUIFrame adapterWidth:210];//136   16
    UITextField *pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, pwdFieldY, textFieldWidth, 40)];
    //    [pwdTF setBackground:[UIImage imageNamed:@"white.png"]];205209211
    [pwdTF.layer setCornerRadius:15];
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
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    pwdImage.image = [UIImage imageNamed:@"outSea.bundle/password.png"];
    [pwdTF addSubview:pwdImage];
    [self.imageView addSubview:pwdTF];
    
    CGFloat middleLabY = pwdFieldY+40+[HGHUIFrame adapterWidth:10];
    UILabel *middleLab = [[UILabel alloc]initWithFrame:CGRectMake(textFieldX, middleLabY, textFieldWidth, 15)];
    middleLab.text=@"绑定邮箱后可在游戏内领取高额礼包哦";
    middleLab.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:middleLab];
    
    CGFloat emailY = middleLabY+15+[HGHUIFrame adapterWidth:5];
    UITextField *emailTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, emailY, textFieldWidth, 40)];
    [emailTF.layer setCornerRadius:20];
    emailTF.layer.masksToBounds=YES;
    [emailTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    emailTF.layer.borderWidth = 1.6;
    UIView *emailLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    emailTF.leftViewMode = UITextFieldViewModeAlways;
    emailTF.leftView = emailLeft;
    [emailTF setBackgroundColor:[UIColor whiteColor]];
    UIImageView *emailImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 20)];
    emailImage.image = [UIImage imageNamed:@"outSea.bundle/email.png"];
    [emailTF addSubview:emailImage];
    [self.imageView addSubview:emailTF];
    
    CGFloat VeriY = emailY+40+[HGHUIFrame adapterWidth:5];
    CGFloat VeriW = [HGHUIFrame adapterWidth:215];
    CGFloat VeriBtnW = [HGHUIFrame adapterWidth:136];
    CGFloat veriBtnX =textFieldX+VeriW+[HGHUIFrame adapterWidth:10];
    UITextField *VerificationTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, VeriY, VeriW, 40)];
    [VerificationTF.layer setCornerRadius:20];
    VerificationTF.layer.masksToBounds = YES;
    [VerificationTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    VerificationTF.layer.borderWidth = 1.6;
    VerificationTF.backgroundColor = [UIColor whiteColor];
    [self.imageView addSubview:VerificationTF];
    
    UIButton *VeriBtn = [[UIButton alloc]initWithFrame:CGRectMake(veriBtnX, VeriY, VeriBtnW, 40)];
    [VeriBtn.layer setCornerRadius:20];
    VeriBtn.layer.masksToBounds = YES;
    [VeriBtn.layer setBorderColor:[UIColor blueColor].CGColor];
    VeriBtn.layer.borderWidth = 1.6;
    VeriBtn.backgroundColor = [UIColor whiteColor];
    [VeriBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [VeriBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.imageView addSubview:VeriBtn];
    
    CGFloat sureBtnY = VeriY +40+[HGHUIFrame adapterWidth:10];
    CGFloat sureBtnW = [HGHUIFrame adapterWidth:200];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-sureBtnW)/2, sureBtnY, sureBtnW, 40)];
    [self.imageView addSubview:sureBtn];
    [sureBtn.layer setCornerRadius:20];
    sureBtn.layer.masksToBounds=YES;
    [sureBtn setTitle:@"确认登入" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    
}

-(void)goback:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
}


@end
