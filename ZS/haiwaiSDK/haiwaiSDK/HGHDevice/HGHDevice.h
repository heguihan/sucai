//
//  HGHDevice.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/11/28.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHDevice : NSObject
+(NSString *)getIDFA;
//ip地址
//+ (NSString *)getIPAddress;

//+ (NSString*)deviceVersion;
//设备型号
+ (NSString *)iphoneName;
//网络类型
+ (NSString *)getNetconnType;
//分辨率
+ (NSString *)getWidthAndHeight;
//运营商
+(NSString *)getOperator;
//ipv4
+(NSString *)getipv4;
//ipv6
+(NSString *)getIPAddress:(BOOL)preferIPv4;
//时间戳
+(NSString *)getNowTimeTimestamp;
//外网ip
+(NSString *)deviceWANIPAdress;
//获取系统版本号
+ (NSString *)SystemVersion;
//获取Mac地址
+ (NSString *)macAddress;
+(BOOL)getFirstInstall;
@end

NS_ASSUME_NONNULL_END
