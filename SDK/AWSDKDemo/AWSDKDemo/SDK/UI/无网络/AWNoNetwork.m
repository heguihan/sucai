//
//  AWNoNetwork.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/6.
//

#import "AWNoNetwork.h"
#import "QWERReachability.h"
@implementation AWNoNetwork

+(instancetype)factory_noNetWork
{
    AWNoNetwork *nonetWork = [[AWNoNetwork alloc]initWithFrame:CGRectMake(0, AdaptWidth(25), ViewWidth, SmallViewHeight)];
    [nonetWork configUI];
    return nonetWork;
}

-(void)configUI
{
    [self addLogo];
    [self addContent];
}

-(void)addLogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{
    NSArray *titleArr = @[@"网络错误",@"请检查网络连接重试"];
    for (int i=0; i<2; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, 100+(22 * i), ViewWidth-MarginX*2, 20)];
        [self addSubview:lab];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = FONTSIZE(18);
        lab.text = titleArr[i];
    }
    
    AWOrangeBtn *retryNetworkBtn = [AWOrangeBtn factoryBtnWithTitle:@"重试" marginY:170];
    [self addSubview:retryNetworkBtn];
    [retryNetworkBtn addTarget:self action:@selector(clickRetry) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickRetry
{
    if ([self checkNetwork]) {
        [self closeAllView];
    }else{
        [AWTools makeToastWithText:@"网络错误"];
    }
}


-(BOOL)checkNetwork
{
    NSString *remoteHostName = @"www.apple.com";
    QWERReachability *reachability = [QWERReachability reachabilityWithHostName:remoteHostName];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus)
    {
      case NotReachable:   {
        NSLog(@"没有网络！");
          return NO;
        break;
      }
      case ReachableViaWWAN: {
        NSLog(@"4G/3G");
          return YES;
        break;
      }
      case ReachableViaWiFi: {
        NSLog(@"WiFi");
          return YES;
        break;
      }
    }
}

@end
