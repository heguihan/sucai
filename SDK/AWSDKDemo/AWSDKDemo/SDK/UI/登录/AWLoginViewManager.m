//
//  AWLoginView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWLoginViewManager.h"
#import "AWloginListView.h"
#import "AWSDKConfigManager.h"
#import "AWUserInfoManager.h"
#import "HGHShowBall.h"
#import "AWViewManager.h"

#pragma testUI
#import "AWHistoryLoginView.h"
#import "AWCustomerView.h"
#import "AWFastAccountView.h"
#import "AWChangePwdView.h"
#import "AWAccountLoginView.h"
#import "AWForgotPwdView.h"
#import "AWPhoneRegisterView.h"
#import "AWBindPhoneview.h"
#import "AWChangeAccountView.h"
#import "AWAccountRegistview.h"
#import "AWWelcomeView.h"
#import "AWUserProtocolView.h"
#import "AWUserCenterView.h"
#import "AWAliasView.h"
#import "AWHinMsgView.h"
#import "AWGameConfigErrorAlertView.h"
#import "AWCheckVersion.h"
#import "AWForcedLogOutView.h"
#import "AWMaiResult.h"
#import "AWRedNevelopeView.h"
#import "AWNoNetwork.h"
#import "AWGotoSettingView.h"
#import "AWLogoutView.h"

#import "AWPhoneLogin.h"
#import "AWBindWechat.h"

#import "AWHealthNotice.h"
#import "AWAnnounceView.h"

#import "AWDocking.h"
#import "AWProtocolAgree.h"

#import "AWLoginSubListView.h"


@interface AWLoginViewManager()
@property(nonatomic, strong)AWUserCenterView *usercenterview;

@end

@implementation AWLoginViewManager

+(void)loginCheck
{
    BOOL isInitSuccess = [AWGlobalDataManage shareinstance].isInitFinished;
//    BOOL isCheckVersion = [AWGlobalDataManage shareinstance].isCheckVersionSignal;
    BOOL isCpCallLogin = [AWGlobalDataManage shareinstance].isLoginSignal;
    BOOL isSDKFinished = [AWGlobalDataManage shareinstance].isSDKFinished;
    AWUserInfoManager *userInfo = [AWUserInfoManager shareinstance];
    AWLog(@"loginStatus===%d",userInfo.LoginStatus);
    
//    if (!isInitSuccess) {
//        [AWTools makeToastWithText:@"初始化未成功"];
//    }
//    if (!isCheckVersion) {
//        [AWTools makeToastWithText:@"没有检测版本"];
//    }
//    if (!isCpCallLogin) {
//        [AWTools makeToastWithText:@"cp没有调用"];
//    }
    
    
    if (isInitSuccess && isCpCallLogin && isSDKFinished) {
        [self loginView];
    }
}

+(void)loginView
{
    /*
     1,判断登录状态  登录状态是1  直接刷新token
     2,判断是否快速登录 是的话 直接快速登录
     3,判断是否有历史账号 有的话show历史账号页面
     4,出现loginListview界面
     */
    if ([AWGlobalDataManage shareinstance].alreadyLogin && [AWSDKConfigManager shareinstance].switch_data_is_show_login) {
        return;
    }
    if ([AWUserInfoManager shareinstance].LoginStatus) {
        [self refreshToken];
        return;
    }
    if (![AWSDKConfigManager shareinstance].switch_data_is_show_login) {
        //微信登录逻辑
        [AWGlobalDataManage shareinstance].isWeixinLogin = YES;
        [AWBindWechat bindWeiChat];
        return;
    }
    
    [self otherLogin];
    
    
}

+(void)otherLogin
{
        if ([AWSDKConfigManager shareinstance].switch_data_is_fast_login) {
            //调用快速登录接口
            [self fastLogin];
            return;
        }
        if ([AWConfig loadLoginAccount].count>0) {
            //调用历史账号界面
            [self showHistoryLoginAccount];
            return;
        }
        [self showLoginListViewAsFirstview:YES];
    //展示登录列表
}

