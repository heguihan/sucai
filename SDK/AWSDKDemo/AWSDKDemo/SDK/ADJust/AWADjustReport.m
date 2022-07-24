//
//  AWADjustReport.m
//  AWSDKDemo
//
//  Created by admin on 2022/1/10.
//

#import "AWADjustReport.h"
#import <AdjustSdk/Adjust.h>

@interface AWADjustReport()<AdjustDelegate>

@end

@implementation AWADjustReport

+(instancetype)shareInstance
{
    static AWADjustReport *adjust = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adjust = [[AWADjustReport alloc]init];
    });
    return adjust;
}


-(void)adjustInit
{
//    NSString *appToken = @"qxn34djwjuo0";
    NSString *appToken = [AWSDKConfigManager shareinstance].adjust_AppToken;
    NSString *environment = ADJEnvironmentSandbox;//ADJEnvironmentProduction
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:appToken
                                                environment:environment];
//    adjustConfig.allowSuppressLogLevel = true;setLogLevel:ADJLogLevelVerbose
    [adjustConfig setLogLevel:ADJLogLevelError];
    [adjustConfig setSendInBackground:YES];  //后台跟踪
    adjustConfig.delegate = self;
    [Adjust appDidLaunch:adjustConfig];
    [self getAttribution];
}

-(void)getAttribution
{
    ADJAttribution *attribution = [Adjust attribution];
    NSDictionary *attributionJson = [attribution dictionary];
    NSLog(@"get attributionxx==%@",attributionJson);
    NSLog(@"xxadjust the end");
    
    [self reportAdjustDataToServer:attribution];
}


-(void)reportAdjustDataToServer:(ADJAttribution *)attribution
{
    /*
     adid = 46db774af8e60f3a4a781ef5edfd2e25;
     network = Organic;
     trackerName = Organic;
     trackerToken = qh6r0vy;
     */
//    if (!attribution.campaign) {
//        attribution.campaign = @"";
//    }
    attribution.campaign = attribution.campaign?attribution.campaign:@"";
    attribution.adgroup = attribution.adgroup?attribution.adgroup:@"";
    attribution.creative = attribution.creative?attribution.creative:@"";
    attribution.clickLabel = attribution.clickLabel?attribution.clickLabel:@"";
    attribution.costType = attribution.costType?attribution.costType:@"";
    attribution.costCurrency = attribution.costCurrency?attribution.costCurrency:@"";
//    attribution.costAmount = attribution.costAmount?attribution.costAmount:@"";
    NSLog(@"amount===%@",attribution.costAmount);
    NSString *amountStr = @"";
    if (!attribution.costAmount) {
        NSLog(@"amount == null");
        amountStr = [NSString stringWithFormat:@"%@",attribution.costAmount];
    }

    
    
    NSDictionary *dict = @{@"ad_id":@"",//谷歌的id
                           @"idfa": [AWTools getIdfa],
                           @"device_id":[AWTools getIdfa],
                           @"app_id":[AWConfig CurrentAppID],
                           @"package_name":[AWTools getCurrentBundleID],
                           @"tracker_token":attribution.trackerToken,
                           @"tracker_name":attribution.trackerName,
                           @"network":attribution.network,
                           @"campaign":attribution.campaign,
                           @"ad_group":attribution.adgroup,
                           @"creative":attribution.creative,
                           @"click_label":attribution.clickLabel,
                           @"adid":attribution.adid,
                           @"cost_type":attribution.costType,
                           @"costAmount":amountStr,
                           @"cost_currency":attribution.costCurrency,
                           @"time":[AWTools getCurrentTimeString]
    };
    
    
    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:[attribution dictionary]];
    NSLog(@"muta dict =%@",mutabDict);
    
    
    NSLog(@"report data==%@",dict);
    NSLog(@"the end");
    
    [AWHTTPRequest AWADjustReportWithDataWithDict:dict ifSuccess:^(id  _Nonnull response) {
        if ([response[@"code"] intValue] == 200) {
            NSDictionary *data = response[@"data"];
            NSString *channelID = data[@"channel_id"];
            [AWSDKConfigManager shareinstance].channelID = channelID;
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    /*
     costAmount
     cost_currency
     
     */
    
}


+(void)adjustreport_startup
{
    NSString *eventStr = [AWSDKConfigManager shareinstance].adjust_bootstrap;
    ADJEvent *event = [ADJEvent eventWithEventToken:eventStr];
    [Adjust trackEvent:event];
}

+(void)adjustreport_login
{
    NSString *eventStr = [AWSDKConfigManager shareinstance].adjust_login;
    ADJEvent *event = [ADJEvent eventWithEventToken:eventStr];
    [Adjust trackEvent:event];
    [[self shareInstance] getAttribution];
}

+(void)adjustreport_reg
{
    NSString *eventStr = [AWSDKConfigManager shareinstance].adjust_reg;
    ADJEvent *event = [ADJEvent eventWithEventToken:eventStr];
    [Adjust trackEvent:event];
}

+(void)adjustreport_charge_page
{
    NSString *eventStr = [AWSDKConfigManager shareinstance].adjust_charge_page;
    ADJEvent *event = [ADJEvent eventWithEventToken:eventStr];
    [Adjust trackEvent:event];
}

+(void)adjustreport_charge_ok:(NSDictionary *)params;
{
    NSString *eventStr = [AWSDKConfigManager shareinstance].adjust_charge_ok;
    ADJEvent *event = [ADJEvent eventWithEventToken:eventStr];
    [Adjust trackEvent:event];
}

+(void)reportEvent:(NSString *)eventName paramters:(NSDictionary *)paramters
{
    NSDictionary *configDC = [AWSDKConfigManager shareinstance].adjust_dc;
    NSString *adjustName = [configDC objectForKey:eventName];
    if (!adjustName || adjustName.length<1) {
        return;
    }
    
    ADJEvent *event = [ADJEvent eventWithEventToken:adjustName];
    [event addPartnerParameter:@"amount" value:paramters[@"amount"]];
    [event addPartnerParameter:@"amount_unit" value:paramters[@"amount_unit"]];
    [Adjust trackEvent:event];

}

#pragma mark adjustDelegate
- (void)adjustAttributionChanged:(nullable ADJAttribution *)attribution
{
    NSLog(@"xxadjust attributionChanged");
}

- (void)adjustEventTrackingSucceeded:(nullable ADJEventSuccess *)eventSuccessResponseData
{
    NSLog(@"xxadjust eventTracking successed");
}

- (void)adjustEventTrackingFailed:(nullable ADJEventFailure *)eventFailureResponseData
{
    NSLog(@"xxadjust eventTracking failed");
}

@end
