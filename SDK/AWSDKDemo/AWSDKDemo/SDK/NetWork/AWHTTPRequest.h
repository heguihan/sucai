//
//  AWHTTPRequest.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/5.
//

#import <Foundation/Foundation.h>
#import "AWOrderModel.h"
#import "AWAdReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWHTTPRequest : NSObject

//测试接口
+(void)testRequest;
// MARK  初始化
+(void)AWinitRequestifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  登录
+(void)AWLoginRequestWithAccount:(NSString *)account pwd:(NSString *)pwd phoneNO:(NSString *)phoneNO captcha:(NSString *)code loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK 海外登录
+(void)AWOUTSEAloginRequest:(NSString *)sessionID loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  微信登录
+(void)AWWeChatLoginRequestWithSessionID:(NSString *)sessionID  ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK 苹果登录
+(void)AWAppleLoginRequestWithAppleUser:(NSString *)user token:(NSString *)token  ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  注册
+(void)AWRegistRequestWithAccount:(NSString *)account pwd:(NSString *)pwd phoneNO:(NSString *)phoneNO captcha:(NSString *)code loginType:(NSString *)logintype ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  发送验证码
+(void)AWSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  发送验证码（手机登录）
+(void)AWBindSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

// MARK  发送验证码（微信手机绑定）
+(void)AWWeixinBindPhoneSendCaptchaRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  修改密码
+(void)AWChangePasswordRequestWithOldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd rePwd:(NSString *)repwd ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  绑定微信
+(void)AWBindWechatRequestWithSessionID:(NSString *)sessionId ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  绑定手机
+(void)AWBindPhoneNORequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  微信绑定手机
+(void)AWWeinXInBindPhoneNORequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha wx:(NSString *)wx ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  刷新token
+(void)AWRefreshTokenRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  Logout
+(void)AWLogoutRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  滚动消息   10分钟查一次病更新滚动消息
+(void)AWBroadcastRequestWithH5:(BOOL)isH5 IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  悬浮球gif
+(void)AWFloatingGifRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  修改别名
+(void)AWAliasAccouintRequestwithAlias:(NSString *)alias IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  获取微信APPID
+(void)AWGetWechatAppidRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  SDK下单
+(void)AWGetOrderIDWithOrderInfo:(AWOrderModel *)orderInfo payType:(NSString *)paytype RequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  广告上报
+(void)AWAdReportWithAdInfo:(AWAdReportModel *)adInfo RequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  查询订单状态
+(void)AWSearchOrderRequestwithorderID:(NSString *)orderID IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  验证内购票据
+(void)AWCheckReceiptRequestwithorderID:(NSString *)orderID deal_no:(NSString *)deal_no andreceipt:(NSString *)receipt IfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  充值榜单开屏页
+(void)AWBannerRankRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;


// MARK  公告
+(void)AWNoticeInfoRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

// MARK  发送验证码（忘记密码）
+(void)AWSendCaptchaForGotPWDRequestWithphoneNO:(NSString *)phoneNO ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK  忘记密码设置新密码
+(void)AWForgotPWDRequestWithPhoneNO:(NSString *)phoneNo captch:(NSString *)captcha newPWD:(NSString *)newPWD ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

#pragma mark 数据上报
+(void)testReport;
#pragma mark 检测版本
// MARK  检测版本 是否强更
+(void)AWCheckVersionRequestIfSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;

// MARK  检测是否可以支付
+(void)AWCheckCanpayWithAmount:(int)money ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
// MARK adjust上报
+(void)AWADjustReportWithDataWithDict:(NSDictionary *)dict ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
