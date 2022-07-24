//
//  AWChangePwdView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWChangePwdView.h"

@interface AWChangePwdView()
@property(nonatomic, strong)AWTextField *reNewpwdTF;
@property(nonatomic, strong)AWTextField *oldPwdTF;
@property(nonatomic, strong)AWTextField *newpwdTF;
@property(nonatomic, strong)AWOrangeBtn *changeBtn;

@end


@implementation AWChangePwdView

+(instancetype)factory_changepwdview
{
    AWChangePwdView *changepwd = [[AWChangePwdView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [changepwd configUI];
    return changepwd;
}

-(void)configUI
{
    self.title = GUOJIHUA(@"修改密码");
    self.backBtn.hidden = YES;
    self.oldPwdTF = [AWTextField factoryBtnWithLeftWidth:20 AndRightWidth:31 marginY:AdaptWidth(60)];
    self.newpwdTF = [AWTextField factoryBtnWithLeftWidth:20 AndRightWidth:31 marginY:AdaptWidth(105)];
    self.reNewpwdTF = [AWTextField factoryBtnWithLeftWidth:20 AndRightWidth:31 marginY:AdaptWidth(150)];
    
    self.oldPwdTF.placeholder = GUOJIHUA(@"旧密码");
    self.newpwdTF.placeholder = GUOJIHUA(@"新密码");
    self.reNewpwdTF.placeholder = GUOJIHUA(@"确认密码");
    
    self.oldPwdTF.secureTextEntry = YES;
    self.newpwdTF.secureTextEntry = YES;
    self.reNewpwdTF.secureTextEntry = YES;
    
    
    CGFloat btnWidth = 180;
    AWHGHALLButton *forgotBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(ViewWidth-btnWidth-MarginX, AdaptWidth(200), btnWidth, 17)];
    [forgotBtn setTitle:GUOJIHUA(@"忘记密码") forState:UIControlStateNormal];
    [forgotBtn setTitleColor:RGBA(239, 165, 105, 1) forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = FONTSIZE(17);
    [forgotBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [forgotBtn addTarget:self action:@selector(clickForgot) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeBtn = [AWOrangeBtn factoryBtnWithTitle:GUOJIHUA(@"修改") marginY:223];
    [self.changeBtn addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:self.reNewpwdTF];
    [self addSubview:self.oldPwdTF];
    [self addSubview:self.newpwdTF];
    [self addSubview:forgotBtn];
    [self addSubview:self.changeBtn];
    
    
    AWHGHALLButton *eyesOldBtn = [AWSmallControl getEyesBtn];
    [self.oldPwdTF.rightView addSubview:eyesOldBtn];
    [eyesOldBtn addTarget:self action:@selector(clickOldEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    AWHGHALLButton *eyesNewBtn = [AWSmallControl getEyesBtn];
    [self.newpwdTF.rightView addSubview:eyesNewBtn];
    [eyesNewBtn addTarget:self action:@selector(clickNewEyes:) forControlEvents:UIControlEventTouchUpInside];
    
    AWHGHALLButton *eyesRenewBtn = [AWSmallControl getEyesBtn];
    [self.reNewpwdTF.rightView addSubview:eyesRenewBtn];
    [eyesRenewBtn addTarget:self action:@selector(clickReNewPwd:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickOldEyes:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.oldPwdTF.secureTextEntry = !sender.selected;
}

-(void)clickNewEyes:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.newpwdTF.secureTextEntry = !sender.selected;
}

-(void)clickReNewPwd:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    self.reNewpwdTF.secureTextEntry = !sender.selected;
}

-(void)clickForgot
{
    NSLog(@"忘记密码");
    [AWLoginViewManager showForgotPWD];
}

-(void)clickChange
{
    NSString *oldPwd = self.oldPwdTF.text;
    NSString *newPwd = self.newpwdTF.text;
    NSString *reNewPwd = self.reNewpwdTF.text;
    
    if (![AWConfig regularPwd:oldPwd]) {
        [AWTools makeToastWithText:GUOJIHUA(@"请输入6-8字符")];
        return;
    }
    if (![AWConfig regularPwd:newPwd]) {
        [AWTools makeToastWithText:GUOJIHUA(@"请输入6-8字符")];
        return;
    }
    if (![AWConfig regularPwd:reNewPwd]) {
        [AWTools makeToastWithText:GUOJIHUA(@"请输入6-8字符")];
        return;
    }
    if (![reNewPwd isEqualToString:newPwd]) {
        [AWTools makeToastWithText:GUOJIHUA(@"两次输入的密码不一致，请重新输入")];
        return;
    }
    
    [AWHTTPRequest AWChangePasswordRequestWithOldPwd:oldPwd newPwd:newPwd rePwd:reNewPwd ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
}


@end
