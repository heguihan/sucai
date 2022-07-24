//
//  AWEventReportManager.m
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import "AWEventReportManager.h"
#import "AWADjustReport.h"
#import "AWFacebookReport.h"
#import "AWFirebaseReport.h"

@implementation AWEventReportManager
+(void)initReportSDK
{
    [[AWADjustReport shareInstance] adjustInit];
//    [AWFirebaseReport firebaseInit];
}

//启动
+(void)startup
{
    NSString *eventName = @"bootstrap";
//    [self reportEventWithoutAdjust:eventName paramter:@{}];
    [AWFirebaseReport startup];
    [AWFacebookReport startup];
    [AWADjustReport adjustreport_startup];
}
//注册
+(void)reg
{
    NSString *eventName = @"reg";
//    [self reportEventWithoutAdjust:eventName paramter:@{}];
    [AWFirebaseReport reg];
    [AWFacebookReport reg];
    [AWADjustReport adjustreport_reg];
}
//登录
+(void)login
{
    NSString *eventName = @"login";
//    [self reportEventWithoutAdjust:eventName paramter:@{}];
    [AWFirebaseReport login];
    [AWFacebookReport login];
    [AWADjustReport adjustreport_login];
}
//支付界面
+(void)charge_page
{
    NSString *eventName = @"charge_page";
//    [self reportEventWithoutAdjust:eventName paramter:@{}];
    [AWFirebaseReport charge_page];
    [AWFacebookReport charge_page];
    [AWADjustReport adjustreport_charge_page];
}
//支付完成
+(void)charge_ok:(NSDictionary *)paramter
{
    NSString *eventName = @"charge_ok";
//    [self reportEventWithoutAdjust:eventName paramter:@{}];
    [AWFirebaseReport charge_ok:paramter];
    [AWFacebookReport charge_ok:paramter];
    [AWADjustReport adjustreport_charge_ok:paramter];
}

+(void)reportEventWithoutAdjust:(NSString *)eventName paramter:(NSDictionary *)paramters
{
    [AWFacebookReport facebook_reportEvent:eventName andParamters:paramters];
//    [AWFirebaseReport firebaseReportWithEvent:eventName andParamters:paramters];
}

+(void)reportEvent:(NSString *)eventName paramters:(NSDictionary *)paramters
{
    [AWADjustReport reportEvent:eventName paramters:paramters];
    [AWFacebookReport facebook_reportEvent:eventName andParamters:paramters];
//    [AWFirebaseReport firebaseReportWithEvent:eventName andParamters:paramters];
}
@end
