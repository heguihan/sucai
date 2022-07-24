//
//  AWChapterLogin.m
//  AWSDKDemo
//
//  Created by admin on 2021/3/4.
//

#import "AWChapterLogin.h"

#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@interface AWChapterLogin()
@property(nonatomic, strong)AWTextField *phoneNumTF;
@property(nonatomic, strong)AWTextField *verifyCodeTF;
@property(nonatomic, strong)AWTextField *pwdTF;
@property(nonatomic, strong)AWHGHALLButton *sendBtn;
@property(nonatomic, assign)BOOL isChecked;

@end

@implementation AWChapterLogin

+(instancetype)factory_chapterLogin
{
    AWChapterLogin *chapterLoginview = [[AWChapterLogin alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-40)];
    [chapterLoginview configUI];
    return chapterLoginview;
}

-(void)configUI
{
    [self addcontentView];
    [self addProtolLab];
}

-(void)addcontentView
{
    CGFloat btnWidth = AdaptWidth(93);
    self.phoneNumTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(8)];
    self.verifyCodeTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:btnWidth marginY:AdaptWidth(56)];
    
    self.phoneNumTF.delegate = self;
    self.verifyCodeTF.delegate = self;
    
    self.phoneNumTF.placeholder = GUOJIHUA(@"手机号");
    self.verifyCodeTF.placeholder = GUOJIHUA(@"验证码");
    
    
    self.sendBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(10, 0, btnWidth, TFHeight)];
    self.sendBtn.backgroundColor = BTNORANGECOLOR;
    [self.sendBtn setTitle:GUOJIHUA(@"发送") forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = FONTSIZE(13.3);
    [self.verifyCodeTF.rightView addSubview:self.sendBtn];
    [self.sendBtn addTarget:self action:@selector(clickSendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    AWHGHALLButton *eyesBtn = [AWSmallControl getEyesBtn];
    [self.pwdTF.rightView addSubview:eyesBtn];
    [eyesBtn addTarget:self action:@selector(clickEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    
    AWOrangeBtn *registBtn = [AWOrangeBtn factoryBtnWithTitle:GUOJIHUA(@"登录") marginY:AdaptWidth(116)];
    [registBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.phoneNumTF];
    [self addSubview:self.verifyCodeTF];
//    [self addSubview:self.pwdTF];
    [self addSubview:registBtn];
}

-(void)addProtolLab
{
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(169), TFWidth, 15)];
    [self addSubview:lab];
    BOOL isprivacy = NO;
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:GUOJIHUA(@"同意用户协议")];
    NSArray *linkList = [AWSDKConfigManager shareinstance].link;
    if (linkList.count>0) {
        for (NSDictionary *dic in linkList) {
            if ([dic.allKeys containsObject:@"key"]) {
                if ([dic[@"key"] isEqualToString:@"Privacy"]) {
                    [mutableStr appendString:GUOJIHUA(@"&隐私协议")];
                    isprivacy = YES;
                }
            }
        }
    }
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:[mutableStr copy]];
     text.yy_lineSpacing = 5;
     text.yy_font = FONTSIZE(13);
     text.yy_color = BLACKCOLOR;
     [text yy_setTextHighlightRange:NSMakeRange(5, 15) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
         AWLog(@"xxx协议被点击了");
         [AWLoginViewManager showUserProtocol];
     }];
    if (isprivacy) {
        [text yy_setTextHighlightRange:NSMakeRange(23, 14) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            AWLog(@"xxx协议被点击了");
            [AWLoginViewManager showPrivacyProtocol];

        }];
    }

     lab.numberOfLines = 0;  //设置多行显示
     lab.preferredMaxLayoutWidth = TFWidth; //设置最大的宽度
     lab.attributedText = text;  //设置富文本
}


-(void)clickRegist
{
    NSString *phoneNO = self.phoneNumTF.text;
    NSString *code = self.verifyCodeTF.text;
    if (![AWConfig regularPhoneNO:phoneNO]) {
        return;
    }
    if (!code) {
        return;
    }

    [AWDataReport saveEventWittEvent:@"app_login_phone" properties:@{}];
    [AWHTTPRequest AWOUTSEAloginRequest:code loginType:LOGIN_PHONE ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
}

-(void)clickSendCode:(AWHGHALLButton *)sender
{
    AWLog(@"verifycode click");
    NSString *phoneNO = self.phoneNumTF.text;
    
    if (![AWConfig regularPhoneNO:phoneNO]) {
        [AWTools makeToastWithText:@"Phone NO is error"];
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
                        [sender setTitle:GUOJIHUA(@"发送") forState:UIControlStateNormal];
                    });
                }
            else
                {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sender.userInteractionEnabled = NO;
                    sender.backgroundColor = ORANGEUNABLEBTNCOLOR;
                    [sender setTitle:[NSString stringWithFormat:@"%@(%ds)",GUOJIHUA(@"重新发送"),timeout] forState:UIControlStateNormal];
                });

                timeout--;

                }
        });
        dispatch_resume(timer);
    }
    
    [AWHTTPRequest AWSendCaptchaRequestWithphoneNO:phoneNO ifSuccess:^(id  _Nonnull response) {
        AWLog(@"response===%@",response);
        if ([response[@"code"] intValue]==200) {
            [AWTools makeToastWithText:GUOJIHUA(@"验证码已发送")];
        }
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
    }];
    
}

-(void)goback
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONLOGINLIST object:self userInfo:nil];
    [self gobackFromSelfView];
}

-(void)clickEyes:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
}


#pragma textfield delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumTF) {
        [self.verifyCodeTF becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}


@end
