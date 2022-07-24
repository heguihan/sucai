//
//  HGHConfig.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/5.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHConfig : NSObject
@property(nonatomic,strong)NSString *appID;
@property(nonatomic,strong)NSString *secret;
//@property(nonatomic,strong)NSString *dm_appID;
//@property(nonatomic,strong)NSString *dm_appkey;
+(instancetype)shareInstance;
-(NSString *)getAppID;
-(NSString *)getSecret;
-(void)setAppIDxx:(NSString *)appID;
-(void)setSecretxx:(NSString *)secret;

//-(NSString *)dm_appID;
//-(NSString *)dm_appkey;
//-(void)setDm_appID:(NSString *)dm_appID;
//-(void)setDm_appkey:(NSString *)dm_appkey;

+(NSString *)getDMappID;
+(NSString *)getDMappKey;

+(NSString*)getCurrentChannelID;
+(NSString *)getSDKVersion;
+(BOOL)getFacebookClose;
+(BOOL)getGoogleClose;
+(BOOL)getGuestClose;
@end

NS_ASSUME_NONNULL_END
