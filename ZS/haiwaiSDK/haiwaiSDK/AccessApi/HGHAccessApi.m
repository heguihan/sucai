//
//  HGHAccessApi.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/6.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHAccessApi.h"
#import "HGHLogin.h"
#import "HGHRegister.h"
#import "HGHEmailBand.h"
#import "HGHForgotPassword.h"
#import "HGHChangePassword.h"
#import "HGHBindAccount.h"
#import "HGHHttprequest.h"
#import "HGHExchange.h"
#import "HGHTools.h"
#import "HGHLoginAlertview.h"
#import "HGHHttprequest.h"
#import "HGHAlertview.h"
#import "HGHIAPManager.h"
#import "HGHConfig.h"
#import "HGHOrderInfo.h"
#import "HGHOtherMai.h"
#import "HGHFlyer.h"
#import "HGHDeviceReport.h"
@implementation HGHAccessApi
+(instancetype)shareinstance
{
    static HGHAccessApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[HGHAccessApi alloc]init];
    });
    return api;
}



+(void)initSDKWithAppid:(NSString *)appID appsecret:(NSString *)appSecret
{
    [[HGHConfig shareInstance] setAppIDxx:appID];
    [[HGHConfig shareInstance] setSecretxx:appSecret];
    
    [[HGHHttprequest shareinstance] getmaiWayifSuccess:^(id  _Nonnull response) {
        NSLog(@"response=%@",response);
        if ([response[@"code"] intValue] == 20000) {
            NSDictionary *dict = response[@"data"];
            NSNumber *enable = dict[@"enable"];
            [[NSUserDefaults standardUserDefaults] setObject:enable forKey:@"isEnable"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    [HGHDeviceReport HGHreportDeviceInfo:@{@"id":@""} ename:@"sdk_init"];
    
}
+(void)bind:(void(^)(NSString *bindInfo))infoBlock
{
    [HGHAccessApi shareinstance].bindBackBlock = ^(NSString * _Nonnull bindInfo) {
        infoBlock(bindInfo);
        
    };
}

/*
 bindInfo={
 "expires_in" = 10080;
 openId = 201905100000000006886;
 token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJcL2FwaVwvYXV0aFwvbG9naW4iLCJpYXQiOjE1NTc0NzY3MDUsImV4cCI6MTU1NzQ4MDMwNSwibmJmIjoxNTU3NDc2NzA1LCJqdGkiOiJOREl5T0RZME5UY3lNalkwIiwic3ViIjoiNjgiLCJwcnYiOiIyNGEzOTAyNDU5NjE3MmQ5MTk3YTRjYTcyMjM3ZGNjYWFhM2RiMzFlIiwidGltZXN0YW1wIjoxNTU3NDc2NzA1LCJub25jZVN0ciI6IjdTZ0I4bzVyR1J0SEFpTEt5RHpzb0hLNnMzNXlKTmdrIiwiaW1laSI6IjQwNzM3QjBCLUE1OTgtNEI1MC1CN0UyLUNBMkNFNjRFM0UxQyJ9.JFiCbeqIJ7txQqJSABr47mZQG4TUo8U5ZXD4OCKg7Pc";
 "token_type" = bearer;
 userId = 68;
 
 */
+(void)SDKinit
{
    [[HGHHttprequest shareinstance] getLoginWayWithAppID:@"8" channelID:@"20827151" ifSuccess:^(id  _Nonnull response) {
        NSLog(@"responsexxxaaa=%@",response);
        if ([response[@"code"] integerValue]==1) {
            NSDictionary *dict = [response objectForKey:@"data"];
            NSLog(@"loginwaydict=%@",dict);
            NSLog(@"fb=%@,google=%@,guest=%@",dict[@"face_book"],dict[@"google"],dict[@"guest"]);
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"hghhaiwailoginway"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

+(void)login:(void (^)(NSDictionary * _Nonnull))infoBlock
{
    [HGHAccessApi shareinstance].loginBackBlock = ^(NSDictionary * _Nonnull loginInfo) {
        infoBlock(loginInfo);
        NSLog(@"bindInfo=%@",loginInfo);
        
        if ([loginInfo[@"code"] intValue]!=1) {
            NSLog(@"错误");
            [HGHAlertview showAlertViewWithMessage:loginInfo[@"msg"]];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
            
            [[HGHLogin shareinstance] Login];
        }else{
            NSDictionary *userData = loginInfo[@"data"];
            NSString *token = userData[@"token"];
            NSString *userId = userData[@"userId"];
            [[HGHLoginAlertview shareinstance] showLoginmeg:userId];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"accessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"shuID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if ([[loginInfo allKeys] containsObject:@"type"]) {
                [HGHDeviceReport HGHreportDeviceInfo:@{@"id":userId} ename:@"sdk_register_cb"];
            }else{
                [HGHDeviceReport HGHreportDeviceInfo:@{@"id":userId} ename:@"sdk_login_cb"];
            }
            
            
        }
        

    };
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    if (accessToken) {
        //自动登录
        [self refreshToken:accessToken];
        return;
    }
    [[HGHLogin shareinstance]Login];
}
+(void)logout:(void(^)(NSString *result))infoBlock
{
    
//    [HGHAccessApi shareinstance].logoutBackBlock = ^{
//        infoBlock(@"xxxx");
//    };
    NSString *toekn = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    [[HGHHttprequest shareinstance]logOutWithToken:toekn ifSuccess:^(id  _Nonnull response) {
        NSLog(@"response");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shuID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [HGHAccessApi shareinstance].logoutBackBlock();
        infoBlock(@"success");
    } failure:^(NSError * _Nonnull error) {
        infoBlock(@"faile");
        NSLog(@"error=%@",error);
    }];
//    [HGHAccessApi shareinstance].logoutBackBlock = ^{
//        infoBlock();
//    };
}

+(void)logoutCallback:(void(^)(NSString *result))infoBlock
{
        [HGHAccessApi shareinstance].logoutBackBlock = ^{
            infoBlock(@"ss");
        };
}

//@property(nonatomic,strong)NSString *server_id;
//@property(nonatomic,strong)NSString *app_id;
//@property(nonatomic,strong)NSString *product_id;
//@property(nonatomic,strong)NSString *amount;
//@property(nonatomic,strong)NSString *currency;
//@property(nonatomic,strong)NSString *trade_no;
//@property(nonatomic,strong)NSString *subject;
//@property(nonatomic,strong)NSString *body;
+(void)maiWithOrderInfo:(HGHOrderInfo *)orderInfo;
{
    NSNumber *isEnable = [[NSUserDefaults standardUserDefaults] objectForKey:@"isEnable"];
    if ([isEnable boolValue]) {
        [[HGHIAPManager shareinstance] requestIAPWithOrderInfo:orderInfo];
    }else{
        [HGHOtherMai requestWithorderInfo:orderInfo];
    }
}
+(void)reportUserInfo
{
    
}
+(void)refreshToken:(NSString *)token
{
    [[HGHHttprequest shareinstance] refreshToken:token ifSuccess:^(id  _Nonnull response) {
        [HGHAccessApi shareinstance].loginBackBlock(response);
    } failure:^(NSError * _Nonnull error) {
        [[HGHLogin shareinstance]Login];
    }];
}
+(void)initAppsFlyer:(NSString *)appleID appsFlyerKey:(NSString *)devKey
{
    [HGHFlyer flyerInitWithAppid:appleID andAppsFlyerDevKey:devKey];
}

+(void)appsFlyerReportEvent:(NSString *)event andParams:(NSDictionary *)dict
{
    [HGHFlyer FlyersReportEvent:event params:dict];
}

@end
