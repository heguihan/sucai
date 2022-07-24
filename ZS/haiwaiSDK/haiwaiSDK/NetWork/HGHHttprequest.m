//
//  HGHHttprequest.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHHttprequest.h"
#import "HGHNetWork.h"
#import "HGHExchange.h"
#import "HGHConfig.h"
#import "HGHTools.h"
#import "HGHAlertview.h"
#import "HGHLogin.h"
#import "ProgressHUD.h"
@implementation HGHHttprequest
+(instancetype)shareinstance
{
    static HGHHttprequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[HGHHttprequest alloc]init];
    });
    return request;
}

// 用户注册
-(void)registWithUserName:(NSString *)userName password:(NSString *)password device:(NSString *)device captcha:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"username":userName,
                           @"password":password,
                           @"imei":device,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"captcha":captcha,       //验证码
                           @"timestamp":[HGHTools getTimeString]
                           };
//    NSString *resultStr = [HGHExchange exchangeStringWithdict:dict];
    NSString *regist = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_REGISTER];
    [HGHNetWork POSTNEW:regist paramString:dict ifSuccess:^(id  _Nonnull response) {
        //        NSLog(@"register=%@",response);
        [ProgressHUD dismiss];
        NSDictionary *userDict = response;
        NSLog(@"userDict=%@",userDict);
        if ([userDict[@"code"] intValue]!=1) {
            NSLog(@"错误");
        }else{
            NSDictionary *userData = userDict[@"data"];
            NSString *token = userData[@"token"];
            NSString *userId = userData[@"userId"];
//            NSDictionary *userDict = userInfo[@"data"];
//            [[HGHLogin shareinstance].baseView removeFromSuperview];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
//            success(userDict);
        }
        success(userDict);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"regist error");
        failure(error);
    }];
}

//邮箱登录
-(void)loginWithUserName:(NSString *)username andPassword:(NSString *)password andDevice:(NSString *)device type:(NSString *)type tp:(NSString *)tp tpToken:(NSString *)tptoken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_LOGIN];
    //    NSDictionary *dict = @{@"a":@"www",@"b":@"123",@"c":@"333",@"d":nil};
    NSDictionary *dict = @{@"username":username,
                           @"password":password,
                           @"imei":device,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"type":type,
                           @"tp":tp,
                           @"tpToken":tptoken,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *result = [HGHExchange exchangeStringWithdict:dict];
    NSLog(@"result=%@",result);
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSLog(@"response=%@",response);
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"登录失败")];
        }else{
            NSString *token= userInfo[@"token"];
            NSString *userId = userInfo[@"userId"];
            NSDictionary *userDict = userInfo[@"data"];
//            [[HGHLogin shareinstance].baseView removeFromSuperview];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
    
    //    [HGHLogin post]
    
    
}

//游客登录
-(void)touristsWithuuid:(NSString *)imei type:(NSString *)type tp:(NSString *)tp ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"imei":imei,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"type":type,
                           @"tp":tp,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *params = [HGHExchange exchangeStringWithdict:dict];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_LOGIN];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"登录失败")];
        }else{
            NSDictionary *userDict = userInfo[@"data"];
            NSString *expires_in = userDict[@"expires_in"];
            NSString *openID = userDict[@"openID"];
            NSString *token = userDict[@"token"];
            NSString *token_type = userDict[@"token_type"];
            NSString *userId = userDict[@"userId"];
            NSLog(@"expires=%@",expires_in);
//            NSDictionary *userDict = userInfo[@"data"];
//            [[HGHLogin shareinstance].baseView removeFromSuperview];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
//            success(userDict);
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//第三方登录
-(void)thirdLoginWithuuid:(NSString *)imei type:(NSString *)type tp:(NSString *)tp tpToken:(NSString *)tpToken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"imei":imei,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"type":type,
                           @"tp":tp,
                           @"tpToken":tpToken,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *testUrl = [NSString stringWithFormat:@"%@%@",URL_TEST_DOMAIN,URL_LOGIN];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_LOGIN];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"登录失败")];
        }else{
//            NSString *token= userInfo[@"token"];`
//            NSString *userId = userInfo[@"userId"];
            NSDictionary *userDict = userInfo[@"data"];
            NSLog(@"data=%@",userDict);
//            success(userDict);
//            [[HGHLogin shareinstance].baseView removeFromSuperview];
            [HGHTools removeViews:[HGHLogin shareinstance].baseView];
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//获取验证码
-(void)registVerifyCodeWithUserName:(NSString *)username ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"username":username,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_VERIFYCODE];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        success(userInfo);

    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
    
}
//退出登录
-(void)logOutWithToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"token":token};
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_LOGOUT];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            success(userDict);
//            []
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//账号绑定
-(void)bindAccountType:(NSString *)type username:(NSString *)username pwd:(NSString *)pwd tp:(NSString *)tp tpToken:(NSString *)tpToken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"type":type,
                           @"username":username,
                           @"password":pwd,
                           @"tp":tp,
                           @"tpToken":tpToken,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString],
                           @"imei":[HGHTools getUUID]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_BIND];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"绑定账号失败或已绑定")];
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"账号绑定错误")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            success(userDict);
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}
//用户资料
-(void)userInfoWithToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *dict = @{@"token":token};
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_USERPROFILE];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"获取用户信息失败")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            NSString *userId = userDict[@"userId"];
            NSString *username = userDict[@"username"];
