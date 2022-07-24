//
//  AWGlobalDataManage.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/9.
//

#define FLOATTIME   60.0                    //60  可以关掉
//#define INDULGETIME  10.0
#define BROADCASTTIME  600.0        //600
#define REPORTTIME    3             //数据上报 3秒一次

#define INITTIMER 2        //初始化失败的定时器

#define HEARTBEATSTIME  10
//
//#define FLOATTIME   9999999999999960.0                    //60
//#define INDULGETIME  9999999999999910.0
//#define BROADCASTTIME  999999999999999600.0        //600
//#define REPORTTIME    99999999999999999930.0


#import "AWGlobalDataManage.h"
#import "HGHNetWork.h"
#import "AWLocalFile.h"
#import "AWSocketManager.h"
#import "AWSDKApi.h"

@interface AWGlobalDataManage()
@property(nonatomic, strong)NSTimer *floatingTimer;   //查询悬浮球动效的定时器
@property(nonatomic, strong)NSTimer *IndulgeTime;     //防沉迷事件上报定时器
@property(nonatomic, strong)NSTimer *broadcastTimer;    //滚动消息查询的定时器
@property(nonatomic, strong)NSTimer *realnameAuthTimer;  //实名认证弹窗定时器
@property(nonatomic, strong)NSTimer *reportdataTimer;   //数据上报的定时器
@property(nonatomic, strong)NSTimer *heartbeatsTimer;   //心跳定时器

@property(nonatomic, strong)NSTimer *iintTimerrequest;   //心跳定时器
@end

@implementation AWGlobalDataManage
+(instancetype)shareinstance
{
    static AWGlobalDataManage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AWGlobalDataManage alloc]init];
        manager.isShowedRealnameAuth = NO;
        manager.redNevelopeCount = 0;
        manager.isRedVenelope = NO;
        manager.alreadyLogin = NO;
        manager.isShowedWeb = NO;
        manager.isShowNonetWork = NO;
        manager.isCallHiddenFloating = NO;
        manager.isWeixinLogin = NO;
        manager.isShowingFourceRealName = NO;
        manager.isLastActive = NO;
        manager.isClickActive = NO;
        manager.isNameAuthCP = NO;
        manager.isLogOutCP = NO;
        manager.isShowRedPackNameAuth = NO;
        manager.isShowedSetting = NO;
        manager.isUpdateApiFinished = NO;
        manager.isAuthNameFinished = NO;
        manager.isCPCalledEnterGame = NO;
        manager.updateCalled = NO;
        manager.announceCalled = NO;
        manager.rankBannerCalled = NO;
        manager.isShowingAddiction = NO;
        manager.isShowingNameAuth = NO;
        manager.isShowingUpdate = NO;
        manager.iswaitNameAuth = NO;
        manager.iswaitAddication = NO;
        manager.iswaitannounce = NO;
        manager.iswaitRankBanner = NO;
        manager.ispreCalledAnnounce = NO;
        manager.isNameAuthCallBack = NO;
        manager.isShowingAddiction = NO;
        manager.redpackageUrl = @"";
        manager.isNeedCallSetting = NO;
        manager.isOpneLog = NO;
        manager.isSDKFinished = NO;
        
    });
    return manager;
}

-(void)getjuhua
{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
//    UIViewController *currentVC = [AWTools getCurrentVC];
    UIWindow *window = [AWTools currentWindow];
    [window addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(100, 100, 100, 100);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor redColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor cyanColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = NO;
}

#pragma mark 创建定时器
-(void)createFloatingTimer
{
    return;   //悬浮球红点改gif和 播放领红包语音  先去掉
    if (self.floatingTimer) {
        return;
    }
    self.floatingTimer = [NSTimer scheduledTimerWithTimeInterval:FLOATTIME target:self selector:@selector(timerSearFloating) userInfo:nil repeats:YES];
}

-(void)createIndulgeTimer
{
    if (self.IndulgeTime) {
        return;
    }
//    NSInteger indulge_time = [AWSDKConfigManager shareinstance].name_auth_indulge_interval;
//    if (indulge_time<10) {
//        indulge_time = 10;
//    }
//    self.IndulgeTime = [NSTimer scheduledTimerWithTimeInterval:indulge_time/1.0 target:self selector:@selector(timerIndulge) userInfo:nil repeats:YES];
}

-(void)createBoradCastTimer
{
    if (self.broadcastTimer) {
        return;
    }
    self.broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:BROADCASTTIME target:self selector:@selector(timerBroadCast) userInfo:nil repeats:YES];
}

-(void)createRealnameAuthTimer
{
    if (self.realnameAuthTimer) {
        return;
    }
//    NSInteger silent_time = [AWSDKConfigManager shareinstance].name_auth_silent_time;
//    if (silent_time<=20) {
//        silent_time = 300;
//    }
//    self.realnameAuthTimer = [NSTimer scheduledTimerWithTimeInterval:silent_time/1.0 target:self selector:@selector(timerAuthRealname) userInfo:nil repeats:YES];
}

