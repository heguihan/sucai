//
//  AWADjustReport.h
//  AWSDKDemo
//
//  Created by admin on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWADjustReport : NSObject
+(instancetype)shareInstance;

//初始化
-(void)adjustInit;
//启动
+(void)adjustreport_startup;
//注册
+(void)adjustreport_reg;
//登录
+(void)adjustreport_login;
//支付界面
+(void)adjustreport_charge_page;
//支付完成
+(void)adjustreport_charge_ok:(NSDictionary *)params;
//自定义事件
+(void)reportEvent:(NSString *)eventName paramters:(NSDictionary *)paramters;
@end

NS_ASSUME_NONNULL_END
