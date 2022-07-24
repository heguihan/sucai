//
//  AWSDKApi.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#ifndef HFILENAME_USED
#define HFILENAME_USED
#import "AWOrderModel.h"
#import "AWAdReportModel.h"
#import "AWRoleInfoModel.h"
#endif


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWOrderModel.h"
#import "AWAdReportModel.h"
#import "AWRoleInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class AWSDKApi;
@protocol AWSDKDelegate <NSObject>

@optional
-(void)getLoginResult:(NSDictionary *)userInfo;
-(void)getLogoutResult:(NSDictionary *)userInfo;
-(void)getMaimaimaiResult:(NSDictionary *)maiInfo;
-(void)getRealNameCertificationResult:(NSDictionary *)nameAuthInfo;

@end

@interface AWSDKApi : NSObject
@property(nonatomic, weak)id<AWSDKDelegate> delegate;
+(instancetype)shareInstance;
+(void)initSDK;
+(void)login;
+(void)logout;
+(void)maimaimaiWithOrderInfo:(AWOrderModel *)orderInfo;                        //支付接口
+(void)enterGame;       //游戏进入游戏主界面调用（通知到SDK）
+(void)switchAccount;       //切换账号


+(void)gameCustonReportevent:(NSString *)event extension:(NSDictionary *)ext;       //游戏自定义埋点数据上报
+(void)adreportWithAdinfo:(AWAdReportModel *)adInfo;                                //广告上报
+(void)roleInfoReport:(AWRoleInfoModel *)roleInfo;                                  //角色信息上报
//自定义事件上报
+(void)platformEventReport:(NSString *)eventName paramters:(NSDictionary *)paramter;

//是否可以支付
+(void)checkWhetherCanPayWithAmount:(int)money callback:(void(^)(BOOL canpay))callBackBlock;
//强制退出游戏回调
+(void)listenFourceLogoutGame:(void(^)(void))logoutBlock;
//快速登录 不需要登录界面直接游客登录调用
+(void)faseLogin;
//苹果登录
+(void)AWsignInWithApple;

+(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
+(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+(void)applicationDidBecomeActive:(UIApplication *)application;
+(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;
//SDK参数 需要的自取
+(NSString *)getUUID;             //设备唯一标识(首次自己生成的，存到钥匙串，下次从钥匙串里取，卸载或者换bundleID都不会改变)
+(NSString *)getChannelID;          //渠道号
+(NSString *)getAppID;              //APPID
+(NSString *)getAppKey;             //APPkey
//悬浮球隐藏显示
+(void)hiddenFloating;
+(void)unHiddenFloating;
//数据存取
+(void)saveUserInfo:(NSString *)json_userInfo;  //用户数据保存（需要登录之后调用）
+(void)getjson_UserInfoResult:(void(^)(NSString *resultjson))result; //用户数据读取（需要登录之后调用）
+(void)saveGameInfo:(NSString *)json_gameInfo andKey:(NSString *)key; //自定义key存储（不需要登录）
+(void)getjson_gameinfoWithKey:(NSString *)key result:(void(^)(NSString *resultjson))result; //自定义key读取（不需要登录）
@end

NS_ASSUME_NONNULL_END
