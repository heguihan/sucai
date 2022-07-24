//
//  AWHttpResult.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/7.
//

#import "AWHttpResult.h"
#import "AWBroadcastData.h"
#import "AWFastAccountView.h"
#import "AWDeviceInfo.h"
#import "AWScreenAdManager.h"
#import "AWSocketManager.h"
#import "AWSDKApi.h"
#import "AWScreenModel.h"
#import "AWLoginActiveManager.h"

#import "AWEventReportManager.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "AWEventReportManager.h"

@implementation AWHttpResult

static NSDate *_loginDate;

//初始化成功
+(void)initSuccessWithConfig:(NSDictionary *)response
{
    

    if ([response[@"code"] intValue]==200) {
        NSDictionary *appconfigInfo = [response objectForKey:@"data"];
        NSDictionary *adv = appconfigInfo[@"adv"];
        [self showOpenScreenWithDict:adv];   //展示开屏页
        [AWConfig saveSDKconfigToLocal:appconfigInfo];
        [AWGlobalDataManage shareinstance].isInitFinished = YES;
        [self initsuccessOrLoacl];
    }else if ([response[@"code"] intValue] == 405){
        //模拟器用户
        //退出游戏
        [AWTools makeToastWithText:response[@"msg"] andTime:3.0];
        //3秒后退游
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSObject *nilobj = nil;
            NSDictionary *testexc = @{@"test":nilobj}; //杀进程
        });
    }
    else{
        AWLog(@"初始化失败");
        NSDictionary *sdkconfigInfo = [AWConfig loadSDKConfig];
        if (sdkconfigInfo) {
            //继续
            NSDictionary *adv = sdkconfigInfo[@"adv"];
            [self showOpenScreenWithDict:adv];
            [AWGlobalDataManage shareinstance].isInitFinished = YES;
            [self initsuccessOrLoacl];
        }else{
            //弹出框 重新试一下 并且不弹出登录框
            [AWLoginViewManager showGameconfigError];
            [AWGlobalDataManage shareinstance].isInitFinished = NO;
        }
    }
}



//初始化失败
+(void)initFailed
{
    AWLog(@"initFaild");
    NSDictionary *sdkconfigInfo = [AWConfig loadSDKConfig];
    if (sdkconfigInfo) {
        //继续
        NSDictionary *adv = sdkconfigInfo[@"adv"];
        [self showOpenScreenWithDict:adv];
        [AWGlobalDataManage shareinstance].isInitFinished = YES;
        [self initsuccessOrLoacl];
    }else{
        //弹出框 重新试一下 并且不弹出登录框
        [AWLoginViewManager showGameconfigError];
        [AWGlobalDataManage shareinstance].isInitFinished = NO;
    }
}

//显示开屏页逻辑
+(void)showOpenScreenWithDict:(NSDictionary *)adv
{
    BOOL isnull = [adv isKindOfClass:[NSNull class]] || [adv isEqual:[NSNull null]];
    if (!isnull) {
        if ([adv[@"is_show"] intValue]==1) {
            //显示
            AWScreenAdManager *ADmanager = [AWScreenAdManager shareInstance];
            ADmanager.img_full = adv[@"img_full"];
            ADmanager.img_normal = adv[@"img_normal"];
            ADmanager.jump_url = adv[@"ios_jump_url"];
            ADmanager.schemeurl = adv[@"bid"];
            [ADmanager showAdScreen];
        }
    }
}

//初始化成功 或者本地有初始化的数据
+(void)initsuccessOrLoacl
{
    //投放渠道上报改到这里来
    if (![AWSDKConfigManager shareinstance].is_docking) {
        [AWLoginViewManager showRightFloat];
    }
    
    [ProgressHUD dismiss];
    [AWGlobalDataManage shareinstance].isInitFinished = YES;
    [AWLoginViewManager showgotoSetting];
    
    [[AWGlobalDataManage shareinstance] dismissjuhua];
    [self connectSocket];
//    [AWLoginViewManager loginCheck];
    [[AWGlobalDataManage shareinstance] destoryinitrequestTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self activeReport];
    });
    NSString *googleID = [AWSDKConfigManager shareinstance].googleID;
    [GIDSignIn sharedInstance].clientID=googleID;
//    [AWTools setIDFA];
    [AWGlobalDataManage shareinstance].isInitFinished = YES;
    [AWGlobalDataManage shareinstance].isSDKFinished = YES;
    [AWLoginViewManager loginCheck];
    
    
    
