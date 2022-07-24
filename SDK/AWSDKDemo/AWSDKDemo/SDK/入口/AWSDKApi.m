//
//  AWSDKApi.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWSDKApi.h"
#import "AWLoginViewManager.h"
#import "AWMaimaimai.h"
#import "AWDeviceInfo.h"

#import "AWScreenAdManager.h"
#import "HGHNetWork.h"

#import "AWMaiSuccessResult.h"
#import "AWMaiResult.h"
#import "UncaughtExceptionHandler.h"

#import "QWERReachability.h"
#import "AWJudgeNetWork.h"
#import "HGHShowBall.h"
#import "AWSocketManager.h"
#import "AWBindWechat.h"
#import "AWAppleLogin.h"

#import "AWEventReportManager.h"

@interface AWSDKApi()
//@property (nonatomic, strong) QWERReachability *reachability;
@end

@implementation AWSDKApi


+(instancetype)shareInstance
{
    static AWSDKApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [AWSDKApi new];
    });
    return api;
}

static   QWERReachability *_reachability;

//监听网络状态
+(void)reachabilityChanged:(NSNotification *)notification
{
    id curReach = [notification object];
//  NSParameterAssert([curReach isKindOfClass:[QWERReachability class]]);
  [self updateInterfaceWithReachability:curReach];
}

+(void)updateInterfaceWithReachability:(id)reachability
{
    reachability = (QWERReachability *)reachability;
  if (reachability == _reachability)
  {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus)
    {
      case NotReachable:   {
        NSLog(@"没有网络！");
          [[AWJudgeNetWork shareInstance] noNetNetWork];
        break;
      }
      case ReachableViaWWAN: {
        NSLog(@"4G/3G");
          [[AWJudgeNetWork shareInstance] getNetWork];
        break;
      }
      case ReachableViaWiFi: {
        NSLog(@"WiFi");
          [[AWJudgeNetWork shareInstance] getNetWork];
        break;
      }
    }
  }
}

+(void)initSDK
{
    [self initSDKWithAppID:@"" appKey:@"" gravity:@""];
}

+(void)initSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey gravity:(NSString *)gravity
{
    
    [AWTools setIDFA];
    [self getInviteCode]; //从剪切板读取邀请码
//        [ProgressHUD show];
//        [[AWGlobalDataManage shareinstance] showjuhua];
    NSString *remoteHostName = @"www.apple.com";
    _reachability = [QWERReachability reachabilityWithHostName:remoteHostName];
      // 设置网络状态变化时的通知函数
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                           name:@"qwerkNetworkReachabilityChangedNotification" object:nil];
    [_reachability startNotifier];
    
    [AWConfig setCurrentAppID:appID];
    [AWConfig setCurrentAppKey:appKey];
    [AWConfig setCurrentGravity:gravity];
    
    
    InstallUncaughtExceptionHandler();

    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"awlogoutnotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"awloginresult" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"awmairesultnotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"awNameCertresultnotice" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginresult:) name:@"awloginresult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutResult:) name:@"awlogoutnotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maiResult:) name:@"awmairesultnotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameCertResult:) name:@"awNameCertresultnotice" object:nil];
    
    NSDictionary *deviceInfo = @{@"os_ver":[AWDeviceInfo systemVersion],
                                 @"os":@"ios",
                                 @"sim":@"N/A",
                                 @"screen":[AWDeviceInfo getWidthAndHeight],
                                 @"model":[AWDeviceInfo iphoneName],
                                 @"manufacturer":[AWDeviceInfo iphoneName],
                                 @"carrier":[AWDeviceInfo getOperator]
    };
    [AWDataReport saveEventWittEvent:@"sys.startup" properties:deviceInfo];
    if ([AWTools isFirstInstall]) //这里的判断 写在应用里
    {
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AWGlobalDataManage shareinstance] reportLocalDataWithTime:0 andPath:LOCALREPORTINFO];
    });
    [[AWGlobalDataManage shareinstance] createReportDataTimer];
//    [self getConfigRequest];
}

