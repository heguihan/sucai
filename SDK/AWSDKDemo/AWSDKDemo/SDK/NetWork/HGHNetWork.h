//
//  HGHNetWork.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHNetWork : NSObject


+(instancetype)shareInstance;
//+(void)POST:(NSString*)URL paramString:(NSString*)paramString ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// GET请求
+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
// POST请求
+(void)POSTPOSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(void)POSTNEWVerSion:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//数据上报 存本地的日志
+(void)POSTReportRequestWithURL:(NSString *)urlSTr param:(NSString *)jsonStr ifSuccess:(void(^)(NSInteger response))success;
//游戏角色上报
+(void)POSTGameRoleReportRequestWithparam:(NSDictionary *)params;

//头条上报
+(void)POSTToutiaoReportRequest;
@end

NS_ASSUME_NONNULL_END
