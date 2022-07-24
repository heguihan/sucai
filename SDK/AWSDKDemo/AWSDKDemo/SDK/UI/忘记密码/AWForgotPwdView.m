//
//  AWForgotPwdView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWForgotPwdView.h"
@interface AWForgotPwdView()
@property(nonatomic, strong)AWTextField *phoneNumTF;
@property(nonatomic, strong)AWTextField *verifyCodeTF;
@property(nonatomic, strong)AWTextField *pwdTF;
@property(nonatomic, strong)AWTextField *confirmPwdTF;
@property(nonatomic, strong)AWHGHALLButton *sendBtn;
@end

@implementation AWForgotPwdView

static NSString *_PhoneNO = @"";
static BOOL _isBindPhone = NO;

+(instancetype)factory_forgotPwdView
{
    AWForgotPwdView *forgotview = [[AWForgotPwdView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight+TFHeight)];
    [forgotview configUI];
    return forgotview;
}

-(void)configUI
{
    self.title = @"找回密码";
    self.closeBtn.hidden = YES;
    

    
    [self addcontentView];
}

-(void)addcontentView
{
    
    _isBindPhone = [AWUserInfoManager shareinstance].is_bind_mobile;
    _PhoneNO = [AWUserInfoManager shareinstance].mobile;
    NSString *secuPhoneNO = _PhoneNO;
    if (_PhoneNO.length>=11) {
        secuPhoneNO = [_PhoneNO stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
//    NSString *secuPhoneNO = [_PhoneNO stringByReplacingCharactersInRange:NSMakeRange(3, 7) withString:@"*"];
    
    UILabel *myPhoneNOLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(61), TFWidth, TFHeight)];
    myPhoneNOLab.text = [NSString stringWithFormat:@"我的手机号：%@",secuPhoneNO];
    myPhoneNOLab.textAlignment = NSTextAlignmentLeft;
    myPhoneNOLab.textColor = BLACKCOLOR;
    myPhoneNOLab.backgroundColor = [UIColor clearColor];
    
    UILabel *noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ViewWidth, 20)];
    noticeLab.text = @"请完成手机号认证，重置密码";
    noticeLab.backgroundColor = RGBA(250, 227, 205, 1);//250,227,205
//    [noticeLab setTintColor:RGBA(255, 90, 0, 1)]; //255,90,0
    noticeLab.font = FONTSIZE(13);
    noticeLab.textColor = RGBA(255, 90, 0, 1);
    noticeLab.textAlignment = NSTextAlignmentCenter;
    
    CGFloat btnWidth = AdaptWidth(93);
    self.phoneNumTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(61)];
    self.verifyCodeTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:btnWidth marginY:AdaptWidth(110)];
    self.pwdTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:31 marginY:AdaptWidth(158)];
    self.confirmPwdTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:31 marginY:AdaptWidth(210)];
    
    self.phoneNumTF.placeholder = @"请输入手机号";
    self.verifyCodeTF.placeholder = @"请输入验证码";
    self.pwdTF.placeholder = @"请输入新密码";
    self.pwdTF.secureTextEntry = YES;
    self.confirmPwdTF.placeholder = @"请确认新密码";
    self.confirmPwdTF.secureTextEntry = YES;
    
