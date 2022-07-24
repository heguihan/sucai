//
//  AWDeviceInfo.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWDeviceInfo : NSObject
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

//时间戳
+(NSString *)getNowTimeTimestamp;
//外网ip
+(NSString *)deviceWANIPAdress;
//获取系统版本号
+ (NSString *)SystemVersion;
//获取Mac地址
+ (NSString *)macAddress;
+(BOOL)getFirstInstall;
+(NSString *)systemVersion;
@end

NS_ASSUME_NONNULL_END
