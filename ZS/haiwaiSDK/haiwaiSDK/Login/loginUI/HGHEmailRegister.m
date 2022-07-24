//
//  HGHEmailRegister.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHEmailRegister.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHEmailLogin.h"
#import "HGHAccountManager.h"
#import "HGHLogin.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHAlertview.h"
#import "HGHTranslation.h"
#import "BPMaiWebview.h"
#import "HGHFlyer.h"
//#import <NSLocale.h>
@implementation HGHEmailRegister
+(instancetype)shareInstance
{
    static HGHEmailRegister *email = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        email = [[HGHEmailRegister alloc]init];
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

-(void)emailRegister
{
    self.showNum = 60;
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    
    CGFloat btnW = 65;
    if ([GuoJiHua(@"语言")isEqualToString:@"2"]) {
        btnW = 140;
    }
    CGFloat loginBtnX = (VIEWWIDTH-[HGHUIFrame adapterWidth:50])/2-[HGHUIFrame adapterWidth:btnW];
    CGFloat loginBtnY = [HGHUIFrame adapterWidth:15];
    //    CGFloat loginBtnWidth = [HGHUIFrame adapterWidth:65];
    CGFloat registerBtnX = (VIEWWIDTH+[HGHUIFrame adapterWidth:30])/2;
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtnX, loginBtnY, btnW, 40)];
    
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(registerBtnX, loginBtnY, btnW, 40)];
    [loginBtn setTitle:GuoJiHua(@"登录") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    [registerBtn setTitle:GuoJiHua(@"注册") forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    [self.imageView addSubview:loginBtn];
    [self.imageView addSubview:registerBtn];
    
    [registerBtn addTarget:self action:@selector(registEmail:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(emailLoginss:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat userinfoX = [HGHUIFrame adapterWidth:VIEWWIDTH-20];
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(userinfoX, loginBtnY, 40, 40)];
    [self.imageView addSubview:userInfoBtn];
//    userInfoBtn.backgroundColor = [UIColor redColor];
    [userInfoBtn setImage:[UIImage imageNamed:@"outSea.bundle/accountCenter.png"] forState:UIControlStateNormal];
    [userInfoBtn addTarget:self action:@selector(getUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, loginBtnY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    // register----------------
//    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
//    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
//    CGFloat textFieldY = 30+[HGHUIFrame adapterHeight:30];
//    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, 40)];
//    [self.imageView addSubview:userTextField];
//    [userTextField setBackground:[UIImage imageNamed:@"white.png"]];
//    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
//    userImage.image = [UIImage imageNamed:@"user.png"];
//    [userTextField addSubview:userImage];
//
//    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
//    userTextField.leftViewMode = UITextFieldViewModeAlways;
//    userTextField.leftView = leftView;
//    userTextField.delegate = self;
//
//    self.usernameTF = userTextField;
//    CGFloat pwdFieldY = textFieldY+40+[HGHUIFrame adapterHeight:5];
//    CGFloat pwdFieldWidth = [HGHUIFrame adapterWidth:210];//136   16
//    UITextField *pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, pwdFieldY, textFieldWidth, 40)];
//    //    [pwdTF setBackground:[UIImage imageNamed:@"white.png"]];205209211
//    [pwdTF.layer setCornerRadius:15];
//    pwdTF.layer.masksToBounds = YES;
//    [pwdTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
//    pwdTF.layer.borderWidth = 1.6;
//    UIView *leftPwdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
//    pwdTF.leftViewMode = UITextFieldViewModeAlways;
//    pwdTF.leftView = leftPwdView;
//    //    pwdTF.leftView = leftView;
//    //    pwdTF.leftViewMode = UITextFieldViewModeAlways;
//    pwdTF.secureTextEntry = YES;
//    [pwdTF setBackgroundColor:[UIColor whiteColor]];
//    self.pwdTF = pwdTF;
//    UIImageView *pwdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
//    pwdImage.image = [UIImage imageNamed:@"password.png"];
//    [pwdTF addSubview:pwdImage];
//    [self.imageView addSubview:pwdTF];
    
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat textFieldY = 30+[HGHUIFrame adapterHeight:40];
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
    userTextField.placeholder = GuoJiHua(@"请输入邮箱地址");
    CGFloat pwdFieldY = textFieldY+40+[HGHUIFrame adapterHeight:10];
    CGFloat pwdFieldWidth = [HGHUIFrame adapterWidth:210];//136   16
    UITextField *pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, pwdFieldY, textFieldWidth, 40)];
    //    [pwdTF setBackground:[UIImage imageNamed:@"white.png"]];205209211
    [pwdTF.layer setCornerRadius:20];
    pwdTF.layer.masksToBounds = YES;
//    pwdTF.placeholder = GuoJiHua(@"密码的长度必须在8到25之间");
    [pwdTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    pwdTF.layer.borderWidth = 1.6;
    UIView *leftPwdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.leftView = leftPwdView;
    //    pwdTF.leftView = leftView;
    //    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.secureTextEntry = YES;
    [pwdTF setBackgroundColor:[UIColor whiteColor]];
    self.usernameTF = userTextField;
    self.pwdTF = pwdTF;
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    pwdImage.image = [UIImage imageNamed:@"outSea.bundle/password.png"];
    [pwdTF addSubview:pwdImage];
    [self.imageView addSubview:pwdTF];
    
    CGFloat emailY =pwdFieldY+40+[HGHUIFrame adapterHeight:5];
    UITextField *email = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, emailY, textFieldWidth, 40)];
    [email.layer setCornerRadius:15];
    email.layer.masksToBounds = YES;
    [email.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    email.layer.borderWidth = 1.6;
    UIView *leftEmailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    email.leftViewMode = UITextFieldViewModeAlways;
    email.leftView = leftEmailView;
    //    pwdTF.leftView = leftView;
    //    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    email.secureTextEntry = YES;
    [email setBackgroundColor:[UIColor whiteColor]];
    self.emailTF = email;
    UIImageView *emailImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 20)];
    emailImage.image = [UIImage imageNamed:@"outSea.bundle/email.png"];
    [email addSubview:emailImage];
//    [self.imageView addSubview:email];
    

    CGFloat VeriY = pwdFieldY+40+[HGHUIFrame adapterWidth:10];
    CGFloat VeriW = [HGHUIFrame adapterWidth:215];
    CGFloat VeriBtnW = [HGHUIFrame adapterWidth:136];
    CGFloat veriBtnX =textFieldX+VeriW+[HGHUIFrame adapterWidth:10];
    UITextField *VerificationTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, VeriY, VeriW, 40)];
    [VerificationTF.layer setCornerRadius:20];
    VerificationTF.layer.masksToBounds = YES;
    [VerificationTF.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:209/255.0 blue:211/255.0 alpha:1].CGColor];
    VerificationTF.layer.borderWidth = 1.6;
    VerificationTF.backgroundColor = [UIColor whiteColor];
    UIView *verLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    VerificationTF.leftViewMode = UITextFieldViewModeAlways;
    VerificationTF.leftView = verLeftView;
    
    
    [self.imageView addSubview:VerificationTF];
    self.verifyTF = VerificationTF;
    UIButton *VeriBtn = [[UIButton alloc]initWithFrame:CGRectMake(veriBtnX, VeriY, VeriBtnW, 40)];
    [VeriBtn.layer setCornerRadius:20];
    VeriBtn.layer.masksToBounds = YES;
    self.verifyBtn = VeriBtn;
    [VeriBtn.layer setBorderColor:[UIColor blueColor].CGColor];
    VeriBtn.layer.borderWidth = 1.6;
    VeriBtn.backgroundColor = [UIColor whiteColor];
    [VeriBtn setTitle:GuoJiHua(@"验证码") forState:UIControlStateNormal];
    [VeriBtn addTarget:self action:@selector(verifycode:) forControlEvents:UIControlEventTouchUpInside];
    [VeriBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.imageView addSubview:VeriBtn];
    
    CGFloat palceViewY = VeriY+40+[HGHUIFrame adapterWidth:15];
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(textFieldX, palceViewY, textFieldWidth, 20)];
//    placeView.backgroundColor = [UIColor redColor];
    [self.imageView addSubview:placeView];
    
    self.fxkBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    
