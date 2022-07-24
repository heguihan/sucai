//
//  AWSocketManager.h
//  AWSDKDemo
//
//  Created by admin on 2021/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSocketManager : NSObject
+(void)connectSocketWithHost:(NSString *)host andport:(NSString *)port;
+(void)sendToken;
+(void)sendMsg:(NSString *)msg Adntype:(short)type;
+(void)heartbeat;
+(void)disConnect;

@end

NS_ASSUME_NONNULL_END
