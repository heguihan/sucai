//
//  AWTools.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AWTools : NSObject
+ (BOOL)isIPhoneX;
+(UIViewController *)getCurrentVC;
+(NSString *)getCurrentTimeString;
+(NSString *) md5String:(NSString *)str;
+(NSString *)getUUID;
+(void)setIDFA;
+(NSString *)getIdfa;
+(NSString *)getTimezone;
+(NSString*)URLEncodeString:(NSString*)unencodedString;
+ (UIWindow *)currentWindow;
+ (void)removeViews:(UIView *)futherView; //递归remove子视图
/** 渐变色 */
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr;
+(NSInteger)DeviceOrientation;
+(BOOL)isInLiuhai:(CGFloat)y;
+(void)makeToastWithText:(NSString *)text;
+(void)makeToastWithText:(NSString *)text andTime:(CFTimeInterval)time;
//保存截图
+(void)saveFastaccountScreentWithView:(UIView *)view;
//  XXTEA加解密
+ (NSString *) encryptStringToBase64String:(NSString *)data stringKey:(NSString *)key;
+ (NSString *) decryptBase64StringToString:(NSString *)data stringKey:(NSString *)key;
//类型转换  jsonstr转字典
+(NSDictionary *)jsonStrtodictWithStr:(NSString *)jsonStr;
+(NSString *)dicttojsonWithdict:(NSDictionary *)dict;
+(BOOL)isFirstInstall;
//有两个地方要激活上报， 这个判断只能用一次，所以多写一个
+(BOOL)isFirstInstall_socket;
//第一次安装 显示红包
+(BOOL)isFirstInstallShowRebNevelope;
//包体版本
+(NSString *)getCurrentVersion;
//包体bundleID
+(NSString*)getCurrentBundleID;
//dict转nsstring
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//输出日志
+ (void)customLogWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;
//检测当前网络
+(BOOL)checkNetwork;
//打电话
+(void)telWithPhoneNO:(NSString *)phoneNO;
//计算lab的宽度
+(CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
//计算时间间隔是否大于2天
+(BOOL)getTimerIntertwoDays:(NSString *)time;
+(int)getTimerCont:(NSString *)time;

//给个闪退
+(void)leaveGame;
//存当前的时间戳
+(void)saveCurrentTimeWithPath:(NSString *)path;
//取上次的时间戳
+(NSString *)getLastTimeStrWithPath:(NSString *)path;
//判断上次时间距离当前时间是否超过一天
+(BOOL)isOverOnyDayWithLastTime:(NSString *)lastTime;

//存当前应用是否保存过（如：授权，激活等，显示一次的）
+(void)saveFlagWithPath:(NSString *)path;
+(BOOL)getFlagWothPath:(NSString *)path;

//返回一个随机数
+(NSInteger)getRandomNumWithMax:(NSInteger)maxNum;
//指定时间戳到当前时间是否超过 n天
+(BOOL)isOverTimeDay:(NSInteger)dayNum lastTimeStr:(NSString *)lastTimeStr;
//base64转UIimage
+(UIImage*)decodeBase64ToImage:(NSString*)strEncodeData;
//UIimage转base64
+(NSString*)encodeToBase64String:(UIImage*)image;
//读取剪切板里面的内容
+(NSString *)getPastedContent;
@end

NS_ASSUME_NONNULL_END
