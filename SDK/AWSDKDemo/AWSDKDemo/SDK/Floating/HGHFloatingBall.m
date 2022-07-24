//
//  HGHFloatingBall.m
//  testFunc
//
//  Created by Lucas on 2019/11/29.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHFloatingBall.h"
#import "AWUserCenterView.h"
#import "HGHImage.h"


#define SLEEPALPHA 0.65

@interface HGHFloatingBall()
@property(nonatomic, strong)UIImageView *imageV;
@property(nonatomic, strong)HGHAnimatedImageView *gifimageV;

@end

@implementation HGHFloatingBall
static CGPoint originPoint;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
        
//        self.windowLevel =  UIWindowLevelAlert+1;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gesturPan:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesturTap:)];
        [self addGestureRecognizer:tap];
        self.imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageV];
        [self addgifImageV];
        NSString *imageName = @"AWSDK.bundle/aw_float_icon";
        imageName = [NSString stringWithFormat:@"%@_%@.png",imageName,[AWSDKConfigManager shareinstance].float_ball_type];
//        if ([[AWConfig CurrentAppID] isEqualToString:@"j7g2bpnkg4wdmrxz"]) {
//            imageName = @"AWSDK.bundle/aw_float_icon_ddz.png";
//        }
        if ([AWSDKConfigManager shareinstance].isMiddle) {
            [self.imageV setImage:[AWSDKConfigManager shareinstance].middleImage];
        }else{
            self.imageV.image = [UIImage imageNamed:imageName];
        }
        
        self.isHalfHidden = NO;
        [self creatTimer];
//        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
// aw_float_icon_effects.gif   aw_half_float_left_effects  aw_half_float_right_effects
-(void)addgifImageV
{
//    self.imageV.hidden = YES;
    NSString *imageName = @"AWSDK.bundle/aw_float_icon_effects";
    imageName = [NSString stringWithFormat:@"%@_%@.gif",imageName,[AWSDKConfigManager shareinstance].float_ball_type];
//    if ([[AWConfig CurrentAppID] isEqualToString:@"j7g2bpnkg4wdmrxz"]) {
//        imageName = @"AWSDK.bundle/aw_float_icon_effects_ddz.gif";
//    }
    HGHImage *image = [HGHImage imageNamed:imageName];
    self.gifimageV = [[HGHAnimatedImageView alloc] initWithImage:image];
    self.gifimageV.frame = self.bounds;
    [self addSubview:self.gifimageV];
    self.gifimageV.hidden = YES;
}

-(void)shouGif:(BOOL)isgif
{
    if (!isgif) {
        self.gifimageV.hidden = YES;
        self.imageV.hidden = NO;
    }else{
        self.gifimageV.hidden = NO;
        self.imageV.hidden = YES;
    }
}

-(void)setgifviewWithimage:(NSString *)imageName
{
    HGHImage *image = [HGHImage imageNamed:imageName];
    [self.gifimageV setImage:image];
}

