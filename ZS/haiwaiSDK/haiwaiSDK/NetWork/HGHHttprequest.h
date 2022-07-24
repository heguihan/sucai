//
//  HGHHttprequest.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHHttprequest : NSObject
+(instancetype)shareinstance;
// 用户注册
-(void)registWithUserName:(NSString *)userName password:(NSString *)password device:(NSString *)device captcha:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//邮箱登录
-(void)loginWithUserName:(NSString *)username andPassword:(NSString *)password andDevice:(NSString *)device type:(NSString *)type tp:(NSString *)tp tpToken:(NSString *)tptoken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//游客登录
-(void)touristsWithuuid:(NSString *)imei type:(NSString *)type tp:(NSString *)tp ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//第三方登录
-(void)thirdLoginWithuuid:(NSString *)imei type:(NSString *)type tp:(NSString *)tp tpToken:(NSString *)tpToken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//获取验证码
-(void)registVerifyCodeWithUserName:(NSString *)username ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//退出登录
-(void)logOutWithToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//账号绑定
-(void)bindAccountType:(NSString *)type username:(NSString *)username pwd:(NSString *)pwd tp:(NSString *)tp tpToken:(NSString *)tpToken ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//用户资料
-(void)userInfoWithToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//验证token
-(void)verifyToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//重置密码验证码
-(void)resetPwdWithusername:(NSString *)username ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//找回密码
-(void)searchPwdWithusername:(NSString *)username captcha:(NSString *)captcha ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//修改密码
-(void)changePwdWithusername:(NSString *)username oldPassword:(NSString *)oldPassword confirmPwd:(NSString *)confirmPwd pwd:(NSString *)pwd ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//刷新token
-(void)refreshToken:(NSString *)token ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//设备上报
-(void)deviceReportifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//发送票据
-(void)sendReceptWithOrderInfo:(NSDictionary *)orderInfo ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//支付方式
-(void)getmaiWayifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
//屏蔽第三方
-(void)getLoginWayWithAppID:(NSString *)appid channelID:(NSString *)channelID ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
