//
//  HGHFlyer.m
//  testSflyer
//
//  Created by Lucas on 2019/5/31.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHFlyer.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>
@implementation HGHFlyer
+(instancetype)shareInstance
{
    static HGHFlyer *flyer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flyer = [[HGHFlyer alloc]init];
    });
    return flyer;
}

+(void)flyerInitWithAppid:(NSString *)appid andAppsFlyerDevKey:(NSString *)devKey
{
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appid;
//    [AppsFlyerTracker sharedTracker].delegate = self;
}

+(void)FlyersReportEvent:(NSString *)event params:(NSDictionary *)params
{
    [[AppsFlyerTracker sharedTracker] trackEvent:event withValues:params];
}

+(NSString *)getIDFA
{
    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+(NSString *)getAppsflyerID
{
    return [AppsFlyerTracker sharedTracker].getAppsFlyerUID;
}

@end