-(void)gesturPan:(UIPanGestureRecognizer *)sender
{
    UIView *testView = sender.view;
    CGRect frame = self.imageV.frame;
    CGFloat scale = [AWSDKConfigManager shareinstance].icon_scale / 100.0;
    frame.size.width = 50 * scale;
    self.imageV.frame = frame;
    self.imageV.alpha = 1.0;
    
    NSString *imageName = @"AWSDK.bundle/aw_float_icon";
    imageName = [NSString stringWithFormat:@"%@_%@.png",imageName,[AWSDKConfigManager shareinstance].float_ball_type];
//    if ([[AWConfig CurrentAppID] isEqualToString:@"j7g2bpnkg4wdmrxz"]) {
//        imageName = @"AWSDK.bundle/aw_float_icon_ddz.png";
//    }
//    self.imageV.image = [UIImage imageNamed:imageName];
    if ([AWSDKConfigManager shareinstance].isMiddle) {
        [self.imageV setImage:[AWSDKConfigManager shareinstance].middleImage];
    }else{
        self.imageV.image = [UIImage imageNamed:imageName];
    }
    self.gifimageV.frame = frame;
    
    NSString *imageNamegif = @"AWSDK.bundle/aw_float_icon_effects";
    imageNamegif = [NSString stringWithFormat:@"%@_%@.gif",imageNamegif,[AWSDKConfigManager shareinstance].float_ball_type];
//    if ([[AWConfig CurrentAppID] isEqualToString:@"j7g2bpnkg4wdmrxz"]) {
//        imageNamegif = @"AWSDK.bundle/aw_float_icon_effects_ddz.gif";
//    }
    [self setgifviewWithimage:imageNamegif];
    CGPoint startPoint;
    //    __block CGPoint originPoint = CGPointZero;
    AWLog(@"xxxxxxxaa");
    if (sender.state == UIGestureRecognizerStateBegan) {
        AWLog(@"start point");
        startPoint = [sender locationInView:sender.view];
//        originPoint = testView.center;
       
        originPoint = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        AWLog(@"startPoint=%f,%f,originPoint=%f,%f",startPoint.x,startPoint.y,originPoint.x,originPoint.y);
    }else if (sender.state == UIGestureRecognizerStateChanged){
        //AWLog(@" state Changed");
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        
        
        
        testView.center = CGPointMake(testView.center.x+deltaX, testView.center.y+deltaY);
        originPoint = [sender locationInView:[UIApplication sharedApplication].keyWindow];
        
        
        //AWLog(@"ChangedOriginPoint%f,%f",originPoint.x,originPoint.y);
    }else if (sender.state == UIGestureRecognizerStateEnded){
        //////AWLog(@"state ended");
        AWLog(@"OutOriginPoint%f,%f",originPoint.x,originPoint.y);
        if (originPoint.x >= [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2) {
            originPoint.x = [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2;
            testView.center = originPoint;
            [self halfHidden];
            return;
        }
        if (originPoint.x-testView.frame.size.width/2<=0) {
            originPoint.x = testView.frame.size.width/2;
            testView.center = originPoint;
            [self halfHidden];
            return;
        }
        if (IphoneX&&[AWTools DeviceOrientation]==2&&[AWTools isInLiuhai:originPoint.y-testView.frame.size.height/2]) {
            if (originPoint.x-testView.frame.size.width/2-30<=0) {
                originPoint.x = testView.frame.size.width/2+30;
                testView.center = originPoint;
                [self halfHidden];
                return;
            }
        }
        if (IphoneX&&[AWTools DeviceOrientation]==1&&[AWTools isInLiuhai:originPoint.y-testView.frame.size.height/2]) {
            if (originPoint.x >= [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2-30) {
                originPoint.x = [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2-30;
                testView.center = originPoint;
                [self halfHidden];
                return;
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            //////AWLog(@"xxxoriginPoint%f,%f",originPoint.x,originPoint.y);
            if (originPoint.x-testView.frame.size.width/2<=0) {
                originPoint.x = testView.frame.size.width/2 +10;
            }
            if (originPoint.y - testView.frame.size.height/2  <=20) {
                originPoint.y = testView.frame.size.height/2 +20;
            }

            if (originPoint.x >= [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2) {
                originPoint.x = [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2;
            }
            if (originPoint.y >=[UIScreen mainScreen].bounds.size.height - testView.frame.size.height/2-11) {
                originPoint.y = [UIScreen mainScreen].bounds.size.height - testView.frame.size.height/2 - 10;
            }
            
            if (originPoint.x>[UIScreen mainScreen].bounds.size.width/2) {
                if (IphoneX&&[AWTools DeviceOrientation]==1&&[AWTools isInLiuhai:originPoint.y-testView.frame.size.height/2])//刘海在右
                {
                    originPoint.x = [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2 -30;//刘海高度34
                }else{
                    originPoint.x = [UIScreen mainScreen].bounds.size.width - testView.frame.size.width/2;
                }
                
            }else{
                if (IphoneX&&[AWTools DeviceOrientation]==2&&[AWTools isInLiuhai:originPoint.y-testView.frame.size.height/2]){
                    originPoint.x = testView.frame.size.width/2+30;
                }else{
                    originPoint.x = testView.frame.size.width/2;
                }
                
            }
            //AWLog(@"originPoint%f,%f",originPoint.x,originPoint.y);
            testView.center = originPoint;
            
        }];
        [self endPoint];
    }
}

-(void)endPoint
{
    //////AWLog(@"endPoint");
    //////AWLog(@"windowxxa center=%f,%f",self.frame.origin.x,self.frame.origin.y);
//    [self halfHidden];
    self.isHalfHidden = NO;
    [self creatTimer];
}

-(void)creatTimer
{
    if (self.timer) {
        [self.timer invalidate];
    }
    CGRect selfFrame = self.frame;
    [AWGlobalDataManage shareinstance].floadtingFrame = selfFrame;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerEvent) userInfo:nil repeats:NO];
}

-(void)timerEvent
{
    if ([AWSDKConfigManager shareinstance].switch_data_is_sleep) {
        if (!self.isHalfHidden) {
            [self halfHidden];
        }
    }
    
    [self.timer invalidate];
}


-(void)halfHidden
{
    CGRect selfFrame = self.frame;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.frame.origin.x>width/2.0) {
        NSString *imageName = @"AWSDK.bundle/aw_half_float_right";
        imageName = [NSString stringWithFormat:@"%@_%@.png",imageName,[AWSDKConfigManager shareinstance].float_ball_type];

        NSString *imageNamegif = @"AWSDK.bundle/aw_half_float_right_effects";
        imageNamegif = [NSString stringWithFormat:@"%@_%@.gif",imageNamegif,[AWSDKConfigManager shareinstance].float_ball_type];
        UIImage *rightImage = [UIImage imageNamed:imageName];
        if ([AWSDKConfigManager shareinstance].isRight) {
            rightImage = [AWSDKConfigManager shareinstance].rightImage;
        }
        [self changeImage:rightImage];
        [self changeGifImageV:imageNamegif];
    }else{
        NSString *imageName = @"AWSDK.bundle/aw_half_float_left";
        imageName = [NSString stringWithFormat:@"%@_%@.png",imageName,[AWSDKConfigManager shareinstance].float_ball_type];

        
        NSString *imageNamegif = @"AWSDK.bundle/aw_half_float_left_effects";
        imageNamegif = [NSString stringWithFormat:@"%@_%@.gif",imageNamegif,[AWSDKConfigManager shareinstance].float_ball_type];

        UIImage *leftImage = [UIImage imageNamed:imageName];
        if ([AWSDKConfigManager shareinstance].isLeft) {
            leftImage = [AWSDKConfigManager shareinstance].leftImage;
        }
        [self changeImage:leftImage];
        [self changeGifImageV:imageNamegif];
    }
    self.isHalfHidden = YES;
}

-(void)changeGifImageV:(NSString *)imageName
{
    CGRect frame = self.imageV.frame;
    CGFloat scale = [AWSDKConfigManager shareinstance].icon_scale / 100.0;
    frame.size.width = 36 * scale;
    
//    CGRect selfFrame = self.frame;
//    if (selfFrame.origin.x>[UIScreen mainScreen].bounds.size.width/2.0) {
//        selfFrame.origin.x += 14;
//        self.frame = selfFrame;
//    }
    self.gifimageV.frame = frame;
    [self setgifviewWithimage:imageName];
}

-(void)changeImage:(UIImage *)image
{
    CGRect frame = self.imageV.frame;
    CGFloat scale = [AWSDKConfigManager shareinstance].icon_scale / 100.0;
    frame.size.width = 36 * scale;

    self.imageV.frame = frame;
    self.imageV.image = image;
    self.imageV.alpha = SLEEPALPHA;
    CGRect selfFrame = self.frame;
    if (selfFrame.origin.x>[UIScreen mainScreen].bounds.size.width/2.0) {
        selfFrame.origin.x += 14*scale;
        self.frame = selfFrame;
    }
    [AWGlobalDataManage shareinstance].floadtingFrame = selfFrame;
    
}


-(void)gesturTap:(UITapGestureRecognizer *)sender
{
//    [self creatTimer];
//    [[AWUserCenterView factory_usercenterview] show];
    [self shouGif:NO];
    [AWDataReport saveEventWittEvent:@"app_click_float_ball" properties:@{}];
    NSString *urlStr = [AWSDKConfigManager shareinstance].menu;
    [AWGlobalDataManage shareinstance].isClickActive = NO;
    [AWLoginViewManager showUsercenterWithUrl:urlStr];
}

+(void)hiddenWindow
{
    [[HGHFloatingBall alloc]init].hidden=YES;
}
@end