//    [[AWADjustReport shareInstance] adjustInit];
    [AWEventReportManager initReportSDK];
    
    
}


+(void)activeReport
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *deviceInfo = @{@"os_ver":[AWDeviceInfo systemVersion],
                                 @"os":@"ios",
                                 @"sim":@"N/A",
                                 @"screen":[AWDeviceInfo getWidthAndHeight],
                                 @"model":[AWDeviceInfo iphoneName],
                                 @"manufacturer":[AWDeviceInfo iphoneName],
                                 @"carrier":[AWDeviceInfo getOperator],
                                 @"channel_id":[AWConfig CUrrentCHannelID],
                                 @"device_id":[AWTools getIdfa],
                                 @"app_id":[AWConfig CurrentAppID],
                                 @"app_ver":appVersion,
                                 @"network_type":[AWDeviceInfo getNetconnType],
                                 @"imei":[AWTools getIdfa],
                                 @"mac":[AWDeviceInfo macAddress],
                                 @"oaid":[AWTools getUUID]
                                 
    };
    

//    NSString *jsonStr = [AWTools dicttojsonWithdict:deviceInfo];
//    AWLog(@"jsonStr=%@",jsonStr);
//    int cmd = 208;
//    [AWSocketManager sendMsg:jsonStr Adntype:cmd];

    if ([AWTools isFirstInstall_socket]) //这里的判断 写在应用里
    {
        NSString *jsonStr = [AWTools dicttojsonWithdict:deviceInfo];
        AWLog(@"jsonStr=%@",jsonStr);
        int cmd = 208;
        [AWSocketManager sendMsg:jsonStr Adntype:cmd];
    }
}

static BOOL _isConnected = NO;
+(void)connectSocket
{
    if (_isConnected) {
        return;
    }
    NSString *host = [AWSDKConfigManager shareinstance].tcp_host;
    NSString *port = [AWSDKConfigManager shareinstance].tcp_port;
    [AWSocketManager connectSocketWithHost:host andport:port];
    _isConnected = YES;
}
/*
 code = 200;
 data =     {
     "notice_mode" = 0;
     "update_info" = "";
     "update_type" = 0;
     "update_url" = "";
     "version_name" = "";
 };
 */
//检测版本更新
+(void)checkVersionResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        NSDictionary *datadict = response[@"data"];
        if ([datadict[@"update_type"] intValue]==0) {
//            [AWGlobalDataManage shareinstance].isCheckVersionSignal = YES;
//            [AWLoginViewManager loginCheck];
            dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        }else{
            //有更新
            [AWLoginViewManager showVersionUpdateWithUpdateInfo:datadict];
//            [AWGlobalDataManage shareinstance].isUpdateApiFinished = YES;
//            [self judgeShowUpdate:datadict isFromApi:YES];
        }
    }else{
        AWLog(@"检测版本失败");
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
    }
}

+(void)beginShowViewWithUserInfo:(NSDictionary *)userInfo
{
    
    [AWGlobalDataManage shareinstance].notice_semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t notice_queue = dispatch_queue_create("notice_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(notice_queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //实名
//            [self beginNameAuth:userInfo];
            dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        });
    });
    
    dispatch_async(notice_queue, ^{
        //等待信号再执行
        dispatch_semaphore_wait([AWGlobalDataManage shareinstance].notice_semaphore, DISPATCH_TIME_FOREVER);
        //检测版本
        dispatch_async(dispatch_get_main_queue(), ^{
            //版本更新
            
            [self checkVersion];
        });

    });
    
    dispatch_async(notice_queue, ^{
        //等待信号再执行
        dispatch_semaphore_wait([AWGlobalDataManage shareinstance].notice_semaphore, DISPATCH_TIME_FOREVER);
        //公告
        dispatch_async(dispatch_get_main_queue(), ^{
            [AWGlobalDataManage shareinstance].ispreCalledAnnounce = YES;
            [self beginAnnouncerequest];
        });

    });
    
    dispatch_async(notice_queue, ^{
        //等待信号再执行
//        [self getBannerRankRequest];
        dispatch_semaphore_wait([AWGlobalDataManage shareinstance].notice_semaphore, DISPATCH_TIME_FOREVER);
        //检测版本
        dispatch_async(dispatch_get_main_queue(), ^{
            //榜单
            [self getBannerRankRequest];
        });

    });
    
