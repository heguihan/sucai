//
//  AWHTTPRequest.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/5.
//

#import "AWHTTPRequest.h"
#import "HGHNetWork.h"
#import "urls.h"
#import "AWConfig.h"
#import "AWDeviceInfo.h"
#import "AWHttpResult.h"

@implementation AWHTTPRequest
//测试接口

static NSString *_is_simulator =@"false";

+(void)testRequest
{
    NSString *appID = [AWConfig CurrentAppID];
    NSString *timeStr = [AWTools getCurrentTimeString];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"time":timeStr,
                                @"is_simulator":_is_simulator,
                                @"channel_id":[AWConfig CUrrentCHannelID]
    };
    AWLog(@"dict pra=%@",dictionary);
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAININIT,URLINIT];
    [HGHNetWork POSTNEW:finalUrl paramString:dictionary ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);

    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
      
    }];
}

// MARK  初始化
+(void)AWinitRequestifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *appID = [AWConfig CurrentAppID];
    NSString *timeStr = [AWTools getCurrentTimeString];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"time":timeStr,
                                @"is_simulator":_is_simulator,
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"sdk_version":[AWConfig SDKversion],
                                @"package_name":[AWTools getCurrentBundleID],
                                @"os":@"ios",
                                @"device_id":[AWTools getIdfa]
    };
    AWLog(@"dict pra=%@",dictionary);
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",CONFIGDOMAIN,URLINIT];
    [HGHNetWork POSTNEW:finalUrl paramString:dictionary ifSuccess:^(id  _Nonnull response) {
        AWLog(@"init response=%@",response);
        [AWHttpResult initSuccessWithConfig:response];
        
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        [AWHttpResult initFailed];
        failure(error);
    }];
}

// MARK  登录
+(void)AWLoginRequestWithAccount:(NSString *)account pwd:(NSString *)pwd phoneNO:(NSString *)phoneNO captcha:(NSString *)code loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLLOGIN];
    NSString *appID = [AWConfig CurrentAppID];

    NSString *pastedCode = [AWGlobalDataManage shareinstance].inviteCode;
    NSMutableDictionary *extMutableDict = [NSMutableDictionary dictionary];
    if (pastedCode) {
        [extMutableDict setValue:pastedCode forKey:@"awsdk_share"];
    }
    NSString *extraStr = [AWTools dicttojsonWithdict:[extMutableDict copy]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"imei":[AWTools getIdfa],
                                @"oaid":[AWTools getUUID],
                                @"isp":[AWDeviceInfo getOperator],
                                @"login_type":logintype,
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"network":[AWDeviceInfo getNetconnType],
                                @"os":@"ios",
                                @"package_name":[AWTools getCurrentBundleID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"mac":[AWDeviceInfo macAddress],
                                @"ext":extraStr,
                                @"app_version":app_Version,
                                @"is_simulator":_is_simulator,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];

    if (account && account.length>0) {
        [mutableDict setValue:account forKey:@"account"];
    }
    if (pwd && pwd.length>0) {
        if (pwd.length<32) {
            pwd = [AWTools md5String:pwd];
        }
        [mutableDict setValue:pwd forKey:@"password"];
    }
    if (phoneNO && phoneNO.length>0) {
        [mutableDict setValue:phoneNO forKey:@"phone"];
    }
    if (code && code.length>0) {
        [mutableDict setValue:code forKey:@"captcha"];
    }
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult loginResultWithUserinfo:response type:1];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}


