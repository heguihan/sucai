//
//  urls.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/5.
//


#ifndef urls_h
#define urls_h


#define environment             1               // 0-测试环境   1-正式环境

#if environment                 //正式环境
#define URLDOMAININIT               @"https://usercn-sdk.jxywl.cn"                  //SDK相关数据
#else                           //测试环境
#define URLDOMAININIT               @"http://user-cn.51shaha.com"                  //SDK相关数据
#endif

#define URLDOMAIN               [AWSDKConfigManager shareinstance].API_BASE_URL_PHP
#define ORDERDOMAIN             [AWSDKConfigManager shareinstance].PAY_URL                 //支付下单
#define VERSIONDOMAIN           [AWSDKConfigManager shareinstance].API_BASE_URL_GO               //游戏版本检测
#define CPLDOMAIN               @"https://cpl-api.jxywl.cn/game/userdata"       //CPL游戏角色上报
#define  URLREPORTDOMAIN        [AWSDKConfigManager shareinstance].EVENT_URL    //数据上报
#define TOUTIAOREPORTDOMAIN     [AWSDKConfigManager shareinstance].CHANNEL_REPORT        //头条上报

#define CONFIGDOMAIN            [AWConfig CurrentDomain]

//v9

#define  URLINIT                @"/App/v28/config"
#define  URLLOGIN               @"/Login/v11/unified"
#define  URLOUTSEALOGIN         @"/loginext/unified"
#define  URLREGISTER            @"/Reg/v11/unified"
#define  URLCAPTCHA             @"/Publics/captcha"
#define  URLCHANGEPWD           @"/User/editPwd"
#define  URLBINDWECHAT          @"/User/v19/bindWeixin"
#define  URLBINDPHONE           @"/User/bindPhone"
#define  URLREALNAMEAUTH        @"/Name/v4/auth"
#define  URLREFRESHTOKEN        @"/User/v20/refresh"
#define  URLLOGOUT              @"/User/logout"
#define  URLBROADCAST           @"/Broadcast/info"  //10分钟查一次
#define  URLINDGULE             @"/Indulge/v1/report"   //防沉迷  10s上报一次
#define  URLTASK                @"/My/task"         //是否改悬浮球成动态的
#define  URLMYINFO              @"/my/info"        //弹出实名和绑定手机之前 先查接口是否已经实名或者绑定
#define  URLALIAS               @"/User/setAlias"
#define  URLWECHATAPPID         @"/Appid/v1/index"      //获取微信ID
#define  URLADREPORT            @"/Ad/report"
#define  URLBINDCHAPTER         @"/User/captcha"     //手机绑定发验证码
#define  URLBANNERRANK          @"/Banner/v3/rank"      //充值榜单开屏页
#define  URLLOGINAPPLE          @"/loginext/unified"    //苹果登录

#define  URLWEIXINBINDCAPTCHA   @"/Wxphone/v11/captcha"  //微信绑定手机发验证码
#define  URLWEIXINBINDPHONE     @"/Wxphone/v11/checkCaptcha"     //微信绑定手机

#define URLIAPCHECKRECEIPT      @"/iphone/callback"

#define  URLSDKGETORDER         @"/Pay/unifiedOrder"
#define  URLORDERCHECK          @"/order/query"

#define  URLCANPAY              @"/CanPay/unifiedOrder"

#define  URLWHITECONFIG             @"/white/config"

#define  URLNOTICEINFO              @"/notice/v1/info" //请求公告内容

#define  URLFORGOTCAPTCHA           @"/User/v20/captcha" //忘记密码的验证码
#define  URLFORTPWD                 @"/User/v20/forgetPwd" //修改新密码
#define  URLADJUSTREPORT            @"/Adjust/v1/device"

//版本检测

#define  URLCHECKVERSIOn        @"/game_version"

#endif /* urls_h */
