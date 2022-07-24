//
//  AWAccountRegistview.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWAccountRegistview.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@interface AWAccountRegistview()
@property(nonatomic, strong)AWTextField *accountTF;
@property(nonatomic, strong)AWTextField *pwdTF;
@property(nonatomic, strong)AWHGHALLButton *sendBtn;
@end

@implementation AWAccountRegistview

+(instancetype)factory_registaccount
{
    AWAccountRegistview *accountRegistview = [[AWAccountRegistview alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [accountRegistview configUI];
    return accountRegistview;
}

-(void)configUI
{
    self.title = @"注册账号";
    self.closeBtn.hidden = YES;
    
    [self addcontentView];
    [self addProtolLab];
}

-(void)addcontentView
{
    self.accountTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(78)];
    self.pwdTF = [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH AndRightWidth:31 marginY:AdaptWidth(126)];
    self.accountTF.delegate = self;
    self.pwdTF.delegate = self;
    
    self.accountTF.placeholder = @"请输入账号";
    self.pwdTF.placeholder = @"请输入密码";
    self.pwdTF.secureTextEntry = YES;
    self.pwdTF.secureTextEntry = YES;
    AWHGHALLButton *eyesBtn = [AWSmallControl getEyesBtn];
    [self.pwdTF.rightView addSubview:eyesBtn];
    [eyesBtn addTarget:self action:@selector(clickEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    
    AWOrangeBtn *registkBtn = [AWOrangeBtn factoryBtnWithTitle:@"注册" marginY:AdaptWidth(186)];
    [registkBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.accountTF];
    [self addSubview:self.pwdTF];
    [self addSubview:registkBtn];
}

-(void)addProtolLab
{
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(238), TFWidth, 15)];
    [self addSubview:lab];
    BOOL isprivacy = NO;
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:@"注册即阅读并同意《服务协议》"];
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
     text.yy_font = FONTSIZE(12);
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

-(void)clickEyes:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
}

-(void)clickRegist
{
    NSString *accountSTr = self.accountTF.text;
    NSString *pwdStr = self.pwdTF.text;
    if (![AWConfig regularAccount:accountSTr]) {
        [AWTools makeToastWithText:@"账号长度至少4位"];
        return;
    }
    if (![AWConfig regularPwd:pwdStr]) {
        [AWTools makeToastWithText:@"请输入6-18位的密码"];
        return;
    }
    [AWDataReport saveEventWittEvent:@"app_register_account" properties:@{}];
    [AWHTTPRequest AWRegistRequestWithAccount:accountSTr pwd:pwdStr phoneNO:@"" captcha:@"" loginType:LOGIN_USER ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTF) {
        [self.pwdTF becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