//    self.fxkBtn = fuxuankuang;
    
    if (self.confirmBtn.userInteractionEnabled) {
        NSLog(@"yyyyyy");
    }else
    {
        NSLog(@"nnnnnnnnn");
    }
//    self.fxkBtn.subviews
    [self.fxkBtn setImage:[UIImage imageNamed:@"outSea.bundle/btn.png"] forState:UIControlStateNormal];
//    [fuxuankuang setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
    [self.fxkBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [placeView addSubview:self.fxkBtn];
    [self.fxkBtn setNeedsLayout];
    [self.fxkBtn layoutIfNeeded];
    CGFloat labwidth = 75;
    if ([GuoJiHua(@"语言") isEqualToString:@"1"]) {
        labwidth = 75;
    }else
    {
        labwidth = 105;
    }
//    labwidth = 120;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, labwidth, 20)];
    lab.text = GuoJiHua(@"我已阅读并同意");
//    lab.text = @"I have read";
    NSLog(@"xxxxxxxxxxxxxxxxxxxlabwidth=%f",lab.frame.size.width);
    [placeView addSubview:lab];
    
    UIButton *protolBtn = [[UIButton alloc]initWithFrame:CGRectMake(lab.frame.size.width+20, 0, 220, 20)];
    [protolBtn setTitle:GuoJiHua(@"会员条款及管理规章") forState:UIControlStateNormal];
    [protolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [placeView addSubview:protolBtn];
    [protolBtn addTarget:self action:@selector(protol:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat confirmW = [HGHUIFrame adapterWidth:210];
    CGFloat confirmY = palceViewY + 20 +[HGHUIFrame adapterWidth:15];
    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-confirmW)/2, confirmY, confirmW, 40)];
    [self.confirmBtn.layer setCornerRadius:20];
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    [self.confirmBtn setTitle:GuoJiHua(@"注册b") forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirLogin:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.confirmBtn = confirBtn;
    self.confirmBtn.userInteractionEnabled = NO;
    [self.imageView addSubview:self.confirmBtn];

}

-(void)protol:(UIButton *)sender
{
//    https://hw.account.acingame.com/agreement/index.html
    //显示协议内容
//    NSString *udfLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
//    NSLog(@"lang=%@",udfLanguageCode);
    NSArray *arrLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSLog(@"arr=%@",arrLang);
//    NSArray*languages = [NSLocalepreferred Languages];
    
//    NSString*currentLanguage = [languages objectAtIndex:0];
    NSString *langxx = GuoJiHua(@"langxx");
    NSString *protolStr = @"https://hw.account.acingame.com/agreement/index.html?lang=";
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",protolStr,langxx];
    BPMaiWebview *maiV = [BPMaiWebview shareInstance];
    [maiV showProtol:finalStr];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    backBtn.backgroundColor = [UIColor blueColor];
    [[HGHTools getCurrentViewcontronller].view addSubview:maiV];
//    [[HGHTools getCurrentViewcontronller].view addSubview:backBtn];
    
    
    
    
//    [self.imageView addSubview:maiV];
    
    
}

-(void)click:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.confirmBtn.userInteractionEnabled = !self.confirmBtn.userInteractionEnabled;
    if (self.confirmBtn.userInteractionEnabled) {
        NSLog(@"kyidianji");
        self.confirmBtn.backgroundColor = [UIColor blueColor];
        [self.fxkBtn setImage:[UIImage imageNamed:@"outSea.bundle/btn_selected.png"] forState:UIControlStateNormal];
    }else{
        self.confirmBtn.backgroundColor = [UIColor grayColor];
        [self.fxkBtn setImage:[UIImage imageNamed:@"outSea.bundle/btn.png"] forState:UIControlStateNormal];
        [self.fxkBtn setNeedsLayout];
        [self.fxkBtn layoutIfNeeded];
    }
    [self.imageView setNeedsLayout];
    [self.imageView layoutIfNeeded];
    
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

-(void)registEmail:(UIButton *)sender
{
    
}

-(void)emailLoginss:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    [[HGHEmailLogin shareInstance] emailLogin];
}

