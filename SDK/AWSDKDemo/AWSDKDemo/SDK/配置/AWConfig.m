//
//  AWConfig.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWConfig.h"
#import "AWLocalFile.h"

@implementation AWConfig
+(instancetype)shareInstance
{
    static AWConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [AWConfig new];
    });
    return config;
}
static BOOL _isRequested = NO;
//配置请求
+(void)configRequest
{
//    return;
    if (_isRequested) {
        return;
    }
    [ProgressHUD show:GUOJIHUA(@"加载中")];
    [AWHTTPRequest AWinitRequestifSuccess:^(id  _Nonnull response) {
        //
        if ([response[@"code"] intValue]==200) {
            _isRequested = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

static BOOL AWLogEnable = YES;
static BOOL SDKTEST = NO;
static NSString *_appID;
static NSString *_appKey;
static NSString *_gravity;
static NSString *_channelID;
//测试SDK
+(void)setSDKTEST:(BOOL)test
{
    SDKTEST = test;
}

+(void)setCurrentAppID:(NSString *)appID
{
    _appID = appID;
}
+(void)setCurrentAppKey:(NSString *)appKey
{
    _appKey = appKey;
}
+(void)setCurrentGravity:(NSString *)gravity
{
    _gravity = gravity;
}
+(void)setCurrentChannelID:(NSString *)channelID
{
    _channelID = channelID;
}

//日志输出
+(BOOL)getDebugLog
{
    BOOL isOpenLog = [AWGlobalDataManage shareinstance].isOpneLog;
    return YES;
    return isOpenLog;
}
+(void)setDebugLog:(BOOL)debug
{
    AWLogEnable = NO;
}

+(NSString *)CurrentAppID
{
    if (SDKTEST) {
        return _appID;
    }
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"AWSDKConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:jsonPath];
    AWLog(@"dict=%@",dict);
    NSString *appid = dict[@"appid"];
    return appid;
}
+(NSString *)CurrentAppKey
{
    if (SDKTEST) {
        return _appKey;
    }
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"AWSDKConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:jsonPath];
    AWLog(@"dict=%@",dict);
    NSString *appkey = dict[@"appkey"];
    return appkey;
}
+(NSString *)CUrrentCHannelID
{
    if (SDKTEST) {
        return _channelID;
    }
    NSString *localChannelID = [self LocalChannelID];
    
    NSString *chan = [AWSDKConfigManager shareinstance].channelID;
    if (!chan || chan.length<1) {
        chan = @"";
    }
    NSString *resultStr = [NSString stringWithFormat:@"%@%@",localChannelID,chan];
    return resultStr;
}

+(NSString *)LocalChannelID
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"AWSDKConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:jsonPath];
    NSString *channelID = dict[@"AWChannelID"];
    return channelID;
}

+(NSString *)CurrentDomain
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"AWSDKConfig" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:jsonPath];
    NSString *domain = dict[@"urlDomain"];
    return domain;
}

+(NSString *)Currentgravity
{
    NSString *gravity = @"bottom";
    return gravity;
}

//微信支付channel
+(NSString *)WeixinPayChannel
{
    return @"766";
}

+(NSString *)SDKversion
{
    return @"1.0.1";
}

+(NSString *)SDKINTVersion
{
    return @"101";
}

#pragma mark regular
+(BOOL)regularAccount:(NSString *)account
{
    if (account && account.length>4) {
        return YES;
    }
    return NO;
}
+(BOOL)regularPhoneNO:(NSString *)phoneNO
{
    if (phoneNO && phoneNO.length > 1) {
        return YES;
    }
    return NO;
}
+(BOOL)regularPwd:(NSString *)pwd
{
    if (pwd && pwd.length>=6 && pwd.length<=18) {
        return YES;
    }
    return NO;
}
+(BOOL)regularIdCardNum:(NSString *)idNum
{
    if (idNum && idNum.length == 18) {
        return YES;
    }
    return NO;
}
+(BOOL)regularRealName:(NSString *)realname
{
    if (realname && realname.length>0) {
        return YES;
    }
    return NO;
}
+(void)saveToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"awsdkToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getSaveToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"awsdkToken"];
    return token;
}

+(NSString *)CurrentToken
{
    
    NSDictionary *userInfo = [AWConfig loadUserinfoFromLocal];
    if ([userInfo.allKeys containsObject:@"token"]) {
        NSString *token = userInfo[@"token"];
        return token;
    }
    
    return @"nil";
}

