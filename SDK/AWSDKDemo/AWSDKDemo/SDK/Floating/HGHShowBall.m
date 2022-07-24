//
//  HGHShowBall.m
//  testFunc
//
//  Created by Lucas on 2019/11/29.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHShowBall.h"

@implementation HGHShowBall
+(instancetype)shareInstance
{
    static HGHShowBall *ball = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ball = [[HGHShowBall alloc]init];
        ball.isaready = NO;
    });
    return ball;
}

+(void)showFloatingball
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([HGHShowBall shareInstance].isaready&&[HGHShowBall shareInstance].floatBall.hidden == NO) {
            return;
        }
        CGFloat scale = [AWSDKConfigManager shareinstance].icon_scale / 100.0;
        CGRect frame = CGRectMake(0, 30, 50*scale, 50*scale);
        if ([AWTools DeviceOrientation] == 3) {
            frame.origin.y = SCREENHEIGHT/2.0;
        }
        
        
        [HGHShowBall shareInstance].floatBall = [[HGHFloatingBall alloc]initWithFrame:frame];
        [HGHShowBall shareInstance].floatBall.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:[HGHShowBall shareInstance].floatBall];
        [HGHShowBall shareInstance].isaready = YES;
        
    });

}

+(void)closeFloatingBall
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HGHShowBall shareInstance].isaready = NO;
        [[HGHShowBall shareInstance].floatBall removeFromSuperview];
    });
}

+(void)isSHowGif:(BOOL)isshowGif
{
//    [[HGHShowBall shareInstance].floatBall shouGif:isshowGif];
}

+(void)hiddenWindow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HGHShowBall shareInstance].floatBall.hidden=YES;
//        [HGHShowBall shareInstance].isaready = NO;
    });
    
}
+(void)unHiddenWindow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HGHShowBall shareInstance].floatBall.hidden=NO;
//        [HGHShowBall shareInstance].isaready = YES;
    });
}
@end
