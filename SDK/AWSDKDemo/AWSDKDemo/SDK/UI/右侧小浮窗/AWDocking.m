//
//  AWDocking.m
//  AWSDKDemo
//
//  Created by admin on 2021/10/27.
//

#import "AWDocking.h"
#import "AWDockView.h"


@interface AWDocking()
@property(nonatomic, strong)AWDockView *dockView;

@end

@implementation AWDocking

+(instancetype)shareInstance
{
    static AWDocking *docking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        docking = [[AWDocking alloc]init];
    });
    return docking;
}

+(void)showDockingFloat
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        if ([HGHShowBall shareInstance].isaready&&[HGHShowBall shareInstance].floatBall.hidden == NO) {
//            return;
//        }
//        CGRect frame = CGRectMake(0, 30, 50, 50);
//        if ([AWTools DeviceOrientation] == 3) {
//            frame.origin.y = SCREENHEIGHT/2.0;
//        }
        if ([AWGlobalDataManage shareinstance].isShowingDocking) {
            return;
        }
        
        CGFloat width = 260;
        CGFloat height = 30;
        CGFloat x = SCREENWIDTH - width -30;
        CGFloat y = 30;
        CGRect frame = CGRectMake(x, y, width, height);
        
        [AWDocking shareInstance].dockView = [[AWDockView alloc]initWithFrame:frame];
        [AWDocking shareInstance].dockView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:[AWDocking shareInstance].dockView];
        [AWGlobalDataManage shareinstance].isShowingDocking = YES;
        
    });
}
@end