//    //实名
//    [self beginNameAuth:@{}];
//    //版本更新
//    [self checkVersion];
//    //公告
//    [self requestAnnounce];
//    //榜单
//    [self getBannerRankRequest];
}



//#pragma mark 判断弹框的弹出顺序
////这里判断显示弹框的顺序
//
////这里调起实名认证策略
//+(void)beginNameAuth:(NSDictionary *)userinfo
//{
//    _loginDate = [NSDate date];
//    [AWGlobalDataManage shareinstance].loginDate = [NSDate date];
//}

//开始公告的请求
+(void)beginAnnouncerequest
{
    BOOL isshownameAuth =[AWGlobalDataManage shareinstance].isShowingNameAuth;
    BOOL isshowaddiction = [AWGlobalDataManage shareinstance].isShowingAddiction;
    BOOL isshowupdate = [AWGlobalDataManage shareinstance].isShowingUpdate;
    
    
    if (isshowupdate || isshowaddiction || isshownameAuth) {
        return;
    }
    
    BOOL isCPCalled = [AWGlobalDataManage shareinstance].isCPCalledEnterGame;
    BOOL isPreCalled = [AWGlobalDataManage shareinstance].ispreCalledAnnounce;
    if (isCPCalled && isPreCalled) {
        //公告
        [AWGlobalDataManage shareinstance].ispreCalledAnnounce = NO;
        if ([AWGlobalDataManage shareinstance].announceCalled) {
            dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
            return;
        }
        [AWGlobalDataManage shareinstance].announceCalled = YES;
        [self requestAnnounce];
    }
    dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
}
//
////显示更新
//+(void)judgeShowUpdate:(NSDictionary *)dataDict isFromApi:(BOOL)isApi
//{
//    //从接口开始
//    NSDictionary *updateData = [NSDictionary dictionary];
//    if (isApi) {
//        updateData = dataDict;
//    }
//    BOOL isApiFinished = [AWGlobalDataManage shareinstance].isUpdateApiFinished;
//    BOOL isAuthNameFinished = [AWGlobalDataManage shareinstance].isAuthNameFinished;
//    if (isAuthNameFinished && isApiFinished) {
//        [AWGlobalDataManage shareinstance].isAuthNameFinished = NO;
//        [AWGlobalDataManage shareinstance].isAuthNameFinished = NO;
//        [AWLoginViewManager showVersionUpdateWithUpdateInfo:updateData];
//    }
//}
//
////显示榜单
//+(void)judgeShowBannerRank:(NSArray *)advArr
//{
//    [self showOpenScreenWithData:advArr];
//}
//
////显示公告
//+(void)judgeShowAnnouce:(NSDictionary *)dataDict isFromApi:(BOOL)isApi
//{
//    NSString *type = @"";
//    NSString *title = @"";
//    NSString *content = @"";
//    NSString *btnText = @"";
//    NSString *btnUrl = @"";
//    NSString *freq = @"";
//    int isCloseServer = 0;
//
//    if (isApi) {
//        type = dataDict[@"type"];
//        title = dataDict[@"title"];
//        content = dataDict[@"content"];
//        btnText = dataDict[@"button_text"];
//        btnUrl = dataDict[@"button_jump"];
//        freq = dataDict[@"freq"];
//        isCloseServer = [dataDict[@"closeType"] intValue];
//    }
//
//
//    [AWLoginViewManager showAnnounceView:title content:content isClose:isCloseServer butText:btnText butJump:btnUrl freq:freq];
//}
//



//滚动消息结果
+(void)broadcastResultWithlist:(NSDictionary *)response
{
    if ([response[@"code"] intValue]== 200) {
        NSDictionary *dataDict = response[@"data"];
//        NSArray *arr = [response[@"data"] objectForKey:@"list"];
        NSArray *arr = [NSArray array];
        if (dataDict) {
            arr = [dataDict objectForKey:@"list"];
        }else{
            return;
        }
        
        [[AWBroadcastData shareinstance] setbroadlistdataWithArr:arr];
        if ([AWGlobalDataManage shareinstance].isCloseBroadcast) {
            return;    //如果是h5唤醒的话 在调用request之前修改bool
        }
        if ([AWGlobalDataManage shareinstance].isRedVenelope) {
            return;
        }
        if (arr.count<=0) {
            return;
        }
        [self showVroadcastView];
    }else{
        [AWTools makeToastWithText:response[@"msg"]];
        //如果已经打开就关闭广播
    }
}

