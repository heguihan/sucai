//
//  AWEventReportManager.h
//  AWSDKDemo
//
//  Created by 何圭韩 on 2022/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWEventReportManager : NSObject
+(void)initReportSDK;
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

//自定义事件上报
+(void)reportEvent:(NSString *)eventName paramters:(NSDictionary *)paramters;
@end

NS_ASSUME_NONNULL_END
