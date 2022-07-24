//
//  AWFirebaseReport.h
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWFirebaseReport : NSObject
+(void)firebaseInit;

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
+(void)firebaseReportWithEvent:(NSString *)eventName andParamters:(NSDictionary *)paramters;
@end

NS_ASSUME_NONNULL_END