//刷新token
+(void)refreshToken
{
    [AWHTTPRequest AWRefreshTokenRequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}
//快速登录
+(void)fastLogin
{
    [AWHTTPRequest AWRegistRequestWithAccount:@"" pwd:@"" phoneNO:@"" captcha:@"" loginType:LOGIN_VISITOR ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}
//保存账号页面
+(void)showHistoryLoginAccount
{
    AWHistoryLoginView *historyView = [AWHistoryLoginView factory_historyLoginview];
    [historyView show];
}

//展示登录列表
+(void)showLoginListViewAsFirstview:(BOOL)isFirstV
{
    NSArray *loginList = [AWSDKConfigManager shareinstance].login_type1;
    AWloginListView *listView = [AWloginListView factory_loginlistWithArr:loginList];
    listView.arr = loginList;
    listView.isFirstView = isFirstV;
    [AWGlobalDataManage shareinstance].loginListView = listView;
    [listView show];
}

//显示登录二级列表
+(void)showLoginSubView
{
    NSArray *loginList = [AWSDKConfigManager shareinstance].login_type2;
    AWLoginSubListView *sublistView = [AWLoginSubListView factory_loginSublistWithArr:loginList];
    sublistView.arr = loginList;
    sublistView.isFirstView = NO;
    [AWGlobalDataManage shareinstance].loginListView = sublistView;
    [sublistView show];
}

#pragma mark 子页面跳转
//账号登录页面
+(void)showAccountLogin
{
    AWAccountLoginView *accountLoginV = [AWAccountLoginView factory_accountLoginview];
    [accountLoginV show];
}
//手机号登录页面
+(void)showPhone
{
    AWPhoneRegisterView *phoneRegist = [AWPhoneRegisterView factory_forgotPwdView];
//    [phoneRegist show];
    AWPhoneLogin *phoneLogin = [AWPhoneLogin factory_phoneLogin];
    [phoneLogin show];
}
//账号注册
+(void)showAccountRegist
{
    AWAccountRegistview *accountRegist = [AWAccountRegistview factory_registaccount];
    [accountRegist show];
}
//联系客服
+(void)showCustomer
{
    AWCustomerView *customv = [AWCustomerView factory_customerview];
    [customv show];
}
//修改密码
+(void)showChangePwd
{
    AWChangePwdView *changev = [AWChangePwdView factory_changepwdview];
    [changev show];
}
//绑定手机
+(void)showBindPhoneWithBack:(BOOL)haveBack
{
    AWBindPhoneview *bindphonev = [AWBindPhoneview factory_bindPhoneViewWithCloseHidden:!haveBack];
    [bindphonev show];
}


//关闭窗口
+(void)closeAllLoginview
{
    [AWTools removeViews:WHOLEVIEW];
}
//显示悬浮球
+(void)showFloatingBall
{
    if ([AWSDKConfigManager shareinstance].switch_data_is_float) {
        [HGHShowBall showFloatingball];
    }
}
//关闭悬浮球
+(void)closeFloatingBall
{
    [HGHShowBall closeFloatingBall];
}

//显示欢迎界面
+(void)showWelcomeViewAccount:(NSString *)account andType:(NSString *)type
{
    AWWelcomeView *welcomeV = [AWWelcomeView factory_welcomeViewWithAccount:account andType:type];
    [welcomeV show];
}

//显示用户协议
+(void)showUserProtocol
{
    AWUserProtocolView *userprotocolV = [AWUserProtocolView factory_userProtocolWithKey:@"Agreement"];
    [userprotocolV show];
}
//显示隐私协议
+(void)showPrivacyProtocol
{
    AWUserProtocolView *userprotocolV = [AWUserProtocolView factory_userProtocolWithKey:@"Privacy"];
    [userprotocolV show];
}
//显示个人中心web
+(void)showUsercenterWithUrl:(NSString *)url
{
    [AWGlobalDataManage shareinstance].isShowedWeb = YES;  //显示过
    [AWGlobalDataManage shareinstance].isShowUserCenter = YES; //正在显示 后面关闭的时候会修改bool
    [AWGlobalDataManage shareinstance].flotingUrl = url;
    AWUserCenterView *usercenterView = [AWUserCenterView factory_usercenterview];
    [AWGlobalDataManage shareinstance].currentUserCenter = usercenterView;
    [usercenterView show];
}

//切换账号
+(void)switchAccount
{
    AWChangeAccountView *changeAccount = [AWChangeAccountView factory_changeAccountView];
    [changeAccount show];
}

//强制退出
+(void)forceLogoutWithMsg:(NSString *)msg
{
    if ([AWGlobalDataManage shareinstance].isLogOutCP) {
        [AWGlobalDataManage shareinstance].logoutCPBlock();
        return;
    }
    
    AWForcedLogOutView *forceView = [AWForcedLogOutView factory_forcedLogoutWithMsg:msg];
    [forceView show];
}

//悬浮球显示gif
+(void)showGif
{
    [HGHShowBall isSHowGif:YES];
}

//显示修改别名
+(void)showAlias
{
    AWAliasView *aliasv = [AWAliasView factory_aliasview];
    [aliasv show];
}

//显示配置信息
+(void)showHinMsg
{
    AWHinMsgView *hinmsg = [AWHinMsgView factory_hinMsg];
    [hinmsg show];
}

//显示初始化失败
+(void)showGameconfigError
{
    [[AWGlobalDataManage shareinstance] createInitTimer];
//    当前网络不稳定请稍后再试
    AWGameConfigErrorAlertView *gameconfigErrorV = [AWGameConfigErrorAlertView factory_gameconfigErrorWithContentStr:@"当前网络不稳定请稍后再试"];
//    [gameconfigErrorV show];
}
//显示版本更新
+(void)showVersionUpdateWithUpdateInfo:(NSDictionary *)updateInfo
{
    
    if ([updateInfo[@"update_type"] intValue]==1) {
        int noticeTime = [updateInfo[@"notice_mode"] intValue];
        NSDate *lastDate = [AWConfig getLastCheckVersion];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeValue = [nowDate timeIntervalSinceDate:lastDate];
        int timeInterval = (int)timeValue/1;
        int oneDay = 60*60*24;
        if (timeInterval> noticeTime * oneDay) {
            AWCheckVersion *checkV = [AWCheckVersion factory_checkversionWithUpdateType:updateInfo];
            [checkV show];
            [AWConfig saveCheckVersionTime];
        }
    }else{
        AWCheckVersion *checkV = [AWCheckVersion factory_checkversionWithUpdateType:updateInfo];
        [checkV show];
        [AWConfig saveCheckVersionTime];
    }

    

}
//显示支付结果视图
+(void)showMaiResultView
{
    AWMaiResult *maiView = [AWMaiResult factory_maiResultview];
    [maiView show];
}
//限时领取红包视图
+(void)showRedNevelopeView
{
    [AWDataReport saveEventWittEvent:@"app_show_banner" properties:@{}];
    AWRedNevelopeView *rednevelope = [AWRedNevelopeView factory_rednevelopeView];
    [rednevelope showRednevelope];
}

//显示无网络视图
+(void)showNonetworkView
{
    [AWGlobalDataManage shareinstance].isShowNonetWork = YES;
    AWNoNetwork *nonetwork = [AWNoNetwork factory_noNetWork];
    [nonetwork show];
}

//关闭无网络视图
+(void)closeNonetWorkView
{
    [AWTools removeViews:WHOLEVIEW];
}
//弹出设置引导框
+(void)showgotoSetting
{
    
    return;
    BOOL isInitFinished = [AWGlobalDataManage shareinstance].isInitFinished;
    BOOL isNeedCallSetting = [AWGlobalDataManage shareinstance].isNeedCallSetting;
    
    if (isInitFinished && isNeedCallSetting) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AWGotoSettingView *settingview = [AWGotoSettingView factory_gotosetting];
            [AWGlobalDataManage shareinstance].isShowedSetting = YES;   //记录已经显示过前往设置页面，下次就不弹框显示了
    //        [settingview show];
            [settingview showNotCloseView];
        });
    }
}

