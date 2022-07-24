//
//  AWFacebookReport.m
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import "AWFacebookReport.h"

@implementation AWFacebookReport

//FBSDKAppEventNameCompletedRegistration

//启动
+(void)startup
{
    [FBSDKAppEvents activateApp];
}
//注册
+(void)reg
{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration parameters:@{}];
}
//登录
+(void)login
{
    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration parameters:@{}];
}
//支付界面
+(void)charge_page
{
    
}
//支付完成
+(void)charge_ok:(NSDictionary *)paramter
{
    
    [FBSDKAppEvents logEvent:FBSDKAppEventNamePurchased parameters:paramter];
}

+(void)facebook_reportEvent:(NSString *)eventName andParamters:(NSDictionary *)params
{
//    FBSDKSettings set
    [FBSDKAppEvents logEvent:eventName parameters:params];
}
@end