+(void)getConfigRequest
{
    [AWHTTPRequest AWinitRequestifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

//从剪切板读取邀请码
+(void)getInviteCode
{
    dispatch_queue_t subQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(subQueue, ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *pasteStr = pasteboard.string;
        if (pasteStr && [pasteStr hasPrefix:@"awsdk_share"]) {
            NSString *inviteCode = [pasteStr stringByReplacingOccurrencesOfString:@"awsdk_share:" withString:@""];
            NSLog(@"inviteCode=%@",inviteCode);
            [AWGlobalDataManage shareinstance].inviteCode = inviteCode;
        }
    });
}

+(void)login
{
    [AWGlobalDataManage shareinstance].isLoginSignal = YES;
    [AWLoginViewManager loginCheck];
}

//苹果登录
+(void)AWsignInWithApple
{
    [[AWAppleLogin shareInstance] signinWithApple];
}

//快速（游客）登录
+(void)faseLogin
{
    [AWLoginViewManager fastLogin];
}
+(void)logout
{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"awlogoutnotice" object:self userInfo:nil];
//    [AWConfig changeLoginSTatus:@0];
//    [AWLoginViewManager closeFloatingBall];
//    [[AWViewManager shareInstance] CloseBrotcast];
//    [[AWViewManager shareInstance] clickCloseRedNevelope];
////    [AWGlobalDataManage shareinstance].isCloseBroadcast = NO;
//    [AWGlobalDataManage shareinstance].alreadyLogin = NO;
//    [AWGlobalDataManage shareinstance].isCallHiddenFloating = NO; //重置悬浮球调用
//    if ([AWSDKConfigManager shareinstance].switch_data_is_show_login) {
//        NSArray *arr = [AWConfig loadLoginAccount];
//        if (arr.count<1) {
//            return;
//        }
//        [AWLoginViewManager showHistoryLoginAccount];
//    }
   
    if ([AWGlobalDataManage shareinstance].isSDKFinished) {
        [AWConfig LogoutWithGame];
    }}

+(void)switchAccount
{
    [AWLoginViewManager switchAccount];
}

+(void)maimaimaiWithOrderInfo:(AWOrderModel *)orderInfo
{
    [AWMaimaimai AWMaimaimaiWithOrderInfo:orderInfo];
}

+(void)enterGame
{
    [AWGlobalDataManage shareinstance].isCPCalledEnterGame = YES;
    [AWHttpResult beginAnnouncerequest];
}//游戏进入游戏主界面调用（通知到SDK）


+(void)gameRoundReportRoleInfo:(float)round_time extension:(NSDictionary *)ext
{
    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:ext];
    [mutabDict setValue:[NSString stringWithFormat:@"%f",round_time] forKey:@"play_time"];
    [AWDataReport saveEventWittEvent:@"sys.game" properties:[mutabDict copy]];
}
+(void)gameCustonReportevent:(NSString *)event extension:(NSDictionary *)ext
{
    [AWDataReport saveEventWittEvent:event properties:ext];
}

+(void)adreportWithAdinfo:(AWAdReportModel *)adInfo
{
    NSDictionary *dictionary= @{@"ad_id":adInfo.ad_id,
                                @"ad_type":[NSString stringWithFormat:@"%ld",(long)adInfo.ad_type],
                                @"ad_platform":adInfo.ad_platform,
                                @"status":@(adInfo.status),
                                @"ad_place":adInfo.ad_place
    };
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    AWLog(@"dict pra=%@",[mutableDict copy]);
    if (adInfo.ad_time) {
        [mutableDict setValue:@(adInfo.ad_time) forKey:@"ad_time"];
    }
    if (adInfo.action_type) {
        [mutableDict setValue:adInfo.action_type forKey:@"action_type"];
    }
    if (adInfo.ad_data) {
        [mutableDict setValue:adInfo.ad_data forKey:@"ad_data"];
    }
    
    NSString *jsonStr = [AWTools dicttojsonWithdict:[mutableDict copy]];
    AWLog(@"jsonStr==%@",jsonStr);
    int cmd = 203;
    if ([AWSDKConfigManager shareinstance].is_client_ad_report) {
        return;
    }
    [AWSocketManager sendMsg:jsonStr Adntype:cmd];
//    [AWHTTPRequest AWAdReportWithAdInfo:adInfo RequestIfSuccess:^(id  _Nonnull response) {
//        //
//    } failure:^(NSError * _Nonnull error) {
//        //
//    }];
}