//修改密码的回调
+(void)changePwdResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        [AWTools makeToastWithText:@"修改成功"];
        [AWLoginViewManager closeAllLoginview];
        NSDictionary *userInfo = response[@"data"];
        if (!userInfo) {
            return;
        }
        [AWConfig saveUserinfoToLoacl:userInfo]; //保存当前账号信息
        [AWConfig saveLoginAccount:userInfo]; //保存历史登录账号
    }else{
        [AWTools makeToastWithText:response[@"msg"]];
    }
}

//实名认证回调
+(void)realnameAuthResult:(NSDictionary *)response
{
    
}


//悬浮球gif回调
+(void)floatingballgifResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        NSDictionary *data = response[@"data"];
        //判断领取红包消息
        if ([data.allKeys containsObject:@"notice_msg"]) {
            NSArray *msgList = data[@"notice_msg"];
            if (msgList.count>0) {
                //有消息
                [AWGlobalDataManage shareinstance].redNevelopeCount += 1;
                if ([AWGlobalDataManage shareinstance].redNevelopeCount >3) {
                    return;
                }
                [self showRedNevelopeWithMsg:msgList[0]];
            }else{
                [AWGlobalDataManage shareinstance].redNevelopeCount = 0;
                [self closeRedVenelopeview];
            }
        }
        //判断里面的字段 是否gif显示悬浮球
        if ([data.allKeys containsObject:@"is_glitter"]) {
            BOOL isgif = [data[@"is_glitter"] intValue];
            if (isgif) {
                [AWLoginViewManager showGif];
            }
        }
    }else{
        // 不管
    }
}

//查询个人信息回调   主要是是否实名 和是否绑定手机
+(void)searchUserInfoResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        //  判断字段的值  再想想  实名和绑定  不能同意处理了
    }else{
        //不管
    }
}

//修改别名回调
+(void)aliasAccountResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        [AWLoginViewManager closeAllLoginview];
        [AWLoginViewManager refreshWebview];
        NSDictionary *userInfo = [AWConfig loadUserinfoFromLocal];
        if (!userInfo) {
            return;
        }
        NSMutableDictionary *mutabdict = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
        [mutabdict setValue:@1 forKey:@"is_cert"];
        [AWConfig saveUserinfoToLoacl:[mutabdict copy]]; //保存当前账号信息
        [AWConfig saveLoginAccount:[mutabdict copy]]; //保存历史登录账号
    }else{
        [AWTools makeToastWithText:response[@"msg"]];
    }
}
//绑定手机
+(void)bindPhoneResult:(NSDictionary *)response
{
    if ([response[@"code"] intValue]==200) {
        [AWLoginViewManager closeAllLoginview];
        [AWLoginViewManager refreshWebview];
        NSDictionary *userInfo = [AWConfig loadUserinfoFromLocal];
        if (!userInfo) {
            return;
        }
        NSMutableDictionary *mutabdict = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
        [mutabdict setValue:@1 forKey:@"is_cert"];
        [AWConfig saveUserinfoToLoacl:[mutabdict copy]]; //保存当前账号信息
        [AWConfig saveLoginAccount:[mutabdict copy]]; //保存历史登录账号
    }else{
        [AWTools makeToastWithText:response[@"msg"]];
    }
}


