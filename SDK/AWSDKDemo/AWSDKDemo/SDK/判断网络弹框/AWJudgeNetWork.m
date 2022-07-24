//
//  AWJudgeNetWork.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/6.
//

#import "AWJudgeNetWork.h"
#import "QWERReachability.h"

@interface AWJudgeNetWork()
@property(nonatomic, strong)NSTimer *timer;
@end

@implementation AWJudgeNetWork
+(instancetype)shareInstance
{
    static AWJudgeNetWork *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[AWJudgeNetWork alloc]init];
    });
    return network;
}

-(void)noNetNetWork
{
    if ([AWSDKConfigManager shareinstance].is_no_network) {
        [self createTimer];
    }
    
}
-(void)getNetWork
{
    if ([AWGlobalDataManage shareinstance].isShowNonetWork) {
        [AWGlobalDataManage shareinstance].isShowNonetWork = NO;
        [AWLoginViewManager closeNonetWorkView];
        
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)createTimer
{
    if (self.timer) {
        return;
    }
    NSInteger timeLong = [AWSDKConfigManager shareinstance].arder_no_newwork;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeLong target:self selector:@selector(timerNetWOrk) userInfo:nil repeats:NO];
}

-(void)timerNetWOrk
{
    if ([AWGlobalDataManage shareinstance].isShowNonetWork) {
        return; //已经显示了
    }
    [AWLoginViewManager showNonetworkView];
}



@end
