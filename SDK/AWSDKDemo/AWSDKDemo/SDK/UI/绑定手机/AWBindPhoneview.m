//
//  AWBindPhoneview.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWBindPhoneview.h"
#import "AWHttpResult.h"

@interface AWBindPhoneview()
@property(nonatomic, strong)AWTextField *phoneNumTF;
@property(nonatomic, strong)AWTextField *verifyCodeTF;
@property(nonatomic, strong)AWHGHALLButton *sendBtn;
@end

@implementation AWBindPhoneview

+(instancetype)factory_bindPhoneViewWithCloseHidden:(BOOL)closeHidden
{
    AWBindPhoneview *phoneRegistview = [[AWBindPhoneview alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [phoneRegistview configUIWithClosehidden:closeHidden];
    return phoneRegistview;
}

static BOOL _isWechatBind = NO;

-(void)configUIWithClosehidden:(BOOL)closeHidden
{
    self.title = @"绑定手机";
    self.backBtn.hidden = YES;
    self.closeBtn.hidden = closeHidden;
    _isWechatBind = closeHidden;
    if (_isWechatBind) {
        //改变大小
        [[AWGlobalDataManage shareinstance].loginListView changeSmallFrame];
    }
    
    [self addcontentView];
}

-(void)addcontentView
{
    CGFloat btnWidth = AdaptWidth(93);
    self.phoneNumTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(78)];
    self.verifyCodeTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:btnWidth marginY:AdaptWidth(126)];
    
    self.phoneNumTF.placeholder = @"请输入手机号";
    self.verifyCodeTF.placeholder = @"请输入验证码";
    
    
    self.sendBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(10, 0, btnWidth, TFHeight)];
    self.sendBtn.backgroundColor = BTNORANGECOLOR;
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = FONTSIZE(13.3);
    [self.verifyCodeTF.rightView addSubview:self.sendBtn];
    [self.sendBtn addTarget:self action:@selector(clickSendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    AWOrangeBtn *searchBackBtn = [AWOrangeBtn factoryBtnWithTitle:@"绑定手机" marginY:AdaptWidth(186)];
    [searchBackBtn addTarget:self action:@selector(clickBindPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.phoneNumTF];
    [self addSubview:self.verifyCodeTF];
    [self addSubview:searchBackBtn];
}

-(void)clickSendCode:(AWHGHALLButton *)sender
{
    AWLog(@"verifycode click");
    NSString *phoneNO = self.phoneNumTF.text;
    
    if (![AWConfig regularPhoneNO:phoneNO]) {
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
    
    if (_isWechatBind) {
        [AWHTTPRequest AWWeixinBindPhoneSendCaptchaRequestWithphoneNO:phoneNO ifSuccess:^(id  _Nonnull response) {
            if ([response[@"code"] intValue]==200) {
                [AWTools makeToastWithText:@"验证码已发送"];
            }
        } failure:^(NSError * _Nonnull error) {
            //
        }];
        return;
    }
    
    [AWHTTPRequest AWBindSendCaptchaRequestWithphoneNO:phoneNO ifSuccess:^(id  _Nonnull response) {
        AWLog(@"response===%@",response);
        if ([response[@"code"] intValue]==200) {
            [AWTools makeToastWithText:@"验证码已发送"];
        }
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
    }];
    
}

-(void)clickBindPhone
{
    NSString *phoneNO = self.phoneNumTF.text;
    NSString *code = self.verifyCodeTF.text;
    if (![AWConfig regularPhoneNO:phoneNO]) {
        [AWTools makeToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (!code) {
        return;
    }
    NSString *wx = [AWGlobalDataManage shareinstance].wx;
    [AWHTTPRequest AWWeinXInBindPhoneNORequestWithPhoneNO:phoneNO captch:code wx:wx ifSuccess:^(id  _Nonnull response) {
        if ([response[@"code"] intValue] != 200) {
            NSString *msg = response[@"msg"];
            [AWTools makeToastWithText:msg];
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
    
//    NSLog(@"current out response==%@",[AWGlobalDataManage shareinstance].wechatResponse);
//    [AWHTTPRequest AWBindPhoneNORequestWithPhoneNO:phoneNO captch:code ifSuccess:^(id  _Nonnull response) {
//        if (_isWechatBind) {
//            NSLog(@"current response==%@",[AWGlobalDataManage shareinstance].wechatResponse);
//            [AWHttpResult loginResultWithUserinfo:[AWGlobalDataManage shareinstance].wechatResponse type:4];
//        }
//        if ([response[@"code"] intValue]==200) {
//            [AWTools makeToastWithText:@"绑定手机成功"];
//        }
//    } failure:^(NSError * _Nonnull error) {
//        //
//    }];
    
}

@end
