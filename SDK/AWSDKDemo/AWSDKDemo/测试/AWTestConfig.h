//
//  AWTestConfig.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTestConfig : NSObject
@property(nonatomic,strong)NSString *appID;
@property(nonatomic,strong)NSString *channelID;
@property(nonatomic,strong)NSString *appkey;


+(instancetype)shareInstance;
-(void)setdict:(NSDictionary *)dict;

-(void)setCurrentEnv:(int)env;
+(int)getCurrentEnv;
@end

NS_ASSUME_NONNULL_END
