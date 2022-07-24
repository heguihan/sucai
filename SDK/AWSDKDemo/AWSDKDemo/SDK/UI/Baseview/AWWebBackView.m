//
//  AWWebBackView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/4.
//

#import "AWWebBackView.h"
#import "HGHShowBall.h"
#import "AWLoginActiveManager.h"
@implementation AWWebBackView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeWeb];
    
    if ([AWGlobalDataManage shareinstance].isClickActive) {
        if (![AWGlobalDataManage shareinstance].isLastActive) {
            //打开活动
            AWLoginActiveManager *activeManager = [AWLoginActiveManager shareInstance];
            [activeManager showLoginActive];
        }
    }
    
}

+(instancetype)shareInstance
{
    static AWWebBackView *webback = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webback = [AWWebBackView new];
    });
    return webback;
}

-(void)closeWeb
{
    if ([AWViewManager shareInstance].iswebviewShow) {
        if (![AWGlobalDataManage shareinstance].isCallHiddenFloating) {
            [HGHShowBall unHiddenWindow];
        }
        [AWViewManager shareInstance].iswebviewShow = NO;
        [AWGlobalDataManage shareinstance].isShowUserCenter = NO;
        [AWTools removeViews:WEBBACKVIEW];

        
    }
}

@end
