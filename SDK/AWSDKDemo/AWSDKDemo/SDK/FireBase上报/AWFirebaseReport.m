//
//  AWFirebaseReport.m
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import "AWFirebaseReport.h"
#import <FirebaseCore/FIRApp.h>
#import <FirebaseAnalytics/FIRAnalytics.h>

@implementation AWFirebaseReport

+(void)firebaseInit
{
//    [FIRApp configure];
}

//启动
+(void)startup
{
    
}
//注册
+(void)reg
{
    
    [self firebaseReportWithEvent:kFIREventSignUp andParamters:@{}];
}
//登录
+(void)login
{
    
    [self firebaseReportWithEvent:kFIREventLogin andParamters:@{}];
}
//支付界面
+(void)charge_page
{
    
}
//支付完成
+(void)charge_ok:(NSDictionary *)paramter
{
    
    [self firebaseReportWithEvent:kFIREventAddToWishlist andParamters:paramter];
    
}
+(void)firebaseReportWithEvent:(NSString *)eventName andParamters:(NSDictionary *)paramters
{
    [FIRAnalytics logEventWithName:eventName
                        parameters:paramters];
}

@end