//            NSDictionary *userDict = userInfo[@"data"];
            success(userDict);
            
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//验证token
-(void)verifyToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"token":token};
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_CHECKTOKEN];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"验证Token失败")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            success(userDict);
//            NSDictionary *userDict = userInfo[@"data"];
//            NSString *userId = userDict[@"userId"];
//            NSString *username = userDict[@"username"];
            
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//重置密码验证码
-(void)resetPwdWithusername:(NSString *)username ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"username":username,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_RESETPWD];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        success(userInfo);

    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//找回密码
-(void)searchPwdWithusername:(NSString *)username captcha:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"username":username,
                           @"captcha":captcha,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_SEARCHPWD];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        success(userInfo);
//        if ([userInfo[@"code"]intValue]!=1) {
//            NSLog(@"错误=%@",userInfo[@"msg"]);
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"找回密码失败")];
//        }else{
//            NSLog(@"success");
////            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"新密码已发送至邮箱")];
////            NSDictionary *userDict = userInfo[@"data"];
////            success(userDict);
//            //            NSDictionary *userDict = userInfo[@"data"];
//            //            NSString *userId = userDict[@"userId"];
//            //            NSString *username = userDict[@"username"];
//
//        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

//修改密码
-(void)changePwdWithusername:(NSString *)username oldPassword:(NSString *)oldPassword confirmPwd:(NSString *)confirmPwd pwd:(NSString *)pwd ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"username":username,
                           @"oldPassword":oldPassword,
                           @"password":pwd,
                           @"confirmPassword":confirmPwd,
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_CHANGEPWD];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        //
        [ProgressHUD dismiss];
        success(response);

    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}


//刷新token
-(void)refreshToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"token":token};
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_REFRESHTOKEN];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
//            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"刷新tToken失败")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            NSString *token = userDict[@"token"];
            NSString *expire = userDict[@"expire"];
//            NSDictionary *userDict = userInfo[@"data"];
//            success(userDict);
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}
//设备上报
-(void)deviceReportifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *dict = @{@"dpi":[HGHTools getWidthAndHeight],
                           @"device_id":[HGHTools getUUID],
                           @"imei":@"拿不到你个死智障",
                           @"mac":[HGHTools macaddress],
                           @"device":[HGHTools iphoneName],
                           @"platform":@"ios",
                           @"app_id":[HGHConfig shareInstance].appID,
                           @"timestamp":[HGHTools getTimeString]
                           };
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_CHANGEPWD];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        //
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"设备上报失败")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            success(userDict);
            //            NSString *userId = userDict[@"userId"];
            //            NSString *username = userDict[@"username"];
            
        }
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"response");
        failure(error);
    }];
}

-(void)sendReceptWithOrderInfo:(NSDictionary *)orderInfo ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *url = URL_IAP;
    [HGHNetWork POSTNEW:url paramString:orderInfo ifSuccess:^(id  _Nonnull response) {
        success(response);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        failure(error);
    }];
}
//支付方式
-(void)getmaiWayifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *url =@"https://hw.pay.acingame.com/payment/gateway/trade/inAppPay/enable";
    NSString *appID = [HGHConfig shareInstance].appID;
    NSString *platform = @"ios";
    NSString *timestamp = [HGHTools getTimeString];
    NSDictionary *orderInfo = @{@"app_id":appID,
                                @"platform":platform,
                                @"timestamp":timestamp,
                                };
    [HGHNetWork POSTNEW:url paramString:orderInfo ifSuccess:^(id  _Nonnull response) {
        NSLog(@"response=%@",response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"error=%@",error);
        failure(error);
    }];
    
}

-(void)getLoginWayWithAppID:(NSString *)appid channelID:(NSString *)channelID ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    [ProgressHUD show];
    NSDictionary *dict = @{@"channel_id":@"20827151",@"app_id":@"8"};
//    192.168.254.223:8009/api/user/getChannelSwitch?channelId=20827151&appid=8
    NSString *urlStr = @"http://192.168.254.223:8009/api/user/getChannelSwitch";
//    NSString *luyou
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_LOGINWAY];
    [HGHNetWork POSTNEW:url paramString:dict ifSuccess:^(id  _Nonnull response) {
        [ProgressHUD dismiss];
        NSDictionary *userInfo = response;
        if ([userInfo[@"code"]intValue]!=1) {
            NSLog(@"错误=%@",userInfo[@"msg"]);
            //            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"刷新tToken失败")];
        }else{
            NSLog(@"success");
            NSDictionary *userDict = userInfo[@"data"];
            NSString *token = userDict[@"token"];
            NSString *expire = userDict[@"expire"];
            //            NSDictionary *userDict = userInfo[@"data"];
            //            success(userDict);
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        NSLog(@"response");
        failure(error);
    }];
}

@end
