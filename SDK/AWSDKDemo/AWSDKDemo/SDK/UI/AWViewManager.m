//
//  AWViewManager.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWViewManager.h"
#import "AdLabelView.h"
#import "AWSound.h"

@interface AWViewManager()
@property(nonatomic, strong)AdLabelView *AdlunboView;
@property(nonatomic, strong)UIView *redNevelopeView;  //领取红包

@end

@implementation AWViewManager
+(instancetype)shareInstance
{
    static AWViewManager *viewmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewmanager = [AWViewManager new];
    });
    return viewmanager;
}

-(AWMainView *)mainView
{
    if (!_mainView) {
        _mainView = [[AWMainView alloc]initWithFrame:CGRectMake((SCREENWIDTH-ViewWidth)/2.0, (SCREENHEIGHT-ViewHeight)/2.0, ViewWidth+80, ViewHeight+100)];
    }
    _mainView.backgroundColor = [UIColor clearColor];
    [self.wholeView addSubview:_mainView];
    return _mainView;
}

-(AWWholeView *)wholeView
{
    if (!_wholeView) {
        _wholeView = [[AWWholeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _wholeView.backgroundColor = RGBA(0, 0, 0, 0.3);
    }
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:_wholeView];
    return _wholeView;
}

-(AWNotCloseView *)notCloseView
{
    if (!_notCloseView) {
        _notCloseView = [[AWNotCloseView alloc]initWithFrame:CGRectMake((SCREENWIDTH-ViewWidth)/2.0, (SCREENHEIGHT-ViewHeight)/2.0, ViewWidth+80, ViewHeight+100)];
        _notCloseView.backgroundColor = [UIColor clearColor];
    }
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:_notCloseView];
    return _notCloseView;
}

-(UIView *)protoclFutherview
{
    if (!_protoclFutherview) {
        _protoclFutherview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _protoclFutherview.backgroundColor = [UIColor clearColor];
    }
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:_protoclFutherview];
    return _protoclFutherview;
    
}

-(UIView *)protoclAgreeFutherView
{
    if (!_protoclAgreeFutherView) {
        _protoclAgreeFutherView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-ViewWidth)/2.0, (SCREENHEIGHT-ViewHeight)/2.0, ViewWidth, ViewHeight)];
    }
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:_protoclAgreeFutherView];
    return _protoclAgreeFutherView;
}

-(AWWebBackView *)webbackView
{
    if (!_webbackView) {
        _webbackView = [[AWWebBackView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webbackView.backgroundColor = RGBA(0, 0, 0, 0.3);
    }
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:_webbackView];
    return _webbackView;
}

-(UIView *)adView
{
    if (!_adView) {
        CGFloat adViewWidth = AdaptWidth(300);
        CGFloat adViewHeight = 30;

        CGFloat yy = 28;
        if ([AWTools DeviceOrientation] ==3) {
            yy = 70;
        }
        _adView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-adViewWidth)/2.0, yy, adViewWidth, adViewHeight)];
        _adView.layer.cornerRadius = adViewHeight/2.0;
        _adView.layer.masksToBounds = YES;
        _adView.backgroundColor = RGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *tapAd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAd)];
        [_adView addGestureRecognizer:tapAd];
    }
    return _adView;
}

-(UIView *)redNevelopeView
{
    if (!_redNevelopeView) {
        CGFloat adViewWidth = AdaptWidth(300);
        CGFloat adViewHeight = 30;

        CGFloat yy = 28;
        if ([AWTools DeviceOrientation] ==3) {
            yy = 70;
        }
        _redNevelopeView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-adViewWidth)/2.0, yy, adViewWidth, adViewHeight)];
        _redNevelopeView.layer.cornerRadius = adViewHeight/2.0;
        _redNevelopeView.layer.masksToBounds = YES;
        _redNevelopeView.backgroundColor = RGBA(0, 0, 0, 0.5);
        UITapGestureRecognizer *tapAd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAd)];
        [_redNevelopeView addGestureRecognizer:tapAd];
    }
    return _redNevelopeView;
}

