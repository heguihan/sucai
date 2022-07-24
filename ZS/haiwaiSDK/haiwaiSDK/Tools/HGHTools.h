//
//  HGHTools.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define SCREEN_IS_LANDSCAPE   UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define BPDevice_is_ipad  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
@interface HGHTools : NSObject
+(UIViewController *)getCurrentViewcontronller;
+(NSString *)getUUID;

+(NSString *)getTimeString;
+(NSString *)getRandString;

//设备型号
+ (NSString *)iphoneName;
//分辨率
+ (NSString *)getWidthAndHeight;
//mac地址
+ (NSString *)macaddress;
//随机字符串
+(NSString *)getnonce_str;
//邮箱正则
+ (BOOL)checkEmail:(NSString *)email;

+ (void)removeViews:(UIView *)futherView;


@end

NS_ASSUME_NONNULL_END
