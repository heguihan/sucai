//
//  AWHttpResult.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWHttpResult : NSObject

+(void)initSuccessWithConfig:(NSDictionary *)response;
+(void)initFailed;
// 1登录 2注册  3刷新token 暂时这几个
+(void)loginResultWithUserinfo:(NSDictionary *)response type:(NSInteger)type;
//微信登录成功
+(void)wechatloginResultWithUserinfo:(NSDictionary *)response;
//谷歌登录回调  这里谷歌验证失败的话 需要调用signout
+(void)googleLoginResultWithUserInfo:(NSDictionary *)response;
//修改登录状态
+(void)changeLoginStatus:(BOOL)loginstatus;
//滚动消息结果
+(void)broadcastResultWithlist:(NSDictionary *)response;
//实名认证回调
+(void)realnameAuthResult:(NSDictionary *)response;
//修改密码的回调
+(void)changePwdResult:(NSDictionary *)response;
////滚动消息数据回调
//+(void)broadcastDataResult:(NSDictionary *)response;
//悬浮球gif回调
+(void)floatingballgifResult:(NSDictionary *)response;
//查询个人信息回调   主要是是否实名 和是否绑定手机
+(void)searchUserInfoResult:(NSDictionary *)response;
//修改别名回调
+(void)aliasAccountResult:(NSDictionary *)response;
//检测版本更新
+(void)checkVersionResult:(NSDictionary *)response;
//绑定手机
+(void)bindPhoneResult:(NSDictionary *)response;
//充值榜单开屏页
+(void)bannerRankResultWithUserinfo:(NSDictionary *)response;
//请求榜单
+(void)getBannerRankRequest;

#pragma mark 下面的接口是弹框顺序
//显示更新
+(void)judgeShowUpdate:(NSDictionary *)dataDict isFromApi:(BOOL)isApi;
//显示公告
+(void)judgeShowAnnouce:(NSDictionary *)dataDict isFromApi:(BOOL)isApi;
//显示榜单
+(void)judgeShowBannerRank:(NSArray *)advArr;
//开始公告的请求
+(void)beginAnnouncerequest;
@end

NS_ASSUME_NONNULL_END