// MARK 海外登录
+(void)AWOUTSEAloginRequest:(NSString *)sessionID loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLOUTSEALOGIN];
    NSString *appID = [AWConfig CurrentAppID];
    NSString *pastedCode = [AWGlobalDataManage shareinstance].inviteCode;
    NSMutableDictionary *extMutableDict = [NSMutableDictionary dictionary];
    if (pastedCode) {
        [extMutableDict setValue:pastedCode forKey:@"awsdk_share"];
    }
    NSString *extraStr = [AWTools dicttojsonWithdict:[extMutableDict copy]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"imei":[AWTools getIdfa],
                                @"oaid":[AWTools getUUID],
                                @"isp":[AWDeviceInfo getOperator],
                                @"login_type":logintype,
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"network":[AWDeviceInfo getNetconnType],
                                @"os":@"ios",
                                @"package_name":[AWTools getCurrentBundleID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"mac":[AWDeviceInfo macAddress],
                                @"ext":extraStr,
                                @"app_version":app_Version,
                                @"is_simulator":_is_simulator,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    if ([logintype isEqualToString:@"LOGIN_PHONE"]) {
        [mutableDict setValue:sessionID forKey:@"captcha"];
    }else{
        [mutableDict setValue:sessionID forKey:@"session_id"];
    }
    
    
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult loginResultWithUserinfo:response type:1];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
    
}


// MARK Apple Login
+(void)AWAppleLoginRequestWithAppleUser:(NSString *)user token:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLLOGINAPPLE];
    NSString *appID = [AWConfig CurrentAppID];

    NSString *pastedCode = [AWGlobalDataManage shareinstance].inviteCode;

//    NSDictionary *extrdict =  @{@"awsdk_share":pastedCode};
    NSDictionary *extrdict =  @{@"user":user};
    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:extrdict];
    if (pastedCode && pastedCode.length>0) {
        [mutabDict setObject:pastedCode forKey:@"awsdk_share"];
    }
    NSString *extraStr = [AWTools dicttojsonWithdict:extrdict];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"imei":[AWTools getIdfa],
                                @"oaid":[AWTools getUUID],
                                @"isp":[AWDeviceInfo getOperator],
                                @"login_type":LOGIN_APPLE,
                                @"channel_type":CHANNELTYPE,
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"network":[AWDeviceInfo getNetconnType],
                                @"os":@"ios",
                                @"package_name":[AWTools getCurrentBundleID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"mac":[AWDeviceInfo macAddress],
                                @"ext":extraStr,
                                @"app_version":app_Version,
                                @"is_simulator":_is_simulator,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];

    if (token && token.length>0) {
        [mutableDict setValue:token forKey:@"session_id"];
    }
//    if ([AWSDKConfigManager shareinstance].switch_data_is_bind_visitor) {
//        [mutableDict setValue:@"1" forKey:@"bind_visitor"];
//    }

    AWLog(@"apple dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@apple response===%@",TAG_OK_HTTP,response);
        [AWHttpResult wechatloginResultWithUserinfo:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"wechat error==%@",error);
        failure(error);
    }];
}