+(void)roleInfoReport:(AWRoleInfoModel *)roleInfo
{
//    roleInfo.nickName = [AWGlobalDataManage shareinstance].currentAccount;
//    roleInfo.roleId = [AWGlobalDataManage shareinstance].currentAccount;
    if ([roleInfo.nickName isEqualToString:@""] || roleInfo.nickName==nil) {
        roleInfo.nickName = @"";
    }
    
    NSDictionary *roleInfoDict = @{@"eventtype":roleInfo.reportType,
                                   @"nickname":roleInfo.nickName,
                               @"posttime":@([roleInfo.time intValue]),
                                @"regtime":@([roleInfo.regTime intValue]),
                                   @"level":@(roleInfo.level)
    };
    
    
    NSString *app_id = [AWConfig CurrentAppID];
    NSString *channelID = [AWConfig CUrrentCHannelID];
    NSString *idfa = [AWTools getIdfa];
    NSString *os = @"ios";
    NSString *openid = [AWUserInfoManager shareinstance].account;
    
    if ([idfa isEqualToString:@"00"]) {
        idfa = @"";
    }
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:roleInfoDict];
    /*
     @"nickname":roleInfo.nickName,
     @"level":@(roleInfo.level),
     
     
     @"serverid":roleInfo.serverId,
     @"roleId":roleInfo.roleId,
     ,
     @"ext":[AWTools convertToJsonData:roleInfo.ext]
     */
    
    if (![AWSDKConfigManager shareinstance].is_role_report)
    {
        [mutableDict setValue:roleInfo.roleId forKey:@"roleId"];
        [mutableDict setValue:roleInfo.serverId forKey:@"serverId"];
    }
    
    if (roleInfo.ext) {
        [mutableDict setValue:[AWTools convertToJsonData:roleInfo.ext] forKey:@"ext"];
    }


    [mutableDict setValue:app_id forKey:@"appid"];
    [mutableDict setValue:channelID forKey:@"channelid"];
    [mutableDict setValue:idfa forKey:@"imei"];
    [mutableDict setValue:os forKey:@"imei2"];
    [mutableDict setValue:[AWTools getUUID] forKey:@"oaid"];
    [mutableDict setValue:openid forKey:@"openid"];

    
    NSString *jsonStr = [AWTools dicttojsonWithdict:[mutableDict copy]];
    AWLog(@"jsonStr=%@",jsonStr);
    
    int cmd = 202;
    [AWSocketManager sendMsg:jsonStr Adntype:cmd];
}

//自定义事件上报
+(void)platformEventReport:(NSString *)eventName paramters:(NSDictionary *)paramter
{
    [AWEventReportManager reportEvent:eventName paramters:paramter];
}

#pragma mark notifation
+(void)loginresult:(NSNotification *)notice
{
    AWLog(@"notify login result userInfo=%@",notice.userInfo);
    if ([[AWSDKApi shareInstance].delegate respondsToSelector:@selector(getLoginResult:)]) {
        [[AWSDKApi shareInstance].delegate getLoginResult:notice.userInfo];
    }
}

+(void)logoutResult:(NSNotification *)notice
{
    if ([[AWSDKApi shareInstance].delegate respondsToSelector:@selector(getLogoutResult:)]) {
        [[AWSDKApi shareInstance].delegate getLogoutResult:notice.userInfo];
    }
}

+(void)maiResult:(NSNotification *)notice
{
    if ([[AWSDKApi shareInstance].delegate respondsToSelector:@selector(getMaimaimaiResult:)]) {
        [[AWSDKApi shareInstance].delegate getMaimaimaiResult:notice.userInfo];
    }
}

+(void)nameCertResult:(NSNotification *)notice
{

}




#pragma openURL
+(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return YES;
}