//充值榜单开屏页查询
+(void)getBannerRankRequest
{
    
    BOOL isshownameAuth =[AWGlobalDataManage shareinstance].isShowingNameAuth;
    BOOL isshowaddiction = [AWGlobalDataManage shareinstance].isShowingAddiction;
    BOOL isshowupdate = [AWGlobalDataManage shareinstance].isShowingUpdate;

    if (isshowupdate || isshowaddiction || isshownameAuth) {
        return;
    }
    
    if ([AWGlobalDataManage shareinstance].rankBannerCalled) {
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        return;
    }
    [AWGlobalDataManage shareinstance].rankBannerCalled = YES;
    
    
    [AWHTTPRequest AWBannerRankRequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

//充值榜单开屏页回调
+(void)bannerRankResultWithUserinfo:(NSDictionary *)response
{
    
//    //=======================
    NSLog(@"banner rank response=%@",response);
    if ([response[@"code"] intValue]==200) {
        NSArray *advArr = response[@"data"];
        if (advArr.count) {
            [self showOpenScreenWithData:advArr];
        }else{
            NSLog(@"没有");
        }
    }
}

+(void)showOpenScreenWithData:(NSArray *)advarr
{
//    NSMutableArray *testMuatbelArr = [NSMutableArray array];
//    NSDictionary *dict = advarr[0];
//    [testMuatbelArr addObject:dict];
//    [testMuatbelArr addObject:dict];
//    advarr = [testMuatbelArr copy];   //测试数据
    
    AWLoginActiveManager *Activemanager = [AWLoginActiveManager shareInstance];
    NSMutableArray *mutableScreendata = [NSMutableArray array];
    for (int i=0; i<advarr.count; i++) {
        AWScreenModel *model = [AWScreenModel new];
        [model configWithdict:advarr[i] andNum:i andTotal:(int)advarr.count];
        [mutableScreendata addObject:model];
    }
    NSArray *activeScreenArr = [[mutableScreendata reverseObjectEnumerator] allObjects];
    Activemanager.ScreenModelArr = activeScreenArr;
    [Activemanager showLoginActive];
}

//谷歌登录回调  这里谷歌验证失败的话 需要调用signout
+(void)googleLoginResultWithUserInfo:(NSDictionary *)response
{
    if ([response[@"code"] intValue] == 200) {
        [self loginResultWithUserinfo:response type:1];
    }else{
        
    }
}

//登录结果  //开启定时器
+(void)loginResultWithUserinfo:(NSDictionary *)response type:(NSInteger)type
{
// 快速登录失败 拉起登录界面
    if ([response[@"code"] intValue] == 200) {
        [self loginSuccessWithUserInfo:[response objectForKey:@"data"] AndType:type];
    }else{
        if (type == 3) {
            //吊起其他的登录界面
            [AWLoginViewManager otherLogin];
            return;
        }
        if ([AWSDKConfigManager shareinstance].switch_data_is_fast_login) {
            //快速登录 失败重新拉起登录界面
            [AWLoginViewManager otherLogin];
            return;
        }
        [self loginFailWithMes:response[@"msg"]];
    }
}

//微信登录成功
/*
 data =     {
     account = 200119365035;
     alias = "";
     "is_bind_mobile" = 0;
     "is_cert" = 0;
     mobile = 0;
     "new_user" = 0;
     "nick_name" = "";
     pwd = dcb2af8b07f5e1b1c7e2a34342d7dc1d;
     "show_account" = 200119365035;
     token = Nwle8nyzMiDAxMTkzNl8xNjE0ODUwNzEwX3Nkazk5OTk5OTkO0O0O;
     type = "LOGIN_WEIXIN";
 };
 */



+(void)loginSuccessWithUserInfo:(NSDictionary *)userInfo AndType:(NSInteger)type
{
    //报登录
//    NSDictionary *properties = @{@"login_type":userInfo[@"type"]};
//    [AWDataReport saveEventWittEvent:@"sys.login" properties:properties];
//    if ([userInfo.allKeys containsObject:@"new_game_user"] && [userInfo[@"new_game_user"] intValue]==1) {
//        //报注册
//        NSDictionary *properties = @{@"register_type":userInfo[@"type"]};
//        [AWDataReport saveRegisterEventWittEvent:@"sys.register" properties:properties timestamp:userInfo[@"new_game_user_regtime"]];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[AWGlobalDataManage shareinstance] reportLocalDataWithTime:0];
//        });
//    }
    [AWGlobalDataManage shareinstance].alreadyLogin = YES;
    
    
    [AWConfig saveUserinfoToLoacl:userInfo]; //保存当前账号信息
    
    if ([userInfo[@"new_user"] intValue]) {
        [AWEventReportManager reg];
    }else{
        [AWEventReportManager login];
    }
    
    [AWConfig saveLoginAccount:userInfo]; //保存历史登录账号
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"account"] forKey:SDKUSERACCOUNTFIELD];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [AWGlobalDataManage shareinstance].currentAccount = userInfo[@"account"];
//    [AW]
    //关闭窗口  //是否弹出其他窗口(实名认证不是马上弹 启动定时器 指定时间弹出来一次)  回调CP
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awloginresult" object:self userInfo:userInfo];
    
    
    BOOL switchindulge =[AWSDKConfigManager shareinstance].name_auth_is_open;
    BOOL isRealnamed = ![userInfo[@"is_cert"] intValue];
    BOOL isShouldShowAuth = switchindulge && isRealnamed;
    
    if ([userInfo[@"type"] isEqualToString:LOGIN_VISITOR]) {
        if ([userInfo.allKeys containsObject:@"new_user_pwd"]) {
            NSString *new_user_pwd = userInfo[@"new_user_pwd"];
            if (new_user_pwd.length>0) {
                NSString *account = userInfo[@"show_account"];
                NSString *showPwd = [userInfo objectForKey:@"new_user_pwd"];
                showPwd = [AWTools decryptBase64StringToString:showPwd stringKey:[AWConfig CurrentAppKey]];
                AWFastAccountView *view = [AWFastAccountView facory_fastAccountviewWithAcooun:account andPwd:showPwd];
//                [AWTools saveFastaccountScreentWithView:view];
            }

        }
    }
    [self beginShowViewWithUserInfo:userInfo];
    
//    //检测更新
//    [self checkVersion];
//    //从这里发公告
//
//    [AWGlobalDataManage shareinstance].notice_semaphore = dispatch_semaphore_create(0);
//    dispatch_queue_t notice_queue = dispatch_queue_create("notice_queue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(notice_queue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self requestAnnounce];
//        });
//    });
//
//    dispatch_async(notice_queue, ^{
//        //等待信号再执行
//        dispatch_semaphore_wait([AWGlobalDataManage shareinstance].notice_semaphore, DISPATCH_TIME_FOREVER);
//        //检测版本
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loginsuccessUIIsShowRealnameAuth:isShouldShowAuth andType:type userinfo:userInfo];
//        });
//
//    });
    [self loginsuccessUIIsShowRealnameAuth:isShouldShowAuth andType:type userinfo:userInfo];

}

