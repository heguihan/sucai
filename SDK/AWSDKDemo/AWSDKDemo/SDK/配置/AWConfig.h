//
//  AWConfig.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import "AWUserInfoManager.h"
#import "AWSDKConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWConfig : NSObject
+(instancetype)shareInstance;

//配置请求
+(void)configRequest;

+(void)setCurrentAppID:(NSString *)appID;
+(void)setCurrentAppKey:(NSString *)appKey;
+(void)setCurrentGravity:(NSString *)gravity;
+(void)setCurrentChannelID:(NSString *)channelID;
+(NSString *)CurrentAppID;
+(NSString *)CurrentAppKey;
+(NSString *)CUrrentCHannelID;
+(NSString *)Currentgravity;
+(NSString *)SDKversion;
+(NSString *)SDKINTVersion;
+(NSString *)CurrentDomain;


+(BOOL)regularAccount:(NSString *)account;
+(BOOL)regularPhoneNO:(NSString *)phoneNO;
+(BOOL)regularPwd:(NSString *)pwd;
+(BOOL)regularIdCardNum:(NSString *)idNum;
+(BOOL)regularRealName:(NSString *)realname;
+(void)saveToken:(NSString *)token;
+(NSString *)getSaveToken;    //不记录登录状态的时候 保存到这里（比如微信登录，绑定的时候要用到token）
+(NSString *)CurrentToken;
//登录用户信息保存
+(void)saveUserinfoToLoacl:(NSDictionary *)userinfo;
+(NSDictionary *)loadUserinfoFromLocal;
+(void)clearLocalUserinfo;
+(void)changeLoginSTatus:(NSNumber *)loginstatus;
//修改账号的密码
+(void)changePwd:(NSString *)newPwd;
//初始化SDK配置保存
+(void)saveSDKconfigToLocal:(NSDictionary *)configInfo;
+(NSDictionary *)loadSDKConfig;
//登陆过的历史账号
+(void)saveLoginAccount:(NSDictionary *)loginInfo;
+(NSArray *)loadLoginAccount;

//日志输出
+(BOOL)getDebugLog;
+(void)setDebugLog:(BOOL)debug;
//测试SDK
+(void)setSDKTEST:(BOOL)test;

//微信支付channel
+(NSString *)WeixinPayChannel;    //微信支付时候的channel 字段改为配置文件里面读取

//SDK调取退出游戏操作
+(void)LogoutWithGame;
//关闭broacast次数统计
+(void)saveBrocastCloseCount;
+(int)getBrocastCloseCount;

//SDK显示版本检测的时间
+(void)saveCheckVersionTime;
+(NSDate *)getLastCheckVersion;
//获取配置域名
/*
 @property(nonatomic,strong)NSString *API_BASE_URL_GO;
 @property(nonatomic,strong)NSString *API_BASE_URL_PHP;
 @property(nonatomic,strong)NSString *CHANNEL_REPORT;
 @property(nonatomic,strong)NSString *EVENT_URL;
 @property(nonatomic,strong)NSString *PAY_URL;
 */
+(NSString *)getAPI_BASE_URL_GO;
+(NSString *)getAPI_BASE_URL_PHP;
+(NSString *)getCHANNEL_REPORT;
+(NSString *)getEVENT_URL;
+(NSString *)getPAY_URL;
@end

NS_ASSUME_NONNULL_END
