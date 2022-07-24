//
//  HGHAccessApi.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/6.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGHOrderInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface HGHAccessApi : NSObject
@property (nonatomic,copy)void(^loginBackBlock)(NSDictionary*loginInfo);
@property (nonatomic,copy)void(^bindBackBlock)(NSString *bindInfo);
@property (nonatomic,copy)void(^logoutBackBlock)(void);
+(void)login:(void(^)(NSDictionary*loginInfo))infoBlock;
+(void)logout:(void(^)(NSString *result))infoBlock;
+(void)logoutCallback:(void(^)(NSString *result))infoBlock;
+(void)bind:(void(^)(NSString *bindInfo))infoBlock;
+(void)maiWithOrderInfo:(HGHOrderInfo *)orderInfo;
+(instancetype)shareinstance;
+(void)reportUserInfo;
+(void)initSDKWithAppid:(NSString *)appID appsecret:(NSString *)appSecret;
+(void)initAppsFlyer:(NSString *)appleID appsFlyerKey:(NSString *)devKey;
+(void)appsFlyerReportEvent:(NSString *)event andParams:(NSDictionary *)dict;
+(void)SDKinit;
@end

NS_ASSUME_NONNULL_END
