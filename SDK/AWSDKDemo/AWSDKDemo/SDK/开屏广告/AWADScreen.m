//
//  AWADScreen.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/16.
//

#import "AWADScreen.h"
#import "AWScreenAdManager.h"
@interface AWADScreen()
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)int timeOut;
@end

@implementation AWADScreen

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = 200000;
        [self configUI];
        self.userInteractionEnabled = YES;
        self.timeOut = 6;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAd)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


-(void)configUI
{
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.imageView];
//    self.imageView.image = [UIImage imageNamed:@"test_6.png"];
    self.imageView.userInteractionEnabled = YES;
    CGRect frame = CGRectMake(SCREENWIDTH-80, 15, 80, 30);
    
    self.jumpBtn = [[AWHGHALLButton alloc]initWithFrame:frame];
    [self.jumpBtn setTitle:GUOJIHUA(@"跳过广告") forState:UIControlStateNormal];
    self.jumpBtn.titleLabel.font = FONTSIZE(14);
    [self addSubview:self.jumpBtn];
//    self.jumpBtn.backgroundColor = [UIColor redColor];
    [self createTimer];
    
}

-(void)createTimer
{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAd) userInfo:nil repeats:YES];
}

-(void)clickJump
{
    AWLog(@"click jump");
}

-(void)tapAd
{
    AWLog(@"tapAd");
    if (self.jumpType == 1) {
        //登录充值榜单开屏
        NSString *urlStr =self.jimURL;
        [AWLoginViewManager showUsercenterWithUrl:urlStr];
        [self closeScreen];
        return;
    }
    
    
    [AWDataReport saveEventWittEvent:@"app_open_adv" properties:@{}];
    self.scheme = [NSString stringWithFormat:@"%@://",self.scheme];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.scheme] options:@{} completionHandler:^(BOOL success) {
        if (!success) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.jimURL] options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    //
                }
            }];
        }
    }];
}

-(void)timerAd
{
    AWLog(@"timer adscreen");
    if (self.timeOut<=0) {
        
        [self closeScreen];
        return;
    }
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"%d点击跳过",self.timeOut] forState:UIControlStateNormal];
    self.timeOut -=1;
}

-(void)closeScreen
{
    self.hidden = YES;
    [self destoryTimer];
}

-(void)destoryTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
@end
