//
//  AWChangeAccountView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWChangeAccountView.h"

@implementation AWChangeAccountView

+(instancetype)factory_changeAccountView
{
    AWChangeAccountView *changeAccountV = [[AWChangeAccountView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [changeAccountV configUI];
    return changeAccountV;
}

-(void)configUI
{
//    [self addlogo];
    [self addContent];
}

-(void)addlogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{
    UILabel *firstRowLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(94), TFWidth, AdaptWidth(17))];
    UILabel *secondRowLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(120), TFWidth, AdaptWidth(17))];
    firstRowLab.textColor = RGBA(71, 71, 71, 1);
    firstRowLab.font = FONTSIZE(16);
    firstRowLab.textAlignment = NSTextAlignmentCenter;
    firstRowLab.text = GUOJIHUA(@"切换账号");
    
    secondRowLab.textColor = RGBA(71, 71, 71, 1);
    secondRowLab.font = FONTSIZE(14);
    secondRowLab.textAlignment = NSTextAlignmentCenter;
    secondRowLab.text = GUOJIHUA(@"退出当前账号并且返回到登录界面");
    
    
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(161), btnWidth, TFHeight)];
    cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [cancelBtn setTitle:GUOJIHUA(@"取消") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = TFHeight/2.0;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(161), btnWidth, TFHeight)];
    [confirmBtn setTitle:GUOJIHUA(@"确认") forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:firstRowLab];
    [self addSubview:secondRowLab];
    [self addSubview:cancelBtn];
    [self addSubview:confirmBtn];
}

-(void)clickCancel
{
    [self closeAllView];
}

-(void)clickConfirm
{    
    [self closeAllView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeAccount];
    });
    
}

-(void)changeAccount
{
//    //logout 回调CP 修改登录状态 关闭滚动广播 关闭悬浮球 调出历史账号登录窗口
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"awlogoutnotice" object:self userInfo:nil];
//    [AWConfig changeLoginSTatus:@0];
//    [[AWViewManager shareInstance].webbackView closeWeb];
//    [AWLoginViewManager closeFloatingBall];
//    [[AWViewManager shareInstance] CloseBrotcast];
//    [[AWViewManager shareInstance] clickCloseRedNevelope];
////    [AWGlobalDataManage shareinstance].isCloseBroadcast = NO;
//    [AWGlobalDataManage shareinstance].alreadyLogin = NO;
//    [AWGlobalDataManage shareinstance].isCallHiddenFloating = NO;
//    [AWLoginViewManager showHistoryLoginAccount];
    
    
    [AWConfig LogoutWithGame];
}


@end