// MARK  注册
+(void)AWRegistRequestWithAccount:(NSString *)account pwd:(NSString *)pwd phoneNO:(NSString *)phoneNO captcha:(NSString *)code loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLREGISTER];
    NSString *appID = [AWConfig CurrentAppID];
    NSString *pastedCode = [AWGlobalDataManage shareinstance].inviteCode;
    NSString *extraStr = @"{}";
    if (pastedCode) {
        NSDictionary *extrdict =  @{@"awsdk_share":pastedCode};
        extraStr = [AWTools dicttojsonWithdict:extrdict];
    }

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"imei":[AWTools getIdfa],
                                @"oaid":[AWTools getUUID],
                                @"isp":[AWDeviceInfo getOperator],
                                @"login_type":logintype,
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"network":[AWDeviceInfo getNetconnType],
                                @"os":@"ios",
                                @"package_name":[AWTools getCurrentBundleID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"mac":[AWDeviceInfo macAddress],
                                @"ext":extraStr,
                                @"app_version":app_Version,
                                @"is_simulator":_is_simulator,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];

    if (account && account.length>0) {
        [mutableDict setValue:account forKey:@"account"];
    }
    if (pwd && pwd.length>0) {
        if (pwd.length<32) {
            pwd = [AWTools md5String:pwd];
        }
        [mutableDict setValue:pwd forKey:@"password"];
    }
    if (phoneNO && phoneNO.length>0) {
        [mutableDict setValue:phoneNO forKey:@"phone"];
    }
    if (code && code.length>0) {
        [mutableDict setValue:code forKey:@"captcha"];
    }
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult loginResultWithUserinfo:response type:2];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  发送验证码（手机登录）
+(void)AWSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLCAPTCHA];
    NSString *appID = [AWConfig CurrentAppID];
    NSDictionary *dictionary= @{@"app_id":appID,
                                @"phone":phoneNO,
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"tpl":@"login",
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  发送验证码（手机绑定）
+(void)AWBindSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLBINDCHAPTER];
//    NSString *appID = [AWConfig CurrentAppID];
    NSDictionary *dictionary= @{
                                @"phone":phoneNO,
                                @"token":[AWConfig getSaveToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  发送验证码（微信手机绑定）
+(void)AWWeixinBindPhoneSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLWEIXINBINDCAPTCHA];
//    NSString *appID = [AWConfig CurrentAppID];
    NSDictionary *dictionary= @{
                                @"phone":phoneNO,
                                @"app_id":[AWConfig CurrentAppID],
                                @"time":[AWTools getCurrentTimeString],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  修改密码
+(void)AWChangePasswordRequestWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd rePwd:(NSString *)repwd ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLCHANGEPWD];
    if (oldPwd && oldPwd.length>0) {
        if (oldPwd.length<32) {
            oldPwd = [AWTools md5String:oldPwd];
        }
    }
    if (newPwd && newPwd.length>0) {
        if (newPwd.length<32) {
            newPwd = [AWTools md5String:newPwd];
        }
    }
    if (repwd && repwd.length>0) {
        if (repwd.length<32) {
            repwd = [AWTools md5String:repwd];
        }
    }
    
    NSDictionary *dictionary= @{@"old_pwd":oldPwd,
                                @"new_pwd":newPwd,
                                @"re_pwd":repwd,
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult changePwdResult:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  绑定微信
+(void)AWBindWechatRequestWithSessionID:(NSString *)sessionId ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLBINDWECHAT];
    NSDictionary *dictionary= @{@"session_id":sessionId,
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion],
                                @"package_name":[AWTools getCurrentBundleID]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  绑定手机
+(void)AWBindPhoneNORequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLBINDPHONE];
    NSDictionary *dictionary= @{@"phone":phoneNo,
                                @"captcha":captcha,
                                @"token":[AWConfig getSaveToken],
                                @"sdk_version":[AWConfig SDKversion],
                                @"channel_id":[AWConfig CUrrentCHannelID]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  微信绑定手机
+(void)AWWeinXInBindPhoneNORequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha wx:(NSString *)wx ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLWEIXINBINDPHONE];
    NSDictionary *dictionary= @{@"app_id":[AWConfig CurrentAppID],
                                @"imei":[AWTools getIdfa],
                                @"oaid":[AWTools getUUID],
                                @"isp":[AWDeviceInfo getOperator],
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"network":[AWDeviceInfo getNetconnType],
                                @"os":@"ios",
                                @"package_name":[AWTools getCurrentBundleID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"mac":[AWDeviceInfo macAddress],
                                @"phone":phoneNo,
                                @"captcha":captcha,
                                @"wx":wx,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        if ([response[@"code"]intValue] ==200) {
            [AWHttpResult loginResultWithUserinfo:response type:1];
        }
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}


// MARK  刷新token
+(void)AWRefreshTokenRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLREFRESHTOKEN];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dictionary= @{@"imei":[AWDeviceInfo getIDFA],
                                @"oaid":[AWTools getUUID],
                                @"os":@"ios",
                                @"machine_name":[AWDeviceInfo iphoneName],
                                @"token":[AWConfig CurrentToken],
                                @"mac":[AWDeviceInfo macAddress],
                                @"app_version":app_Version,
                                @"is_simulator":_is_simulator,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult loginResultWithUserinfo:response type:3];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  Logout
+(void)AWLogoutRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    //关闭窗口  悬浮球 adlab 修改登录状态
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLLOGOUT];
    NSDictionary *dictionary= @{
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  滚动消息
+(void)AWBroadcastRequestWithH5:(BOOL)isH5 IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLBROADCAST];
    NSDictionary *dictionary= @{
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    if (isH5) {
        [mutableDict setValue:@"1" forKey:@"self"];
    }
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult broadcastResultWithlist:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  悬浮球gif
+(void)AWFloatingGifRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLTASK];
    NSDictionary *dictionary= @{
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult floatingballgifResult:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  修改别名
+(void)AWAliasAccouintRequestwithAlias:(NSString *)alias IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLALIAS];
    NSDictionary *dictionary= @{@"alias":alias,
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}



