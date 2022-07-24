//
//  AWSDKConfigManager.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSDKConfigManager : NSObject
+(instancetype)shareinstance;
@property(nonatomic,strong)NSString *adv_img_full;
@property(nonatomic,strong)NSString *adv_img_normal;
@property(nonatomic,assign)BOOL adv_is_show;
@property(nonatomic,strong)NSString *adv_jump_url;
@property(nonatomic,strong)NSString *adv_package_name;

@property(nonatomic,assign)BOOL broadcast_is_open; //广播
@property(nonatomic,strong)NSString *dc_alias;
@property(nonatomic,strong)NSString *dc_key;

//URLDomain
@property(nonatomic,strong)NSString *API_BASE_URL_GO;
@property(nonatomic,strong)NSString *API_BASE_URL_PHP;
@property(nonatomic,strong)NSString *CHANNEL_REPORT;
@property(nonatomic,strong)NSString *EVENT_URL;
@property(nonatomic,strong)NSString *PAY_URL;

@property(nonatomic,strong)NSString *float_ball_type;
@property(nonatomic,assign)BOOL float_ball_is_float;
@property(nonatomic,assign)BOOL float_ball_is_show_banner;

//@property(nonatomic,strong)NSString *kefu_qq;
//@property(nonatomic,strong)NSString *kefu_weixin;
//@property(nonatomic,strong)NSString *kefu_contact_kefu;
@property(nonatomic,strong)NSString *kefu_phone;
@property(nonatomic,strong)NSString *kefu_email;
@property(nonatomic,strong)NSString *kefu_fb;

@property(nonatomic,strong)NSArray *link;
@property(nonatomic, strong)NSArray *login_type1;
@property(nonatomic, strong)NSArray *login_type2;

@property(nonatomic, strong)NSArray *login_type;

@property(nonatomic,strong)NSString *menu;

@property(nonatomic,strong)NSString *googleID;

/*
 "exp_limit" = 18000;
 "expire_guide" = 5400;
 "holiday_limit" = 18000;
 "is_holiday" = 0;
 "is_open" = 1;
 "name_auth_strategy" = NORMAL;
 "workday_limit" = 18000;
 */

@property(nonatomic,assign)BOOL name_auth_is_open;
@property(nonatomic,assign)BOOL name_auth_is_holiday;
@property(nonatomic,assign)NSInteger name_auth_exp_limit;
@property(nonatomic, assign) NSInteger name_auth_expire_guide;
@property(nonatomic, assign) NSInteger name_auth_holiday_limit;
@property(nonatomic, assign) NSInteger name_auth_workday_limit;
@property(nonatomic,strong)NSString *name_auth_strategy;      //实名等级  GOV国家政府，NORMAL普通版，LOWFREQ低频版
@property(nonatomic,strong)NSString *name_auth_msg;

@property(nonatomic,strong)NSArray *pay_type;

@property(nonatomic,assign)BOOL switch_data_is_fast_login;   //直接快速登录
@property(nonatomic,assign)BOOL switch_data_is_float;
@property(nonatomic,assign)BOOL switch_data_is_indulge;   //防沉迷
@property(nonatomic,assign)BOOL switch_data_is_sleep;     //睡眠模式   悬浮球是否半球
@property(nonatomic,assign)BOOL switch_data_is_show_bannel;  //红包领取图
@property(nonatomic,assign)BOOL switch_data_is_show_login;  //是否显示登陆页面（不显示的时候直接掉微信登录）
@property(nonatomic,assign)BOOL switch_data_is_bind_visitor;    //微信登录是否绑定游客

@property(nonatomic,strong)NSString *tcp_host;
@property(nonatomic,strong)NSString *tcp_port;

@property(nonatomic,assign)BOOL arder_is_arder;         //是否开启无网络弹框 单机游戏登录上报
@property(nonatomic, assign) NSInteger arder_no_newwork;    //无网络后多长时间弹框

@property(nonatomic,strong)NSString *brand;                 //logo主体

@property(nonatomic,assign)BOOL is_socket_log;              //socket的日志开关

@property(nonatomic,strong)NSString *name_auth_menu;        //实名成功引导领红包界面的跳转地址

@property(nonatomic,assign)BOOL is_role_report;             //角色上报 是否传角色和区服
@property(nonatomic,assign)BOOL is_client_ad_report;        //广告上报是否传角色和区服
@property(nonatomic,assign)BOOL is_no_network;              //无网络情况是否退出游戏
@property(nonatomic,assign)BOOL is_crash_log;

@property(nonatomic,assign)BOOL is_docking;                 //该游戏当时是否正在接入


@property(nonatomic,strong)NSString *apple_pay_no;         //苹果支付渠道

@property(nonatomic,assign)BOOL is_privacy_modal;           //启动时用户协议弹窗的开关
//@property(nonatomic,strong)NSString *br

@property(nonatomic,strong)NSString *name_auth_change_type;           //实名的时候点击切换账号 是否弹出领取礼包的页面
@property(nonatomic,strong)NSString *name_auth_gift_img;              //实名领取礼包的图片
@property(nonatomic,strong)NSString *name_auth_gift_code;             //同上，实名切换，显示的礼包码

//关于投放上报的配置
@property(nonatomic, assign) NSInteger report_activate;                    //激活不上报的比例
@property(nonatomic, assign) NSInteger report_reg;                         //注册不上报比例
@property(nonatomic, assign) NSInteger report_pay;                         //付费不上报比例
@property(nonatomic, assign) NSInteger report_pay_return_period;           //针对付费，用户几天内的付费全部上报，不考虑上面的比例

@property(nonatomic,strong)NSString *icon_left;                             //悬浮球图片
@property(nonatomic,strong)NSString *icon_middle;
@property(nonatomic,strong)NSString *icon_right;
@property(nonatomic, assign) NSInteger icon_scale;                          //悬浮球缩放比例（100）

@property(nonatomic,assign)BOOL isLeft;                                     //悬浮球是否有配置
@property(nonatomic,assign)BOOL isRight;
@property(nonatomic,assign)BOOL isMiddle;
@property(nonatomic,strong)UIImage *leftImage;                              //悬浮球图片 缓存起来
@property(nonatomic,strong)UIImage *middleImage;
@property(nonatomic,strong)UIImage *rightImage;


@property(nonatomic,strong)NSString *channelID;                            //渠道ID

@property(nonatomic,strong)NSString *adjust_AppToken;
@property(nonatomic,strong)NSString *adjust_bootstrap;
@property(nonatomic,strong)NSString *adjust_reg;
@property(nonatomic,strong)NSString *adjust_login;
@property(nonatomic,strong)NSString *adjust_charge_page;
@property(nonatomic,strong)NSString *adjust_charge_ok;
@property(nonatomic,strong)NSDictionary *adjust_dc;

-(void)setinitDataWithConfigInfo:(NSDictionary *)configInfo;

@end

NS_ASSUME_NONNULL_END
