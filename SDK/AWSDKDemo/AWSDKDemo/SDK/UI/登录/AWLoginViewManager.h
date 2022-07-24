//
//  AWLoginView.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AWLoginViewManager : NSObject
+(void)loginView;



#pragma mark  子页面跳转调用
//显示登陆界面
+(void)otherLogin;
+(void)showLoginListViewAsFirstview:(BOOL)isFirstV;
//显示登录二级列表
+(void)showLoginSubView;
//账号登录页面
+(void)showAccountLogin;
//保存账号页面
+(void)showHistoryLoginAccount;  //暴露出来是因为切换账号之后调用这个页面
//手机号登录页面
+(void)showPhone;
//账号注册
+(void)showAccountRegist;
//联系客服
+(void)showCustomer;
//修改密码
+(void)showChangePwd;
//绑定手机
+(void)showBindPhoneWithBack:(BOOL)haveBack;
//显示悬浮球
+(void)showFloatingBall;
//关闭悬浮球
+(void)closeFloatingBall;
//显示欢迎界面
+(void)showWelcomeViewAccount:(NSString *)account andType:(NSString *)type;
//切换账号
+(void)switchAccount;
//强制退出
+(void)forceLogoutWithMsg:(NSString *)msg;
//显示用户协议
+(void)showUserProtocol;
//显示隐私协议
+(void)showPrivacyProtocol;
//显示个人中心web
+(void)showUsercenterWithUrl:(NSString *)url;
//悬浮球显示gif
+(void)showGif;
//显示修改别名
+(void)showAlias;
//显示配置信息
+(void)showHinMsg;
//显示初始化失败
+(void)showGameconfigError;
//显示版本更新
+(void)showVersionUpdateWithUpdateInfo:(NSDictionary *)updateInfo;
//显示支付结果视图
+(void)showMaiResultView;
//限时领取红包视图
+(void)showRedNevelopeView;
//显示无网络视图
+(void)showNonetworkView;
//关闭无网络视图
+(void)closeNonetWorkView;
//登录之前先判断几个信号 -->是否弹出登录页
+(void)loginCheck;
//弹出设置引导框
+(void)showgotoSetting;
//退出登录确认（游戏调用logout的时候）
+(void)showLogoutview;
//显示健康系统提示
+(void)showHealthNoticeWithMsg:(NSString *)msg;
//显示公告
+(void)showAnnounceView:(NSString *)title content:(NSString *)content isClose:(int)isCloseServer butText:(NSString *)btnStr butJump:(NSString *)urlStr freq:(NSString *)freq;

//显示右上角的 对接中的悬浮窗
+(void)showRightFloat;
//显示启动时候的用户协议授权弹框
+(void)showProtocolAgreeView;
//显示忘记密码
+(void)showForgotPWD;


//刷新webview
+(void)refreshWebview;
+(void)fastLogin;
#pragma mark 关闭所有界面
+(void)closeAllLoginview;
+(void)testUI;
@end

NS_ASSUME_NONNULL_END