// MARK  获取微信APPID
+(void)AWGetWechatAppidRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLWECHATAPPID];
    NSDictionary *dictionary= @{@"app_id":[AWConfig CurrentAppID],
                                @"time":[AWTools getCurrentTimeString],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"package_name":[AWTools getCurrentBundleID],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  SDK下单
+(void)AWGetOrderIDWithOrderInfo:(AWOrderModel *)orderInfo payType:(NSString *)paytype RequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *mutabLeDictext = [NSMutableDictionary dictionary];
    if (orderInfo.ext) {
        mutabLeDictext = [[NSMutableDictionary alloc]initWithDictionary:orderInfo.ext];
    }
    
    // ext里面添加  device_id字段
    [mutabLeDictext setValue:orderInfo.server_id forKey:@"server_id"];
    [mutabLeDictext setValue:orderInfo.role_id forKey:@"role_id"];
    NSString *jsonext = [AWTools convertToJsonData:[mutabLeDictext copy]];
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",ORDERDOMAIN,URLSDKGETORDER];
    NSDictionary *dictionary= @{@"app_id":[AWConfig CurrentAppID],
                                @"channel":paytype,
                                @"time":orderInfo.timeStr,
                                @"amount":[NSString stringWithFormat:@"%f",orderInfo.amount],
                                @"amount_unit":orderInfo.amount_unit,
                                @"ext":jsonext,
                                @"item_id":orderInfo.item_id,
                                @"item_name":orderInfo.item_name,
                                @"notify_url":orderInfo.notify_url,
                                @"out_trade_no":orderInfo.out_trade_no,
                                @"site_uid":[AWUserInfoManager shareinstance].account,
                                @"sdk_version":[AWConfig SDKversion],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"package_name":[AWTools getCurrentBundleID]
    };
    NSLog(@"orderDict.count===%lu",(unsigned long)dictionary.count);
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  广告上报
+(void)AWAdReportWithAdInfo:(AWAdReportModel *)adInfo RequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLADREPORT];
    NSDictionary *dictionary= @{@"ad_id":adInfo.ad_id,
                                @"ad_type":[NSString stringWithFormat:@"%ld",(long)adInfo.ad_type],
                                @"ad_platform":adInfo.ad_platform,
                                @"status":[NSString stringWithFormat:@"%ld",adInfo.status],
                                @"ad_place":adInfo.ad_place,
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    if (adInfo.ad_time) {
        [mutableDict setValue:[NSString stringWithFormat:@"%ld",adInfo.ad_time] forKey:@"ad_time"];
    }
    if (adInfo.action_type) {
        [mutableDict setValue:adInfo.action_type forKey:@"action_type"];
    }
    if (adInfo.ad_data) {
        [mutableDict setValue:adInfo.ad_data forKey:@"ad_data"];
    }
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  检测版本 是否强更  干掉
+(void)AWCheckVersionRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",VERSIONDOMAIN,URLCHECKVERSIOn];
    NSDictionary *dictionary= @{@"app_id":[AWConfig CurrentAppID],
                                @"channel_id":[AWConfig CUrrentCHannelID],
                                @"version_code":[AWTools getCurrentVersion],
                                @"os":@"ios",
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    
    [HGHNetWork POSTNEWVerSion:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult checkVersionResult:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        [AWHttpResult checkVersionResult:@{@"code":@"888"}];
        failure(error);
    }];
}

