//
//  AWPwdLogin.m
//  AWSDKDemo
//
//  Created by admin on 2021/3/4.
//

#import "AWPwdLogin.h"

#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@interface AWPwdLogin()
@property(nonatomic, strong)AWTextField *phoneNumTF;
@property(nonatomic, strong)AWTextField *pwdTF;

@end

@implementation AWPwdLogin

+(instancetype)factory_pwdlogin
{
    AWPwdLogin *pwdlogin = [[AWPwdLogin alloc]initWithFrame:CGRectMake(ViewWidth, 0, ViewWidth, ViewHeight-40)];
    [pwdlogin configUI];
    return pwdlogin;
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
    self.pwdTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:31 marginY:AdaptWidth(56)];
    self.pwdTF.secureTextEntry = YES;
    
    self.phoneNumTF.delegate = self;
    self.pwdTF.delegate = self;
    
    self.phoneNumTF.placeholder = @"请输入手机号";
    self.pwdTF.placeholder = @"请输入6-18密码";
    
    AWHGHALLButton *eyesBtn = [AWSmallControl getEyesBtn];
    [self.pwdTF.rightView addSubview:eyesBtn];
    [eyesBtn addTarget:self action:@selector(clickEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    
    AWOrangeBtn *registBtn = [AWOrangeBtn factoryBtnWithTitle:@"登录" marginY:AdaptWidth(116)];
    [registBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.phoneNumTF];
//    [self addSubview:self.verifyCodeTF];
    [self addSubview:self.pwdTF];
    [self addSubview:registBtn];
}

-(void)addProtolLab
{
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(169), TFWidth, 15)];
    [self addSubview:lab];
    BOOL isprivacy = NO;
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:@"登录即阅读并同意《服务协议》"];
    NSArray *linkList = [AWSDKConfigManager shareinstance].link;
    if (linkList.count>0) {
        for (NSDictionary *dic in linkList) {
            if ([dic.allKeys containsObject:@"key"]) {
                if ([dic[@"key"] isEqualToString:@"Privacy"]) {
                    [mutableStr appendString:@"和《隐私协议》"];
                    isprivacy = YES;
                }
            }
        }
    }
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:[mutableStr copy]];
     text.yy_lineSpacing = 5;
     text.yy_font = FONTSIZE(13);
     text.yy_color = BLACKCOLOR;
     [text yy_setTextHighlightRange:NSMakeRange(8, 6) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
         AWLog(@"xxx协议被点击了");
         [AWLoginViewManager showUserProtocol];
     }];
    if (isprivacy) {
        [text yy_setTextHighlightRange:NSMakeRange(15, 6) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
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
    NSString *pwd = self.pwdTF.text;
    if (![AWConfig regularPhoneNO:phoneNO]) {
        [AWTools makeToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (![AWConfig regularPwd:pwd]) {
        return;
    }

    [AWDataReport saveEventWittEvent:@"app_login_phone" properties:@{}];
    [AWHTTPRequest AWLoginRequestWithAccount:@"" pwd:pwd phoneNO:phoneNO captcha:@"" loginType:LOGIN_PHONE_PWD ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
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
        [self.pwdTF becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}


@end