-(void)createReportDataTimer
{
    if (self.reportdataTimer) {
        return;
    }
    self.reportdataTimer = [NSTimer scheduledTimerWithTimeInterval:REPORTTIME target:self selector:@selector(timerReportData) userInfo:nil repeats:YES];
    
}

-(void)createHeartBeatsTimer
{
    if (self.heartbeatsTimer) {
        return;
    }
    self.heartbeatsTimer = [NSTimer scheduledTimerWithTimeInterval:HEARTBEATSTIME target:self selector:@selector(timerHeartBeats) userInfo:nil repeats:YES];
}

-(void)createInitTimer
{
    if (self.iintTimerrequest) {
        return;
    }
    self.iintTimerrequest = [NSTimer scheduledTimerWithTimeInterval:INITTIMER target:self selector:@selector(timerInitRequest) userInfo:nil repeats:YES];
    
}

#pragma mark 销毁定时器
-(void)destoryFloatingTimer
{
    if (self.floatingTimer) {
        [self.floatingTimer invalidate];
        self.floatingTimer = nil;
    }
}
-(void)destoryIndulgeTimer
{
    if (self.IndulgeTime) {
        [self.IndulgeTime invalidate];
        self.IndulgeTime = nil;
    }
}
-(void)destoryBoradCastTimer
{
    if (self.broadcastTimer) {
        [self.broadcastTimer invalidate];
        self.broadcastTimer = nil;
    }
}
-(void)destoryRealnameAuthTimer
{
    if (self.realnameAuthTimer) {
        [self.realnameAuthTimer invalidate];
        self.realnameAuthTimer = nil;
    }
}

-(void)destoryReportDataTimer
{
    if (self.reportdataTimer) {
        [self.reportdataTimer invalidate];
        self.reportdataTimer = nil;
    }
}

-(void)destoryinitrequestTimer
{
    if (self.iintTimerrequest) {
        [self.iintTimerrequest invalidate];
        self.iintTimerrequest = nil;
    }
}

#pragma mark 定时器事件
//这里的定时任务全部要判断在线状态 错误都不处理
-(void)timerSearFloating
{
    if (![AWUserInfoManager shareinstance].LoginStatus) {
        return;
    }
    AWLog(@"floatingtimer");
    [AWHTTPRequest AWFloatingGifRequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

-(void)timerIndulge
{
    AWLog(@"indugletimer");
}

-(void)timerBroadCast
{
    if (![AWUserInfoManager shareinstance].LoginStatus) {
        return;
    }
    AWLog(@"broadcastTimer");
    [AWHTTPRequest AWBroadcastRequestWithH5:NO IfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

-(void)timerReportData
{
    [self reportLocalDataWithTime:REPORTTIME andPath:LOCALDELAYREPORTINFO];
}

-(void)timerInitRequest
{
    NSLog(@"init timer xxx");
    NSString *appID = [AWConfig CurrentAppID];
    NSString *appKey = [AWConfig CurrentAppKey];
    NSString *gravity = [AWConfig Currentgravity];
    [AWSDKApi initSDK];
}

-(void)reportLocalDataWithTime:(NSInteger)timeinterval andPath:(NSString *)path
{
//    if (timeinterval>1) {
//        if ([AWUserInfoManager shareinstance].LoginStatus && [AWUserInfoManager shareinstance].account.length>0) {
//            AWLog(@"online time xxxxxxxx");
//            NSDictionary *dict = @{@"online_time":[NSString stringWithFormat:@"%ld",(long)timeinterval]};
//            [AWDataReport saveEventWittEvent:@"sys.onlinetime" properties:dict];
//        }
//    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //开始上报   是否加读写锁
        NSError *error;
        NSMutableArray *mutabAll = [AWLocalFile loadLocalCache:path];
        if (!mutabAll) {
            return;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutabAll options:NSJSONWritingFragmentsAllowed error:&error];
        if (!jsonData) {
            AWLog(@"json解析失败");
            NSDictionary *jsonerrorDict = @{@"reportJsonError":mutabAll};
            [AWDataReport saveEventWittEvent:@"sys.exception" properties:jsonerrorDict];
            return;
        }
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        AWLog(@"jsonStr==%@",jsonStr);
//        [AWDataReport removeAllReportData];
        [HGHNetWork POSTReportRequestWithURL:@"" param:jsonStr ifSuccess:^(NSInteger response) {
            if (response == 200) {
//                [AWDataReport reSaveDataWithJsonData:[mutabAll copy]];
                [AWDataReport removeAllReportDataWithPath:path];
            }
        }];
    });
}

-(void)reportLocalRightNow
{
    [self reportLocalDataWithTime:0 andPath:LOCALREPORTINFO];
}


-(void)timerHeartBeats
{
    //心跳
    [AWSocketManager heartbeat];
    NSLog(@"心跳xxx");
}


-(void)showjuhua
{
    [self.activityIndicator startAnimating];
    
}
-(void)dismissjuhua
{
    [self.activityIndicator stopAnimating];
}

@end
