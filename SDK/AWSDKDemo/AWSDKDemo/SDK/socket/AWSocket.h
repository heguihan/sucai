//
//  AWSocket.h
//  AWSDKDemo
//
//  Created by admin on 2021/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSocket : NSObject
+(instancetype)shareInstance;
-(void)connectWithHost:(NSString *)host andport:(int)port;
-(void)sendDataWithMsg:(NSString *)msg type:(short)type msgID:(uint)msgid iszip:(BOOL)isZip isfirst:(BOOL)isfirst;
-(void)heartBeat;
-(void)disConnect;
-(void)resendData;
@end

NS_ASSUME_NONNULL_END