//请求公告
+(void)requestAnnounce
{
    [AWHTTPRequest AWNoticeInfoRequestIfSuccess:^(id  _Nonnull response) {
        if ([response[@"code"] intValue] == 200) {
            NSDictionary *dataDict = response[@"data"];
            if (dataDict && ![dataDict isMemberOfClass:[NSNull class]]) {
                NSLog(@"xxxxx");
                NSString *type = dataDict[@"type"];
                NSString *title = dataDict[@"title"];
                NSString *content = dataDict[@"content"];
                NSString *btnText = dataDict[@"button_text"];
                NSString *btnUrl = dataDict[@"button_jump"];
                NSString *freq = dataDict[@"freq"];
                
                if (!btnUrl || [btnUrl isKindOfClass:[NSNull class]]) {
                    btnUrl = @"";
                }
                
                NSArray *typeArr = @[@"NORMAL",@"CLOSE_SERVER",@"JUMP"];
                int isCloseServer = 0;
                if ([typeArr containsObject:type]) {
                    if ([type isEqualToString:@"CLOSE_SERVER"]) {
                        isCloseServer = 1;
                    }else if ([type isEqualToString:@"JUMP"]){
                        isCloseServer = 2;
                    }
                    
                    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:dataDict];
                    [mutabDict setValue:btnUrl forKey:@"button_jump"];
                    [mutabDict setValue:@(isCloseServer) forKey:@"closeType"];
                    
                    [AWLoginViewManager showAnnounceView:title content:content isClose:isCloseServer butText:btnText butJump:btnUrl freq:freq];
                    return;
                }
            }
        }
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
    } failure:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
    }];
}

