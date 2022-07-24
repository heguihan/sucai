//
//  HGHConfig.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/5.
//  Copyright © 2019 Lucas. All rights reserved.
//

//1906043349
//8abbca47b5b85ef68791696e5edf8243

#import "HGHConfig.h"

@implementation HGHConfig
//+(NSString *)getAppID
//{
//    return @"1902183084";
//}
//+(NSString *)getSecret
//{
//    return @"0ead9f831261024a71fbe77c42f33e70";
//}
+(instancetype)shareInstance
{
    static HGHConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[HGHConfig alloc]init];
    });
    return config;
}
-(void)setAppIDxx:(NSString *)appID
{
    self.appID = appID;
}

-(NSString *)getAppID
{
    return self.appID;
}

-(void)setSecretxx:(NSString *)secret
{
    self.secret = secret;
}

-(NSString *)getSecret
{
    return self.secret;
}

+(NSString *)getDMappID
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"haiwai" ofType:@"plist"]];
    return [NSString stringWithFormat:@"%@",dic[@"dm_appID"]];
}
+(NSString *)getDMappKey
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"haiwai" ofType:@"plist"]];
    return [NSString stringWithFormat:@"%@",dic[@"dm_appKey"]];

}

+(NSString *)getCurrentChannelID
{
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"]];
    return @"222222";
}

+(NSString *)getSDKVersion{
    return @"2.0.0";
}
+(BOOL)getFacebookClose
{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"hghhaiwailoginway"];
//    if ([dict[@"face_book"] integerValue]==0) {
//        return YES;
//    }
    return NO;
}
+(BOOL)getGoogleClose
{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"hghhaiwailoginway"];
//    NSLog(@"google dict=%@",dict);
//    if ([dict[@"google"] integerValue]==0) {
//        return YES;
//    }
    return NO;
}
+(BOOL)getGuestClose
{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"hghhaiwailoginway"];
//    if ([dict[@"guest"] integerValue]==0) {
//        return YES;
//    }
    return NO;
}

@end
