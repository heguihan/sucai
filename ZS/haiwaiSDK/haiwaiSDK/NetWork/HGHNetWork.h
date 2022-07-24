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
+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