-(void)verifycode:(UIButton *)sender
{

//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVerify:) userInfo:nil repeats:YES];
//    [sender setTitle:@"60" forState:UIControlStateNormal];
    NSString *account = self.usernameTF.text;
    if ([account isEqualToString:@""]) {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeVerify:) userInfo:nil repeats:YES];
//    [sender setTitle:@"60" forState:UIControlStateNormal];
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0)
        { //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.userInteractionEnabled = YES;
                sender.backgroundColor = [UIColor whiteColor];
                [sender setTitle:GuoJiHua(@"验证码") forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.userInteractionEnabled = NO;
                sender.backgroundColor = [UIColor lightGrayColor];
                [sender setTitle:[NSString stringWithFormat:@"%ds",timeout] forState:UIControlStateNormal];
            });
            
            timeout--;
            
        }
    });
    dispatch_resume(timer);
    
    
    
    [[HGHHttprequest shareinstance]registVerifyCodeWithUserName:account ifSuccess:^(id  _Nonnull response) {
        
//        dispatch_resume(timer);
//        sender.userInteractionEnabled = YES;
//        sender.backgroundColor = [UIColor whiteColor];
//        [sender setTitle:GuoJiHua(@"验证码") forState:UIControlStateNormal];
        
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"获取验证码失败")];
        }else{
            NSDictionary *userDict = userInfo[@"data"];
        }
        NSLog(@"验证码成功--%@",response);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
    
}