//退出登录确认（游戏调用logout的时候）
+(void)showLogoutview
{
    AWLogoutView *logoutview = [AWLogoutView factory_awlogoutview];
    [logoutview show];
}

//显示健康系统提示
+(void)showHealthNoticeWithMsg:(NSString *)msg
{
    
    if ([AWGlobalDataManage shareinstance].isShowingUpdate) {
        [AWGlobalDataManage shareinstance].iswaitAddication = YES;
        return;
    }
    [AWGlobalDataManage shareinstance].iswaitAddication = NO;
    
    AWHealthNotice *healthNotice = [AWHealthNotice factory_healthNoticeWithMsg:msg];
    [healthNotice show];
}

//显示公告
+(void)showAnnounceView:(NSString *)title content:(NSString *)content isClose:(int)isCloseServer butText:(NSString *)btnStr butJump:(NSString *)urlStr freq:(NSString *)freq
{
    if (!isCloseServer) {
        //这里判断当天是否显示
        NSString *lastTime = [AWTools getLastTimeStrWithPath:LOCALNOTICETIMESTR];
        BOOL isShowed = NO;
        if (lastTime && lastTime.length>1) {
            isShowed = [AWTools isOverOnyDayWithLastTime:lastTime];
            if (isShowed || isCloseServer>0) {
                dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
                return;
            }
        }
    }
    [AWDataReport saveEventWittEvent:@"app_show_banner_notice" properties:@{}];
    AWAnnounceView *announceView = [AWAnnounceView factory_AnnounceViewWithTitle:title andContent:content isCloseServer:isCloseServer btnText:btnStr urlstr:urlStr freq:freq];
    [announceView show];
}