+(void)saveUserinfoToLoacl:(NSDictionary *)userinfo
{

    
    NSArray *fieldArr = @[@"show_account",
                          @"account",
                          @"pwd",
                          @"token",
                          @"type"
    ];
    for (NSString *fieldstr in fieldArr) {
        if (![userinfo.allKeys containsObject:fieldstr]) {
            [AWTools makeToastWithText:[NSString stringWithFormat:@"缺少%@",fieldstr]];
        }
    }
    
    
    NSString *token = [userinfo objectForKey:@"token"];
    [self saveToken:token];
    NSMutableDictionary *mutabdict = [[NSMutableDictionary alloc]initWithDictionary:userinfo];
    [mutabdict setObject:@1 forKey:LOGINSTATUS];
    [[AWUserInfoManager shareinstance] setUserinfoWithData:[mutabdict copy]];
    [AWLocalFile saveToLocalWithPath:LOCALUSERINFO withData:[mutabdict copy]];
}
+(NSDictionary *)loadUserinfoFromLocal
{
    NSDictionary *userinfo = [AWLocalFile loadLocalCache:LOCALUSERINFO];
    AWUserInfoManager *userManager = [AWUserInfoManager shareinstance];
    [userManager setUserinfoWithData:userinfo];
    return [AWLocalFile loadLocalCache:LOCALUSERINFO];
}
+(void)clearLocalUserinfo
{
    [AWLocalFile removeDocumentDataAtPath:LOCALUSERINFO];
}
+(void)changeLoginSTatus:(NSNumber *)loginstatus
{
    NSMutableDictionary *mutabdict = [[NSMutableDictionary alloc]initWithDictionary:[self loadUserinfoFromLocal]];
    [mutabdict setObject:loginstatus forKey:LOGINSTATUS];
    [AWUserInfoManager shareinstance].LoginStatus = [loginstatus intValue];
    [AWLocalFile saveToLocalWithPath:LOCALUSERINFO withData:[mutabdict copy]];
}
//修改账号的密码
/*
 account = 106031209637;
 alias = "";
 "is_bind_mobile" = 1;
 "is_cert" = 0;
 mobile = "166****4149";
 "new_game_user" = 0;
 "new_game_user_regtime" = 1615279192;
 "new_user" = 0;
 "nick_name" = "";
 pwd = 29c4fb3308252952dd0a3f8ce410f0e5;
 "show_account" = 106031209637;
 token = Nwle8nxzMiDYwMzEyMF8xNjE1Mjc5MTkyX3NkazAwOTU2MDAx;
 type = "LOGIN_VISITOR";
 */


+(void)changePwd:(NSString *)newPwd
{
    NSMutableDictionary *mutabdict = [[NSMutableDictionary alloc]initWithDictionary:[self loadUserinfoFromLocal]];
    [mutabdict setObject:newPwd forKey:@"pwd"];
    [AWUserInfoManager shareinstance].pwd = newPwd;
    [AWLocalFile saveToLocalWithPath:LOCALUSERINFO withData:[mutabdict copy]];
    
    [mutabdict removeObjectForKey:@"loginstatus"];
    [self saveLoginAccount:[mutabdict copy]];
}

#pragma mark 初始化相关配置信息
+(void)saveSDKconfigToLocal:(NSDictionary *)configInfo
{
    [[AWSDKConfigManager shareinstance] setinitDataWithConfigInfo:configInfo];
    [AWLocalFile saveToLocalWithPath:LOCALSDKCONFIGINFO withData:configInfo];
}
+(NSDictionary *)loadSDKConfig
{
    NSDictionary *configInfo = [AWLocalFile loadLocalCache:LOCALSDKCONFIGINFO];
    AWSDKConfigManager *manager = [AWSDKConfigManager shareinstance];
    [manager setinitDataWithConfigInfo:configInfo];
    return configInfo;
}

//登陆过的历史账号
+(void)saveLoginAccount:(NSDictionary *)loginInfo
{
    NSMutableArray *mutabArr = [[NSMutableArray alloc]initWithArray:[self loadLoginAccount]];
    if (mutabArr.count>0) {
        for (int i = 0; i<mutabArr.count; i++) {
            NSDictionary *dict = mutabArr[i];
            if ([dict[@"account"] isEqualToString:loginInfo[@"account"]]) {
                [mutabArr removeObject:dict];
            }
        }
    }

    [mutabArr insertObject:loginInfo atIndex:0];
    while (mutabArr.count>5) {
        [mutabArr removeLastObject];
    }
    [AWLocalFile saveToLocalWithPath:LOCALLOGINACCOUNT withData:[mutabArr copy]];
}
+(NSArray *)loadLoginAccount
{
    return [AWLocalFile loadLocalCache:LOCALLOGINACCOUNT];
}