// MARK  查询订单状态
+(void)AWSearchOrderRequestwithorderID:(NSString *)orderID IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",ORDERDOMAIN,URLORDERCHECK];
    NSDictionary *dictionary= @{@"app_id":[AWConfig CurrentAppID],
                                @"order_no":orderID,
                                @"time":[AWTools getCurrentTimeString],
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}
// MARK  验证内购票据
+(void)AWCheckReceiptRequestwithorderID:(NSString *)orderID deal_no:(NSString *)deal_no andreceipt:(NSString *)receipt IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",ORDERDOMAIN,URLIAPCHECKRECEIPT];
    NSDictionary *dictionary= @{@"receipt":receipt,
                                @"order_no":orderID,
                                @"app_id":[AWConfig CurrentAppID],
                                @"deal_no":deal_no,
                                @"time":[AWTools getCurrentTimeString]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTPOSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  充值榜单开屏页
+(void)AWBannerRankRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLBANNERRANK];
    NSDictionary *dictionary= @{
                                @"token":[AWConfig CurrentToken],
                                @"sdk_version":[AWConfig SDKversion],
                                @"os":@"ios"
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult bannerRankResultWithUserinfo:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

/*
 final HashMap<String, String> map = new HashMap<>();
 map.put("app_id", Constants.APP_ID);
 map.put("site_uid", userInfo.account);
 map.put("amount", amount);
 map.put("time", String.valueOf(System.currentTimeMillis()));
 String paramStr = HttpUtil.getParamStr(Kits.sortMapByKey(map));
 String sign = MD5Util.md5Encode(paramStr + Constants.APP_KEY);
 map.put("sign", sign);
 */
// MARK  检测是否可以支付
+(void)AWCheckCanpayWithAmount:(int)money ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",ORDERDOMAIN,URLCANPAY];
    NSDictionary *dictionary= @{
                                @"app_id":[AWConfig CurrentAppID],
                                @"site_uid":[AWUserInfoManager shareinstance].account,
                                @"amount":[NSString stringWithFormat:@"%d",money],
                                @"time":[AWTools getCurrentTimeString]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        [AWHttpResult bannerRankResultWithUserinfo:response];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}


// MARK  公告
+(void)AWNoticeInfoRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLNOTICEINFO];
    NSString *token = [AWConfig getSaveToken];
    if (!token) {
        token = @"nil";
    }
    NSDictionary *dictionary= @{@"token":token
    };
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
//        [AWHttpResult loginResultWithUserinfo:response type:3];
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  发送验证码（忘记密码）
+(void)AWSendCaptchaForGotPWDRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLFORGOTCAPTCHA];
    NSDictionary *dictionary= @{@"token":[AWConfig getSaveToken],
                                @"time":[AWDeviceInfo getNowTimeTimestamp],
                                @"tpl":@"forgetPwd",
                                @"sdk_version":[AWConfig SDKversion]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    if (phoneNO.length>=11) {
        [mutableDict setValue:phoneNO forKey:@"phone"];
    }
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK  忘记密码设置新密码
+(void)AWForgotPWDRequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha newPWD:(NSString *)newPWD ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLFORTPWD];
    NSDictionary *dictionary= @{
                                @"captcha":captcha,
                                @"token":[AWConfig getSaveToken],
                                @"sdk_version":[AWConfig SDKversion],
                                @"new_pwd":[AWTools md5String:newPWD],
                                @"app_id":[AWConfig CurrentAppID],
                                @"time":[AWDeviceInfo getNowTimeTimestamp]
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    if (phoneNo.length>=11) {
        [mutableDict setValue:phoneNo forKey:@"phone"];
    }
    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}

// MARK adjust上报
+(void)AWADjustReportWithDataWithDict:(NSDictionary *)dict ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@",URLDOMAIN,URLADJUSTREPORT];

    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    AWLog(@"dict pra=%@",[mutableDict copy]);
    [HGHNetWork POSTNEW:finalUrl paramString:[mutableDict copy] ifSuccess:^(id  _Nonnull response) {
        AWLog(@"%@response===%@",TAG_OK_HTTP,response);
        success(response);
    } failure:^(NSError * _Nonnull error) {
        AWLog(@"error");
        failure(error);
    }];
}


#pragma mark 数据上报
#pragma mark 数据上报
+(void)testReport
{
//    [HGHNetWork POSTReportRequestWithURL:@"xxx" param:@{}];
}
@end