//显示右上角的 对接中的悬浮窗
+(void)showRightFloat
{
    [AWDocking showDockingFloat];
}

//显示启动时候的用户协议授权弹框
+(void)showProtocolAgreeView
{
    AWProtocolAgree *proctcolAgree = [AWProtocolAgree factory_protocolAgreeView];
    [proctcolAgree show];
}



//显示忘记密码
+(void)showForgotPWD
{
    AWForgotPwdView *forgotpwdview = [AWForgotPwdView factory_forgotPwdView];
    [forgotpwdview show];
}

//刷新webview
+(void)refreshWebview
{
    [[AWGlobalDataManage shareinstance].currentUserCenter reloadwebview];
}

+(void)testUI
{
//    AWFastLoginView *fastv = [AWFastLoginView factory_fastLoginview];
//    [MAINVIEW addSubview:fastv];
//    AWCustomerView *customv = [AWCustomerView factory_customerview];
//    [MAINVIEW addSubview:customv];
//    AWFastAccountView *fastAccountV = [AWFastAccountView facory_fastAccountview];
//    [MAINVIEW addSubview:fastAccountV];
//    AWChangePwdView *changev = [AWChangePwdView factory_changepwdview];
//    [MAINVIEW addSubview:changev];
//    AWAccountLoginView *accountLogin = [AWAccountLoginView factory_accountLoginview];
//    [MAINVIEW addSubview:accountLogin];
//    AWForgotPwdView *forgotpwdview = [AWForgotPwdView factory_forgotPwdView];
//    [MAINVIEW addSubview:forgotpwdview];
//    AWPhoneRegisterView *phoneregist = [AWPhoneRegisterView factory_forgotPwdView];
//    [MAINVIEW addSubview:phoneregist];
//    AWBindPhoneview *bindphonev = [AWBindPhoneview factory_forgotPwdView];
//    [MAINVIEW addSubview:bindphonev];
//    AWRealNmaeView *realnameV = [AWRealNmaeView factory_forgotPwdView];
//    [MAINVIEW addSubview:realnameV];
//    AWChangeAccountView *changeview = [AWChangeAccountView factory_changeAccountView];
//    [MAINVIEW addSubview:changeview];
//    AWAccountRegistview *accountREgistV = [AWAccountRegistview factory_registaccount];
//    [accountREgistV show];

    
}
@end