//SDK调取退出游戏操作
+(void)LogoutWithGame
{
    //弹框顺序重置
    [AWGlobalDataManage shareinstance].isShowingUpdate = NO;
    [AWGlobalDataManage shareinstance].isShowingAddiction = NO;
    [AWGlobalDataManage shareinstance].isShowingNameAuth = NO;
    [AWGlobalDataManage shareinstance].updateCalled = NO;
    [AWGlobalDataManage shareinstance].announceCalled = NO;
    [AWGlobalDataManage shareinstance].rankBannerCalled = NO;
    
    [AWGlobalDataManage shareinstance].iswaitAddication = NO;
    [AWGlobalDataManage shareinstance].iswaitNameAuth = NO;
    [AWGlobalDataManage shareinstance].iswaitannounce = NO;
    [AWGlobalDataManage shareinstance].iswaitRankBanner = NO;
    [AWGlobalDataManage shareinstance].ispreCalledAnnounce = NO;
    [AWGlobalDataManage shareinstance].isNameAuthCallBack = NO;
    [AWGlobalDataManage shareinstance].redpackageUrl = @"";
    [AWGlobalDataManage shareinstance].isShowingFourceRealName = NO;
    
    
    //logout 回调CP 修改登录状态 关闭滚动广播 关闭悬浮球 调出历史账号登录窗口
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awlogoutnotice" object:self userInfo:nil];
    [AWConfig changeLoginSTatus:@0];
    [[AWViewManager shareInstance].webbackView closeWeb];
    [AWLoginViewManager closeFloatingBall];
    [[AWViewManager shareInstance] CloseBrotcast];
    [[AWViewManager shareInstance] clickCloseRedNevelope];
//    [AWGlobalDataManage shareinstance].isCloseBroadcast = NO;
    [AWGlobalDataManage shareinstance].alreadyLogin = NO;
    if ([AWSDKConfigManager shareinstance].switch_data_is_show_login) {
        dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
        dispatch_after(delay_time, dispatch_get_main_queue(), ^{
            [AWTools removeViews:WEBBACKVIEW];
            if ([AWGlobalDataManage shareinstance].isInitFinished) {
                [AWLoginViewManager showHistoryLoginAccount];
            }
            
        });
    }
    
}

//关闭broacast次数统计
+(void)saveBrocastCloseCount
{
//    LOCALBROCASTCLOSECOUNT
    int count = [self getBrocastCloseCount];
    count += 1;
    NSDictionary *brocastCloseCountDict = @{@"brocastCloseCount":@(count)};
    [AWLocalFile saveToLocalWithPath:LOCALBROCASTCLOSECOUNT withData:brocastCloseCountDict];
    
}
+(int)getBrocastCloseCount
{
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALBROCASTCLOSECOUNT];
    if (dict) {
        int resultCount = [[dict objectForKey:@"brocastCloseCount"] intValue];
        return resultCount;
    }
    return 1;
}

//SDK显示版本检测的时间
+(void)saveCheckVersionTime
{
//    NSString *currentTime = [AWTools getCurrentTimeString];
    NSDate *currentDate = [NSDate date];
    NSDictionary *checkversionDict = @{@"checkVersionTime":currentDate};
    [AWLocalFile saveToLocalWithPath:LOCALCHECKVERSIONTIME withData:checkversionDict];
}
+(NSDate *)getLastCheckVersion
{
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALCHECKVERSIONTIME];
    if (dict) {
        NSDate *resultTimeStr = [dict objectForKey:@"checkVersionTime"];
        return resultTimeStr;
    }
    return nil;
}


//获取游戏域名
+(NSString *)getAPI_BASE_URL_GO
{
    return [AWSDKConfigManager shareinstance].API_BASE_URL_GO;
}
+(NSString *)getAPI_BASE_URL_PHP
{
    return [AWSDKConfigManager shareinstance].API_BASE_URL_PHP;
}
+(NSString *)getCHANNEL_REPORT
{
    return [AWSDKConfigManager shareinstance].CHANNEL_REPORT;
}
+(NSString *)getEVENT_URL
{
    return [AWSDKConfigManager shareinstance].EVENT_URL;
}
+(NSString *)getPAY_URL
{
    return [AWSDKConfigManager shareinstance].PAY_URL;
}

@end