//显示领取红包消息
-(void)showredEnvelopeViewWithTitle:(NSDictionary *)title
{
    if (![AWGlobalDataManage shareinstance].isCloseBroadcast) {
        [self CloseBrotcast];
        [AWGlobalDataManage shareinstance].isCloseBroadcast = NO;   //这里不是手动关闭的 所以要设置为NO
    }
    [self playMp3WithName:title[@"type"]];
    [AWGlobalDataManage shareinstance].isRedVenelope = YES;
    CGFloat viewWidth = AdaptWidth(300);
    CGFloat adlabWidth = AdaptWidth(230);
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((viewWidth-adlabWidth)/2.0, 5, adlabWidth, 20)];
    lab.tag = 789;
    lab.font = FONTSIZE(12);
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = title[@"msg"];
    AWHGHALLButton *xxbtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(viewWidth-28, 5, 20, 20)];
    xxbtn.tag = 790;
    [xxbtn setImage:[UIImage imageNamed:@"AWSDK.bundle/deleteAd.png"] forState:UIControlStateNormal];
    for (UIView *subview in self.redNevelopeView.subviews) {
        if (subview.tag == 789 || subview.tag == 790) {
            [subview removeFromSuperview];
        }
    }
    
    [self.redNevelopeView addSubview:lab];
    [self.redNevelopeView addSubview:xxbtn];
    [xxbtn addTarget:self action:@selector(clickCloseRedNevelope) forControlEvents:UIControlEventTouchUpInside];
    [[AWTools currentWindow] addSubview:self.redNevelopeView];
}

-(void)playMp3WithName:(NSString *)name
{
    NSDictionary *dict = @{@"level":@"aw_level_hint",
                           @"charge":@"aw_pay_hint",
                           @"rank":@"aw_rank_hint",
                           @"ad":@"aw_ad_hint",
                           @"complex":@"aw_high_hint"
    };
    NSString *mp3Name = [dict objectForKey:name];
    [[AWSound sharedInstance] playWithName:mp3Name];
}

// 轮播广告
-(void)showAdLabWithArr:(NSArray *)titleArr
{
    
    int closeCount = [AWConfig getBrocastCloseCount];
    if (closeCount>3) {
        return;
    }
    CGFloat viewWidth = AdaptWidth(300);
    CGFloat adlabWidth = AdaptWidth(230);
    
    if (self.AdlunboView) {
        //改变滚动消息的数据
        NSMutableArray *mutablearr = [[NSMutableArray alloc]initWithArray:titleArr];
        [self.AdlunboView updateDataWithArr:mutablearr];
        return;
    }
    AdLabelView *AdlunboView = [[AdLabelView alloc]initWithFrame:CGRectMake((viewWidth-adlabWidth)/2.0, 5, adlabWidth, 20) andTitleArr:titleArr];
    self.AdlunboView = AdlunboView;
    AWHGHALLButton *xxbtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(viewWidth-28, 5, 20, 20)];
    [xxbtn setImage:[UIImage imageNamed:@"AWSDK.bundle/deleteAd.png"] forState:UIControlStateNormal];
    
    [self.adView addSubview:AdlunboView];
    [self.adView addSubview:xxbtn];
    [xxbtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [[AWTools currentWindow] addSubview:self.adView];
}

-(void)clickCloseRedNevelope
{
    NSLog(@"close rednevelope");
    [AWTools removeViews:self.redNevelopeView];
    [AWDataReport saveEventWittEvent:@"app_close_roll_msg" properties:@{}];
    [AWGlobalDataManage shareinstance].isRedVenelope = NO;
//    if (![AWGlobalDataManage shareinstance].isCloseBroadcast) {
//        <#statements#>
//    }
}

-(void)clickClose
{
    //开始计数 一个设备上的同一个应用关闭三次以后就不显示了
    [AWConfig saveBrocastCloseCount];
    
    [AWGlobalDataManage shareinstance].isCloseBroadcast = YES;
    [self CloseBrotcast];
}

-(void)CloseBrotcast
{
    [self.AdlunboView destroyTimer];
    [AWTools removeViews:self.adView];
    self.AdlunboView = nil;
    
    [AWDataReport saveEventWittEvent:@"app_close_roll_msg" properties:@{}];
    
}

-(void)tapAd
{
    //事件上报 和打开web页
    
    [AWDataReport saveEventWittEvent:@"app_click_roll_msg" properties:@{}];
//    [AWLoginViewManager showUsercenter];
    NSString *urlStr = [AWSDKConfigManager shareinstance].menu;
    [AWLoginViewManager showUsercenterWithUrl:urlStr];
}


@end