//版本更新检测
+(void)checkVersion
{
    
    BOOL isshownameAuth =[AWGlobalDataManage shareinstance].isShowingNameAuth;
    BOOL isshowaddiction = [AWGlobalDataManage shareinstance].isShowingAddiction;
    BOOL isshowupdate = [AWGlobalDataManage shareinstance].isShowingUpdate;
    
    
    if (isshowupdate || isshowaddiction || isshownameAuth) {
        return;
    }
    
    if ([AWGlobalDataManage shareinstance].updateCalled) {
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        return;
    }
    
    [AWGlobalDataManage shareinstance].updateCalled = YES;
    
    [AWHTTPRequest AWCheckVersionRequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}



//这边处理关闭窗口 展示欢迎界面（刷新token的时候 1.5秒） 显示悬浮球 显示轮播 显示实名认证（同一次启动只调用一次，在欢迎界面显示完之后）
+(void)loginsuccessUIIsShowRealnameAuth:(BOOL)isShowrealName andType:(NSInteger)type userinfo:(NSDictionary *)userinfo
{
    //上报token
    [AWSocketManager sendToken];
    //上报用户信息
    if ([AWSDKConfigManager shareinstance].is_role_report) {
        AWRoleInfoModel *roleInfo = [AWRoleInfoModel new];
        roleInfo.reportType = @"entersvr";
        roleInfo.level = 0;
        [AWSDKApi roleInfoReport:roleInfo];
    }
    
    
    [AWLoginViewManager closeAllLoginview];
    //show 欢迎view 刷新token才显示
    if ([AWSDKConfigManager shareinstance].broadcast_is_open) {
        [self requestBroadcastdata];
        [[AWGlobalDataManage shareinstance] createBoradCastTimer];
    }
    if ([AWSDKConfigManager shareinstance].switch_data_is_float) {
        [AWLoginViewManager showFloatingBall];
        //查询悬浮球状态的去掉
//        [[AWGlobalDataManage shareinstance] createFloatingTimer];
    }
    
    [AWGlobalDataManage shareinstance].isShowedRealnameAuth = YES;
    

    if (type == 3) {
        
        NSString *loginType = userinfo[@"type"];
        if ([AWSDKConfigManager shareinstance].switch_data_is_show_login) {
            [AWLoginViewManager showWelcomeViewAccount:userinfo[@"show_account"] andType:loginType];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AWLog(@"after---%@",[NSThread currentThread]);
//            [self showRednevelope];
//            [AWLoginViewManager showRealNameAuth];
            
            if (![AWGlobalDataManage shareinstance].isClickQiehuanBtn) {
//                if (isShowrealName && ![AWGlobalDataManage shareinstance].isShowedRealnameAuth) {
//                    [AWGlobalDataManage shareinstance].isShowedRealnameAuth = YES;
//                    [AWLoginViewManager showRealNameAuth];
//                    [[AWGlobalDataManage shareinstance] createRealnameAuthTimer];
//                }
            }
        });
    }else{
        if (isShowrealName && ![AWGlobalDataManage shareinstance].isShowedRealnameAuth) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self showRednevelope];
                AWLog(@"after---%@",[NSThread currentThread]);
                if (![AWGlobalDataManage shareinstance].isClickQiehuanBtn) {
//                    if (isShowrealName && ![AWGlobalDataManage shareinstance].isShowedRealnameAuth) {
//                        [AWGlobalDataManage shareinstance].isShowedRealnameAuth = YES;
////                        [AWLoginViewManager showRealNameAuth];
////                        [[AWGlobalDataManage shareinstance] createRealnameAuthTimer];
//                    }
                }
            });
        }
    }

}


+(void)showRednevelope
{
    //本地保存  一个设备一个应用只显示一次 是否显示过web页
    NSLog(@"banner===%d",[AWSDKConfigManager shareinstance].switch_data_is_show_bannel);
        if ([AWSDKConfigManager shareinstance].switch_data_is_show_bannel && [AWSDKConfigManager shareinstance].switch_data_is_float) {
            if ([AWTools isFirstInstallShowRebNevelope] && [AWGlobalDataManage shareinstance].isShowedWeb) {
                [AWLoginViewManager showRedNevelopeView];
//                if (![AWGlobalDataManage shareinstance].isShowedWeb) {
//                    NSLog(@"show");
//                    [AWLoginViewManager showRedNevelopeView];
//                }
            }
        }
}

+(void)requestBroadcastdata
{
    [AWHTTPRequest AWBroadcastRequestWithH5:NO IfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}
//显示滚动消息
+(void)showVroadcastView
{
    AWLog(@"showBroadcastview");
    [[AWViewManager shareInstance] showAdLabWithArr:[AWBroadcastData shareinstance].broadList];
}
//显示领取红包
+(void)showRedNevelopeWithMsg:(NSDictionary *)dict
{
    AWLog(@"show rednevelope");
    [[AWViewManager shareInstance] showredEnvelopeViewWithTitle:dict];
}
//关闭领取红包
+(void)closeRedVenelopeview
{
    [[AWViewManager shareInstance] clickCloseRedNevelope];
}

+(void)loginFailWithMes:(NSString *)msg
{
    [AWTools makeToastWithText:msg];
}

+(void)changeLoginStatus:(BOOL)loginstatus
{
    NSNumber *status = loginstatus?@1:@0;
    [AWConfig changeLoginSTatus:status];
}
@end