+(void)maiResultWithtype:(NSString *)type success:(BOOL)success data:(NSDictionary *)dict
{
    NSLog(@"maimaimaimaidict=%@",dict);
    NSMutableDictionary *mutabResultDict = [NSMutableDictionary dictionary];
    [mutabResultDict setValue:@"type" forKey:type];
    NSString *successStr = @"0";
    if (success) {
        successStr = @"1";
    }
    [mutabResultDict setValue:successStr forKey:@"payStatus"];
    [mutabResultDict setValue:dict forKey:@"data"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awmairesultnotice" object:self userInfo:[mutabResultDict copy]];
}
+(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
}


+(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
}
+(void)applicationDidBecomeActive:(UIApplication *)application
{
    [AWTools setIDFA];
    [AWMaiResult searchOrderIDWithToast:NO];
    [[AWJudgeNetWork shareInstance] getNetWork];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AWMaiResult searchOrderIDWithToast:NO];
        [_reachability startNotifier];
    });
    if (![AWTools checkNetwork]) {
        [[AWJudgeNetWork shareInstance] noNetNetWork];
    }
}

+(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    return YES;
}

+(void)setDebugLog:(BOOL)debug
{
    [AWConfig setDebugLog:debug];
}
+(void)setSDKTEST:(BOOL)test
{
    [AWConfig setSDKTEST:test];
}


//SDK参数
+(NSString *)getUUID
{
    return [AWTools getUUID];
}

+(NSString *)getChannelID
{
    return [AWConfig CUrrentCHannelID];
}
+(NSString *)getAppID
{
    return [AWConfig CurrentAppID];
}
+(NSString *)getAppKey
{
    return [AWConfig CurrentAppKey];
}

//悬浮球隐藏显示
+(void)hiddenFloating
{
    [HGHShowBall hiddenWindow];
    [AWGlobalDataManage shareinstance].isCallHiddenFloating = YES;
}
+(void)unHiddenFloating
{
    [HGHShowBall unHiddenWindow];
    [AWGlobalDataManage shareinstance].isCallHiddenFloating = NO;
}

//数据存取
+(void)saveUserInfo:(NSString *)json_userInfo
{
//    if (![AWSDKConfigManager shareinstance].arder_is_arder) {
//        return;
//    }
    [AWSocketManager sendMsg:json_userInfo Adntype:204];
}
+(void)getjson_UserInfoResult:(void(^)(NSString *resultjson))result
{
//    if (![AWSDKConfigManager shareinstance].arder_is_arder) {
//        return;
//    }
    [AWSocketManager sendMsg:nil Adntype:205];
    [AWGlobalDataManage shareinstance].userResultDataBlock = result;
}
+(void)saveGameInfo:(NSString *)json_gameInfo andKey:(NSString *)key
{
//    if (![AWSDKConfigManager shareinstance].arder_is_arder) {
//        return;
//    }
    NSDictionary *newDict = @{@"key":key,@"value":json_gameInfo};
    NSString *msg = [AWTools dicttojsonWithdict:newDict];
    [AWSocketManager sendMsg:msg Adntype:206];
}
+(void)getjson_gameinfoWithKey:(NSString *)key result:(void(^)(NSString *resultjson))result
{
//    if (![AWSDKConfigManager shareinstance].arder_is_arder) {
//        return;
//    }
    NSDictionary *dict = @{@"key":key};
    NSString *msg = [AWTools dicttojsonWithdict:dict];
    [AWSocketManager sendMsg:msg Adntype:207];
    [AWGlobalDataManage shareinstance].gameResultDataBlock = result;
}




//是否调用游戏的实名认证
+(void)checkWhetherNameAuth:(void(^)(BOOL isFource))nameAuthBlock
{
    [AWGlobalDataManage shareinstance].isNameAuthCP = YES;
    [AWGlobalDataManage shareinstance].NameAuthBlock = nameAuthBlock;
}

//强制退出游戏回调
+(void)listenFourceLogoutGame:(void(^)(void))logoutBlock
{
    [AWGlobalDataManage shareinstance].isLogOutCP = YES;
    [AWGlobalDataManage shareinstance].logoutCPBlock = logoutBlock;
}




#pragma mark - DouyinOpenSDKLogDelegate Delegate
+(void)onLog:(NSString *)logInfo
{
    NSLog(@"logInfo==%@",logInfo);
}

@end
