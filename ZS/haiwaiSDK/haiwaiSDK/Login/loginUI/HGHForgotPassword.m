//
//  HGHForgotPassword.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHForgotPassword.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHLogin.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHEmailLogin.h"
//#import "HGHAccessApi.h"
#import "HGHAlertview.h"
#import "HGHLogin.h"
@implementation HGHForgotPassword

+(instancetype)shareInstance
{
    static HGHForgotPassword *forgot = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        forgot = [[HGHForgotPassword alloc]init];
    });
    
    return forgot;
}

-(void)gotoForgotPassword
{
    
    self.isFirst = YES;
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    [self.imageView setImage:[UIImage imageNamed:@"outSea.bundle/bgwhite.png"]];
    self.imageView.userInteractionEnabled = YES;
//    [currentVC.view addSubview:self.imageView];
    [[HGHLogin shareinstance].baseView addSubview:self.imageView];
    CGFloat labX = (VIEWWIDTH-[HGHUIFrame adapterWidth:300])/2;
    CGFloat labY = [HGHUIFrame adapterWidth:15];
    CGFloat labWidth = [HGHUIFrame adapterWidth:300];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labWidth, 25)];
    titleLab.text = GuoJiHua(@"忘记密码");
    titleLab.font = [UIFont systemFontOfSize:25];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:titleLab];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, labY, 20, 30)];
    [self.imageView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat textFieldWidth = [HGHUIFrame adapterWidth:362];
    CGFloat textFieldX = (VIEWWIDTH-textFieldWidth)/2;
    CGFloat textFieldY = 25+[HGHUIFrame adapterHeight:30];
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, 50)];
    [self.imageView addSubview:userTextField];
    [userTextField setBackground:[UIImage imageNamed:@"outSea.bundle/white.png"]];
    userTextField.placeholder = GuoJiHua(@"请输入邮箱地址");
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    userImage.image = [UIImage imageNamed:@"outSea.bundle/user.png"];
    [userTextField addSubview:userImage];
    self.usernameTF = userTextField;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    userTextField.leftViewMode = UITextFieldViewModeAlways;
    userTextField.leftView = leftView;
    userTextField.delegate = self;
    
    CGFloat instructionLabY = textFieldY + [HGHUIFrame adapterWidth:10] +50;
    UILabel *instructionsLab = [[UILabel alloc]init];
    instructionsLab.text = GuoJiHua(@"忘记密码提示");
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
  
    CGSize labelSize = [instructionsLab.text boundingRectWithSize:CGSizeMake(textFieldWidth-50, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    instructionsLab.frame = CGRectMake(textFieldX+25,instructionLabY,labelSize.width,labelSize.height);

     instructionsLab.numberOfLines = 0;//表示label可以多行显示
   
//     instructionsLab.textColor = UICOLOR_FROM_RGB(100, 100, 100, 1);
    instructionsLab.font = [UIFont systemFontOfSize:14];
    [self.imageView addSubview:instructionsLab];
    
    CGFloat VeriW = [HGHUIFrame adapterWidth:215];
    CGFloat VeriBtnW = [HGHUIFrame adapterWidth:136];
    CGFloat veriBtnX =textFieldX+VeriW+[HGHUIFrame adapterWidth:10];
    CGFloat verifyY = instructionLabY+labelSize.height+[HGHUIFrame adapterWidth:10];
    UITextField *verifyTF = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, verifyY, VeriW, 50)];
    [self.imageView addSubview:verifyTF];
    [verifyTF.layer setCornerRadius:25];
    verifyTF.layer.masksToBounds = YES;
    verifyTF.backgroundColor = [UIColor whiteColor];
    self.verifycodeTF = verifyTF;
    UIView *verLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    verifyTF.leftViewMode = UITextFieldViewModeAlways;
    verifyTF.leftView = verLeftView;
    
    
    UIButton *verifyBtn = [[UIButton alloc]initWithFrame:CGRectMake(veriBtnX, verifyY, VeriBtnW, 50)];
    [verifyBtn setTitle:GuoJiHua(@"验证码") forState:UIControlStateNormal];
    [self.imageView addSubview:verifyBtn];
    [verifyBtn.layer setCornerRadius:25];
    verifyBtn.layer.masksToBounds = YES;
    [verifyBtn.layer setBorderColor:[UIColor blueColor].CGColor];
    verifyBtn.layer.borderWidth = 1.6;
    [verifyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat sureBtnY = verifyY + 50+[HGHUIFrame adapterWidth:10];
    CGFloat sureBtnW = [HGHUIFrame adapterWidth:200];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-sureBtnW)/2, sureBtnY, sureBtnW, 50)];
    [sureBtn.layer setCornerRadius:25];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = [UIColor blueColor];
    [self.imageView addSubview:sureBtn];
    [sureBtn setTitle:GuoJiHua(@"确认") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goback:(UIButton *)sender
{
    [self.imageView removeFromSuperview];
}

-(void)verifyCode:(UIButton *)sender
{
    NSString *account = self.usernameTF.text;
    if ([account isEqualToString:@""]) {
        NSLog(@"账号为空");
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else{
        
    }
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
    __weak __typeof(self)weakSelf = self;
    [[HGHHttprequest shareinstance] resetPwdWithusername:account ifSuccess:^(id  _Nonnull response) {
        
        NSLog(@"忘记密码验证码发送成功--%@",response);
        NSDictionary *userInfo = response;
        
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            //            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"获取验证码失败")];
            [HGHAlertview showAlertViewWithMessage:userInfo[@"msg"]];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];

            
            //            NSDictionary *userDict = userInfo[@"data"];
            //            NSString *userId = userDict[@"userId"];
            //            NSString *username = userDict[@"username"];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
}


- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.isFirst = NO;
    [self.timer invalidate];
    self.timer = nil;
    
}
-(void)confirm:(UIButton *)sender
{
//    NSString *timeCurrent = [HGHTools getTimeString];
//    self.count = 0;
    
    
    if (!self.isFirst) {
        return;
    }
    self.isFirst = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
    
    NSString *account = self.usernameTF.text;
    NSString *verifycode = self.verifycodeTF.text;
    if ([account isEqualToString:@""]) {
        NSLog(@"账号为空");
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号不能为空")];
        return;
    }else if (![HGHTools checkEmail:account])
    {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"邮箱格式不匹配")];
        return;
    }else if([verifycode isEqualToString:@""]){
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"验证码不能为空")];
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [[HGHHttprequest shareinstance] searchPwdWithusername:account captcha:verifycode ifSuccess:^(id  _Nonnull response) {
        NSLog(@"找回密码--%@",response);
        NSDictionary *userInfo = response;
        self.isFirst = YES;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
//            self.isFirst = YES;
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"找回密码失败")];
        }else{
            NSLog(@"success");
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"新密码已发送至邮箱")];
            NSLog(@"xxxx什么原因");
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
            [HGHLogin shareinstance].baseView = [[UIView alloc]initWithFrame:CGRectMake(XPOINT, YPOINT, VIEWWIDTH, VIEWHEIGHT)];
            UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
            [currentVC.view addSubview:[HGHLogin shareinstance].baseView];
            [[HGHEmailLogin shareInstance] emailLogin];
        }
    } failure:^(NSError * _Nonnull error) {
        self.isFirst = YES;
        NSLog(@"error=%@",error);
    }];
}

@end
