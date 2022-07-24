//
//  HGHDMHttp.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/11/28.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHDMHttp : NSObject
+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
