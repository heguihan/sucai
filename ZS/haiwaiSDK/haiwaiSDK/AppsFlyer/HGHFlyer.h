//
//  HGHFlyer.h
//  testSflyer
//
//  Created by Lucas on 2019/5/31.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHFlyer : NSObject
+(instancetype)shareInstance;
+(void)flyerInitWithAppid:(NSString *)appid andAppsFlyerDevKey:(NSString *)devKey;
+(void)FlyersReportEvent:(NSString *)event params:(NSDictionary *)params;
+(NSString *)getIDFA;
+(NSString *)getAppsflyerID;
@end

NS_ASSUME_NONNULL_END
