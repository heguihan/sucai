//
//  AWFacebookReport.h
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWFacebookReport : NSObject

//启动
+(void)startup;
//注册
+(void)reg;
//登录
+(void)login;
//支付界面
+(void)charge_page;
//支付完成
+(void)charge_ok:(NSDictionary *)paramter;

+(void)facebook_reportEvent:(NSString *)eventName andParamters:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