//    self.sendBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(TFWidth-btnWidth, 0, btnWidth, TFHeight)];
    self.sendBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(10, 0, btnWidth, TFHeight)];
    self.sendBtn.backgroundColor = BTNORANGECOLOR;
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = FONTSIZE(13.3);
    [self.verifyCodeTF.rightView addSubview:self.sendBtn];
    [self.sendBtn addTarget:self action:@selector(clickSendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    AWHGHALLButton *eyesBtn = [AWSmallControl getEyesBtn];
    [self.pwdTF.rightView addSubview:eyesBtn];
    [eyesBtn addTarget:self action:@selector(clickEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    AWHGHALLButton *eyesBtn2 = [AWSmallControl getEyesBtn];
    [self.confirmPwdTF.rightView addSubview:eyesBtn2];
    [eyesBtn2 addTarget:self action:@selector(clickEyes2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    AWOrangeBtn *searchBackBtn = [AWOrangeBtn factoryBtnWithTitle:@"修改" marginY:AdaptWidth(258)];
//    AWOrangeBtn *searchBackBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake(MarginX+TFWidth/4.0, AdaptWidth(258), TFWidth/2.0, TFHeight)];
    [searchBackBtn addTarget:self action:@selector(clickSearchBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_isBindPhone) {
        [self addSubview:myPhoneNOLab];
    }else{
        [self addSubview:noticeLab];
        [self addSubview:self.phoneNumTF];
    }

    [self addSubview:self.verifyCodeTF];
    [self addSubview:self.pwdTF];
    [self addSubview:self.confirmPwdTF];
    [self addSubview:searchBackBtn];
}

-(void)clickSearchBack
{
    //判断
    
    
    
    NSString *phoneNO = self.phoneNumTF.text;
    NSString *captcha = self.verifyCodeTF.text;
    NSString *newPWD = self.pwdTF.text;
    NSString *confirmPWD = self.confirmPwdTF.text;
//
    
    if (_PhoneNO.length<5 && phoneNO.length<11) {
        [AWTools makeToastWithText:@"请输入正确的手机号"];
        return;
    }

    if (captcha.length<4) {
        [AWTools makeToastWithText:@"请输入正确的验证码"];
        return;
    }
    if (![AWConfig regularPwd:newPWD]) {
        [AWTools makeToastWithText:@"请输入6-18位的密码"];
        return;
    }
    if (![AWConfig regularPwd:confirmPWD]) {
        [AWTools makeToastWithText:@"请输入6-18位的密码"];
        return;
    }
    if (![newPWD isEqualToString:confirmPWD]) {
        [AWTools makeToastWithText:@"两次输入的密码不一致"];
        return;
    }
    
    WeakSelf
    [AWHTTPRequest AWForgotPWDRequestWithPhoneNO:phoneNO captch:captcha newPWD:newPWD ifSuccess:^(id  _Nonnull response) {
        if ([response[@"code"] intValue]==200) {
            [weakself dealWithUserInfo:response[@"data"]];
        }else{
            NSString *msg = response[@"msg"];
            [AWTools makeToastWithText:msg];
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

-(void)dealWithUserInfo:(NSDictionary *)userInfo
{
    [[AWUserInfoManager shareinstance] updateUserInfoWithData:userInfo];
    [AWLoginViewManager refreshWebview];
    [self closeAllView];
}

-(void)clickSendCode:(AWHGHALLButton *)sender
{
    AWLog(@"verifycode click");
    NSString *phoneNO = self.phoneNumTF.text;
    if (_PhoneNO.length<5 && phoneNO.length<11) {
        [AWTools makeToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (phoneNO) {
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
                        sender.backgroundColor = BTNORANGECOLOR;
                        [sender setTitle:@"发送" forState:UIControlStateNormal];
                    });
                }
            else
                {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sender.userInteractionEnabled = NO;
                    sender.backgroundColor = ORANGEUNABLEBTNCOLOR;
                    [sender setTitle:[NSString stringWithFormat:@"重新发送(%ds)",timeout] forState:UIControlStateNormal];
                });

                timeout--;

                }
        });
        dispatch_resume(timer);
    }
    
    
    [AWHTTPRequest AWSendCaptchaForGotPWDRequestWithphoneNO:phoneNO ifSuccess:^(id  _Nonnull response) {
        if ([response[@"code"] intValue]==200) {
            [AWTools makeToastWithText:@"验证码已发送"];
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
}

-(void)clickEyes:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
}

-(void)clickEyes2:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.confirmPwdTF.secureTextEntry = !sender.selected;
}

@end
