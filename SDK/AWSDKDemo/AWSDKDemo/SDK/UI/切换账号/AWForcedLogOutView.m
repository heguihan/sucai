//
//  AWForcedLogOutView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/21.
//

#import "AWForcedLogOutView.h"

@implementation AWForcedLogOutView

+(instancetype)factory_forcedLogoutWithMsg:(NSString *)msg
{
    AWForcedLogOutView *forceview = [[AWForcedLogOutView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [forceview configUIWithMsg:msg];
    return forceview;
}

-(void)configUIWithMsg:(NSString *)msg
{
//    [self addlogo];
    [self addContentwithMsg:msg];
}


-(void)addlogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContentwithMsg:(NSString *)msg
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(84), ViewWidth-MarginX*2, AdaptWidth(60))];
//    textView.backgroundColor = [UIColor greenColor];
    [textView setEditable:NO];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
     
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc]initWithString:msg attributes:attributes];
    
    
    CGFloat btnWidth = AdaptWidth(220);
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake((ViewWidth-btnWidth)/2.0, AdaptWidth(161), btnWidth, TFHeight)];
    [confirmBtn setTitle:GUOJIHUA(@"确认") forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:textView];
    [self addSubview:confirmBtn];
}

-(void)clickConfirm
{
//    [AWLoginViewManager switchAccount];
    [self gobackFromSelfView];
    [self changeAccount];
    
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
