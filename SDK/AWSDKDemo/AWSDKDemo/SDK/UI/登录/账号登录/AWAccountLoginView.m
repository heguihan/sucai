//
//  AWAccountLoginView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWAccountLoginView.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@interface AWAccountLoginView()
@property(nonatomic, strong)AWTextField *accountTF;
@property(nonatomic, strong)AWTextField *pwdTF;
@end

@implementation AWAccountLoginView

+(instancetype)factory_accountLoginview
{
    AWAccountLoginView *accountview = [[AWAccountLoginView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [accountview configUI];
    return accountview;
}

-(void)configUI
{
    self.title = @"账号登录";
    self.closeBtn.hidden = YES;
    
    [self addTFAndBtn];
    [self addBottom];
}

-(void)addTFAndBtn
{
    self.accountTF = [AWTextField factoryBtnWithLeftWidth:25 marginY:AdaptWidth(78)];
    self.pwdTF = [AWTextField factoryBtnWithLeftWidth:25 AndRightWidth:31 marginY:AdaptWidth(126)];
    AWOrangeBtn *loginBtn = [AWOrangeBtn factoryBtnWithTitle:@"登录" marginY:AdaptWidth(186)];
    [loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountTF.placeholder = @"请输入账号";
    self.pwdTF.placeholder = @"请输入密码";
    self.pwdTF.secureTextEntry = YES;
    
    self.accountTF.delegate = self;
    self.pwdTF.delegate = self;
    
    AWHGHALLButton *eyesBtn = [AWSmallControl getEyesBtn];
    [self.pwdTF.rightView addSubview:eyesBtn];
    [eyesBtn addTarget:self action:@selector(clickEye:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.accountTF];
    [self addSubview:self.pwdTF];
    [self addSubview:loginBtn];
}

-(void)addBottom
{
    UILabel *isHaveAccountLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(239), AdaptWidth(60), AdaptWidth(15))];
//    isHaveAccountLab.backgroundColor = [UIColor redColor];
    isHaveAccountLab.text = @"没有账号？";
    isHaveAccountLab.font = FONTSIZE(12);
    isHaveAccountLab.textColor = BLACKCOLOR;
    isHaveAccountLab.textAlignment = NSTextAlignmentLeft;
    
    AWHGHALLButton *registerBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX+AdaptWidth(65), AdaptWidth(239), AdaptWidth(60), AdaptWidth(15))];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = FONTSIZE(12);
    [registerBtn setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegist) forControlEvents:UIControlEventTouchUpInside];
    
    
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(239), TFWidth, 15)];
//    [self addSubview:lab];
    
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: @"没有账号？ 立即注册"];
     text.yy_lineSpacing = 5;
     text.yy_font = FONTSIZE(12);
     text.yy_color = BLACKCOLOR;
    WeakSelf;
     [text yy_setTextHighlightRange:NSMakeRange(6, 4) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

         [weakself clickRegist];

     }];
     lab.numberOfLines = 0;  //设置多行显示
     lab.preferredMaxLayoutWidth = TFWidth; //设置最大的宽度
     lab.attributedText = text;  //设置富文本
    
    
    UILabel *forgotLab = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth-MarginX-AdaptWidth(60), AdaptWidth(239), AdaptWidth(60), AdaptWidth(15))];
    forgotLab.text = @"忘记密码";
    forgotLab.font = FONTSIZE(12);
    forgotLab.textColor = ORANGECOLOR;
    forgotLab.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgotPwd)];
    [forgotLab addGestureRecognizer:tap];
    
    
//    [self addSubview:isHaveAccountLab];
//    [self addSubview:registerBtn];
//    [self addSubview:forgotLab];
}

-(void)clickEye:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
}

-(void)clickRegist
{
    [AWLoginViewManager showAccountRegist];
}

-(void)forgotPwd
{
    //没有了
}

-(void)goback
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONLOGINLIST object:self userInfo:nil];
    [self gobackFromSelfView];
}

-(void)clickLogin
{
    NSString *accountStr = self.accountTF.text;
    NSString *pwdStr = self.pwdTF.text;
    
    if (![AWConfig regularAccount:accountStr]) {
        [AWTools makeToastWithText:@"账号名称至少4位"];
        return;
    }
    
    if (![AWConfig regularPwd:pwdStr]) {
        [AWTools makeToastWithText:@"请输入6-18位的密码"];
        return;
    }
    [AWDataReport saveEventWittEvent:@"app_login_account" properties:@{}];
    [AWHTTPRequest AWLoginRequestWithAccount:accountStr pwd:pwdStr phoneNO:@"" captcha:@"" loginType:LOGIN_USER ifSuccess:^(id  _Nonnull response) {
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