//-(void)timeVerify:(NSTimer *)timer
//{
//    [HGHTranslation shareinstance].registNum -=1;
//    NSLog(@"shownum=%d",[HGHTranslation shareinstance].registNum);
//    if ([HGHTranslation shareinstance].registNum<0) {
//        [HGHTranslation shareinstance].registNum=60;
//        [self.verifyBtn setTitle:GuoJiHua(@"验证码") forState:UIControlStateNormal];
//        self.verifyBtn.userInteractionEnabled = YES;
//        [self.timer invalidate];
//        self.timer = nil;
//        return;
//    }
//    [self.verifyBtn setTitle:[NSString stringWithFormat:@"%ld",[HGHTranslation shareinstance].registNum] forState:UIControlStateNormal];
//    self.verifyBtn.userInteractionEnabled = NO;
//}

-(void)confirLogin:(UIButton *)sender
{
    NSString *account = self.usernameTF.text;
    NSString *pwd = self.pwdTF.text;
    NSString *email = self.emailTF.text;
    NSLog(@"密码的日志=%@",GuoJiHua(@"密码的长度必须在8到25之间"));
    NSString *verifyCode = self.verifyTF.text;
    if ([account isEqualToString:@""]) {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if ([pwd isEqualToString:@""])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码不能为空")];
        return;
    }else if ([verifyCode isEqualToString:@""])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"验证码不能为空")];
        return;
    }
    else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else if([pwd length]<8 || [pwd length]>25)
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"密码的长度必须在8到25之间")];
        return;
    }else
    {
        
    }
    [[HGHHttprequest shareinstance]registWithUserName:account password:pwd device:[HGHTools getUUID] captcha:verifyCode ifSuccess:^(id  _Nonnull response) {
        
        NSDictionary *userDict = response;
        NSLog(@"userDict=%@",userDict);
        if ([userDict[@"code"] intValue]!=1) {
//            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
//            [[HGHLogin shareinstance] Login];
            [HGHAlertview showAlertViewWithMessage:userDict[@"msg"]];
            NSLog(@"错误");
        }else{
            [HGHFlyer FlyersReportEvent:@"register" params:@{@"loginType":@"acingame"}];
            NSDictionary *userData = userDict[@"data"];
            NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:userDict];
            [mutabDict setValue:@"register" forKey:@"type"];
            
            NSString *token = userData[@"token"];
            NSString *userId = userData[@"userId"];
            //            NSDictionary *userDict = userInfo[@"data"];
            [[HGHLogin shareinstance].baseView removeFromSuperview];
            for (UIView *view in [HGHLogin shareinstance].baseView.subviews) {
                [view removeFromSuperview];
            }
            [HGHAccessApi shareinstance].loginBackBlock([mutabDict copy]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
