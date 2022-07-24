//
//  HGHExchange.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHExchange : NSObject
+(NSString *)exchangeStringWithdict:(NSDictionary *)dict;
+(NSString *)getSignStrWithDict:(NSDictionary *)dict;
+ (nullable NSString *)md5:(nullable NSString *)str;
@end

NS_ASSUME_NONNULL_END
