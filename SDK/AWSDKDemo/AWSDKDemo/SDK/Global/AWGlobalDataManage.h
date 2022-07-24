//
//  AWGlobalDataManage.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/9.
//

#import <Foundation/Foundation.h>
#import "AWUserCenterView.h"
#import "AWloginListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWGlobalDataManage : NSObject
@property(nonatomic, assign)BOOL isShowedRealnameAuth;
@property(nonatomic, assign)BOOL isClickQiehuanBtn;    //这里的bool 欢迎界面消失后判断是否弹出实名认证 如果欢迎界面点击了切换账号就不现实实名
@property(nonatomic,assign)BOOL isCloseBroadcast;     //这里记录是否手动关闭滚动广播
@property(nonatomic,assign)BOOL isShowUserCenter;      // 用户中心的web页面是否打开
@property(nonatomic, strong)AWUserCenterView *currentUserCenter;
@property(nonatomic,assign)BOOL isInitFinished;       //初始化是否完成 登录的时候判断 初始化完成信号
@property(nonatomic, strong)NSString *currentAccount;  //用于数据上报
@property(nonatomic,assign)BOOL isLoginSignal;          //login信号 判断CP是否调用login

@property(nonatomic,assign)BOOL isCheckVersionSignal;   //检测版本更新完成信号
@property(nonatomic, assign) NSInteger redNevelopeCount;    //红包领取连续提醒次数
@property(nonatomic,assign)BOOL isRedVenelope;              //红包是否显示
@property(nonatomic,assign)BOOL alreadyLogin;
@property(nonatomic)CGRect floadtingFrame;

@property(nonatomic,assign)BOOL isShowedWeb;        //是否显示过个人中心的web， 显示过的不弹出领取红包
@property(nonatomic,assign)BOOL isShowNonetWork;    //是否在显示无网络提示

@property(nonatomic,assign)BOOL isCallHiddenFloating;   //记录CP是否调用悬浮球
@property(nonatomic,assign)BOOL isWeixinLogin;          // true微信登录  false微信绑定
@property(nonatomic,assign)BOOL isShowingFourceRealName;    //是否正在显示强制实名认证
//socket 回传数据的block
@property(nonatomic, copy)void(^gameResultDataBlock)(NSString *resultjson);
@property(nonatomic, copy)void(^userResultDataBlock)(NSString *resultjson);

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@property(nonatomic, strong)NSDictionary *wechatResponse;   //微信登录成功 暂时保存， 绑定成功之后返回(可以不要了  等下看一下)
@property(nonatomic,strong)NSString *wx;            //微信绑定手机 需要的参数。由微信登录返回

@property(nonatomic, strong)AWloginListView *loginListView;     //登录列表view对象
@property(nonatomic,strong)NSString *inviteCode;

@property(nonatomic,strong)NSString *flotingUrl;    //悬浮球点开的url
@property(nonatomic,strong)NSDate *loginDate;       //记录登录的时间

@property(nonatomic,assign)BOOL isLastActive;       //记录登录开屏活动是否是最后一个
@property(nonatomic,assign)BOOL isClickActive;      //记录是否点击活动打开的web（目前只有两种1，点击悬浮球打开。 2，点击活动也打开）

@property(nonatomic,assign)BOOL isNameAuthCP;       //记录是否调用CP的实名认证
@property(nonatomic, copy)void(^NameAuthBlock)(BOOL isFource);

@property(nonatomic,assign)BOOL isLogOutCP;         //记录强制退出弹框是否调用CP的弹框
@property(nonatomic, copy)void(^logoutCPBlock)(void);

@property(nonatomic, copy)void(^bindWeixinBlock)(BOOL success);

@property(nonatomic,strong)NSString *wholeLogoName;

@property(nonatomic,assign)BOOL isShowRedPackNameAuth;  //实名认证成功之后是否显示领取红包引导页

@property(nonatomic, strong)dispatch_semaphore_t notice_semaphore;  //登录完成后弹公告，阻塞后面的逻辑

@property(nonatomic,assign)BOOL isShowedSetting;           //当前是否已经显示过前往设置（一次启动 只显示一次）

@property(nonatomic,assign)BOOL isUpdateApiFinished;        //更新的接口请求完成

@property(nonatomic,assign)BOOL isAuthNameFinished;         //实名弹框关闭;

@property(nonatomic,assign)BOOL isCPCalledEnterGame;        //CP是否调用进入游戏主界面

@property(nonatomic,assign)BOOL updateCalled;               //更新是否已经执行过
@property(nonatomic,assign)BOOL announceCalled;             //公告是否已经执行过
@property(nonatomic,assign)BOOL rankBannerCalled;           //榜单是否已经执行过

@property(nonatomic,assign)BOOL isShowingAddiction;         //是否正在显示防沉迷
@property(nonatomic,assign)BOOL isShowingNameAuth;          //是否正在显示实名认证
@property(nonatomic,assign)BOOL isShowingUpdate;            //是否正在显示更新

@property(nonatomic,assign)BOOL iswaitNameAuth;             //实名等待显示
@property(nonatomic,assign)BOOL iswaitAddication;           //防沉迷等待显示（只有正在更新的时候等待）
@property(nonatomic,assign)BOOL iswaitannounce;             //公告等待显示
@property(nonatomic,assign)BOOL iswaitRankBanner;           //榜单等待显示

@property(nonatomic,assign)BOOL ispreCalledAnnounce;        //按顺序调用公告

@property(nonatomic,assign)BOOL isNameAuthCallBack;         //是否回调过实名的信息

@property(nonatomic,assign)BOOL isShowingDocking;           //是否正在显示右侧对接中的浮窗

@property(nonatomic,strong)NSString *redpackageUrl;         //红包页面的最新URL路由地址

@property(nonatomic,assign)BOOL isNeedCallSetting;          //是否需要弹设置引导页

@property(nonatomic,assign)BOOL isOpneLog;                  //是否打开日志开关

@property(nonatomic,assign)BOOL isSDKFinished;              //是否允许调起登录

+(instancetype)shareinstance;
-(void)createFloatingTimer;
-(void)createIndulgeTimer;
-(void)createBoradCastTimer;
-(void)createRealnameAuthTimer;
-(void)createReportDataTimer;
-(void)createHeartBeatsTimer;

-(void)createInitTimer;

-(void)destoryFloatingTimer;
-(void)destoryIndulgeTimer;
-(void)destoryBoradCastTimer;
-(void)destoryRealnameAuthTimer;
-(void)destoryinitrequestTimer;

//数据上报
-(void)reportLocalDataWithTime:(NSInteger)timeinterval andPath:(NSString *)path;

-(void)reportLocalRightNow;

-(void)showjuhua;
-(void)dismissjuhua;

@end

NS_ASSUME_NONNULL_END
