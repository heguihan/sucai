//
//  AWWebBridge.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/12.
//

#define CHANGELOGIN                     @"changeLogin"
#define CHANGEPASSWORD                  @"changePassword"
#define CERTIFICATION                   @"certification"
#define BINDPHONE                       @"bindPhone"
#define LOGINFAILURE                    @"loginFailure"
#define OPENBROWSER                     @"openBrowser"
#define REPORTEVENT                     @"reportEvent"
#define RESETLOGFLAG                    @"resetLogFlag"
#define BINDWX                          @"bindWX"
#define STARTAPPLICATION                @"startApplication"    //暂时没用了

#define SETACCOUNTALIAS                 @"setAccountAlias"
#define TOAST                           @"toast"
#define SHOWHINTMSG                     @"showHintMsg"
#define QUERYROLLMSG                    @"queryRollMsg"
#define CLOSEFLOATING                   @"closeFloatBall"
#define SHOWFLOATING                    @"showFloatBall"
#define SYNCPWD                         @"syncPassWord"
#define REALNAMEAUTH                    @"isCertification"
#define SHARELINKTOWEIXIN               @"weChatShareUrl"
#define SHAREPICTOWEIXIN                @"weChatSharePicture"
#define CALLBACKURL                     @"callBackFloatUrl"         //h5返回路由
#define SENDEMAIL                       @"sendEmail"
#define STARTTEL                        @"startTel"


#import "AWWebBridge.h"
#import "AWBindWechat.h"
#import "HGHShowBall.h"



@implementation AWWebBridge
+(void)test:(id)arg
{
    AWLog(@"test%s",__func__);
}
+(void)share:(id)args
{
    AWLog(@"%@%s",TAG_H5_JS,__func__);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    if ([args isEqualToString:@"weixin"]) {
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            [AWTools makeToastWithText:@"没有安装 微信,请先安装"];
        }
        NSString *content = [AWTools getPastedContent];
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                AWLog(@"跳转成功");
//            }else{
//
//            }
//        }];
        return;
    }
    if ([args isEqualToString:@"qq"]) {
        NSURL *url = [NSURL URLWithString:@"mqq://"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            [AWTools makeToastWithText:@"没有安装 QQ,请先安装"];
        }
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                AWLog(@"跳转成功");
            }else{
            }
        }];
        return;
    }
    if ([args isEqualToString:@"weibo"]) {
        //sinaweibo
        NSURL *url = [NSURL URLWithString:@"sinaweibo://"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            [AWTools makeToastWithText:@"没有安装 微博,请先安装"];
        }
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                AWLog(@"跳转成功");
            }else{
            }
        }];
        return;
    }
}

+(void)changeLogin:(id)args
{
    AWLog(@"%s",__func__);
    [AWLoginViewManager switchAccount];
}

+(void)changePassword:(id)args
{
    AWLog(@"%s",__func__);
    [AWLoginViewManager showChangePwd];
}

+(void)certification:(id)args
{
    AWLog(@"%s",__func__);
//    [AWLoginViewManager showRealNameAuth];
}

+(void)bindPhone:(id)args
{
    AWLog(@"%s",__func__);
    [AWLoginViewManager showBindPhoneWithBack:YES];
}

+(void)loginFailure:(id)args
{
    AWLog(@"%s",__func__);
    [AWLoginViewManager switchAccount];
}

+(void)openBrowser:(id)args
{    //打开浏览器
    AWLog(@"%s",__func__);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:args] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                //
            }else{
                [AWTools makeToastWithText:[NSString stringWithFormat:@"打开浏览器失败%@",args]];
            }
    }];
}

+(void)reportEvent:(id)args
{
    AWLog(@"%s",__func__);
    AWLog(@"args=%@",args);
    if ([args isKindOfClass:[NSDictionary class]]) {
        AWLog(@"dict=%@",args);
//        [AWDataReport saveDataViewEnent:args];
        [AWDataReport saveDataDelayReportEvent:args];
    }
    if ([args isKindOfClass:[NSString class]]) {
        AWLog(@"nsstring");
        NSDictionary *dict = [AWTools jsonStrtodictWithStr:args];
        AWLog(@"wacaca==%@",dict);
//        [AWDataReport saveDataViewEnent:dict];
        [AWDataReport saveDataDelayReportEvent:dict];
    }
}

+(void)resetLogFlag:(id)args
{
    AWLog(@"%s",__func__); //不要了
} 


+(void)closeFloatBall:(id)args
{
    AWLog(@"%s",__func__); //关闭悬浮球
    [HGHShowBall hiddenWindow];
    
}

//showFloatBall
+(void)showFloatBall:(id)args
{
    AWLog(@"%s",__func__); //显示悬浮球
    [HGHShowBall unHiddenWindow];
}

+(void)bindWX:(id)args
{
    AWLog(@"%s",__func__);
    [AWGlobalDataManage shareinstance].isWeixinLogin = NO;
    [AWBindWechat bindWeiChat];
}

+(void)startApplication:(id)args
{
    AWLog(@"%s args=%@",__func__,args);
    NSArray *arr = args;
    if (arr.count==2) {
        NSString *schem = [NSString stringWithFormat:@"%@://",arr[0]];
        NSString *downLoad = arr[1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schem] options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    AWLog(@"open browes");
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoad] options:@{} completionHandler:^(BOOL success) {
                            if (success) {
                                NSLog(@"dakai成功");
                            }
                    }];
                }
        }];
    }
    if (arr.count==1) {
        NSString *urlstr = [NSString stringWithFormat:@"%@://",arr[0]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr] options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"dakai成功");
                }
        }];
    }
    NSLog(@"end");
}

+(void)setAccountAlias:(id)args
{
    AWLog(@"%s",__func__);
    [AWLoginViewManager showAlias];
}

+(void)toast:(id)args
{
    AWLog(@"%s",__func__);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    [AWTools makeToastWithText:args];
}

+(void)showHintMsg:(id)args
{
    AWLog(@"%s",__func__);
    //show一个页面还没做 配置信息
    [AWLoginViewManager showHinMsg];
}

+(void)queryRollMsg:(id)args
{
    AWLog(@"%s",__func__);
    //滚动消息  领取红包之类的调用
    [AWGlobalDataManage shareinstance].isCloseBroadcast = NO;
    if ([AWGlobalDataManage shareinstance].redNevelopeCount>3) {
        [AWGlobalDataManage shareinstance].redNevelopeCount = 0;
    }
    [AWHTTPRequest AWBroadcastRequestWithH5:YES IfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}


+(void)syncPassWord:(id)args
{
    
    //25d55ad283aa400af464c76d713c07ad
    AWLog(@"%s, args=%@",__func__, args);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    [AWConfig changePwd:args];
    
}

+(void)isCertification:(id)args
{
    NSLog(@"isCertification h5==%@",args);
}
/*
 (
     "http://share.tavernello.net/?app_id=119&c=gbg4zk5",
     "",
     "\U4e00\U4e2a\U7eb8\U724c\U6e38\U620f\U9002\U7528\U4e8e\U4efb\U4f55\U5e74\U9f84\Uff0c\U5982\U679c\U4f60\U559c\U6b22\U5361\U724c\U6e38\U620f\Uff0c\U6e38\U620f\U5e26\U7ed9\U4f60\U65e0\U7a77\U7684\U4e50\U8da3\Uff0c\U6311\U6218\Uff0c\U662f\U5b8c\U5168\U514d\U8d39\U7684\Uff01",
     0
 )
 */
+(void)weChatShareUrl:(id)args
{
    NSString *url = @"";
    NSString *title = @"";
    NSString *description = @"";
    int toWeChatType = 0;
    if ([args isKindOfClass:[NSDictionary class]]) {
        AWLog(@"dict=%@",args);
        url = args[@"url"];
        title = args[@"title"];
        description = args[@"description"];
        toWeChatType = [args[@"toWeChatType"] intValue];
    }
    if ([args isKindOfClass:[NSString class]]) {
        AWLog(@"nsstring");
        NSDictionary *dict = [AWTools jsonStrtodictWithStr:args];
        url = dict[@"url"];
        title = dict[@"title"];
        description = dict[@"description"];
        toWeChatType = [dict[@"toWeChatType"] intValue];
    }
    if ([args isKindOfClass:[NSArray class]]) {
        url = args[0];
        title = args[1];
        description = args[2];
        toWeChatType = [args[3] intValue];
    }
    if (description && [description length]>0) {
        description = url;
    }
    

}

+(void)weChatSharePicture:(id)args
{
    NSString *url = @"";
    NSString *title = @"";
    NSString *description = @"";
    int toWeChatType = 0;
    if ([args isKindOfClass:[NSDictionary class]]) {
        AWLog(@"dict=%@",args);
        url = args[@"url"];
        title = args[@"title"];
        description = args[@"description"];
        toWeChatType = [args[@"toWeChatType"] intValue];
    }
    if ([args isKindOfClass:[NSString class]]) {
        AWLog(@"nsstring");
        NSDictionary *dict = [AWTools jsonStrtodictWithStr:args];
        url = dict[@"url"];
        title = dict[@"title"];
        description = dict[@"description"];
        toWeChatType = [dict[@"toWeChatType"] intValue];
    }
    if ([args isKindOfClass:[NSArray class]]) {
        url = args[0];
        toWeChatType = [args[1] intValue];
    }

}

+(void)callBackFloatUrl:(id)args
{
    if ([args isKindOfClass:[NSString class]]) {
        //保存字符串
        [AWGlobalDataManage shareinstance].redpackageUrl = args;
    }else if ([args isKindOfClass:[NSArray class]]){
        [AWGlobalDataManage shareinstance].redpackageUrl = args[0];
    }
}

+(void)syncBindPhone:(id)args
{
    AWLog(@"%s, args=%@",__func__, args);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
//    [AWConfig changePwd:args];
    [[AWUserInfoManager shareinstance] setMobile:args];
    [[AWUserInfoManager shareinstance] setIs_bind_mobile:YES];
}


static BOOL _isClicked = NO;
+(void)sendEmail:(id)args
{
    if (_isClicked) {
        return;
    }
    _isClicked = YES;
    NSTimeInterval delay = 0.5;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){ _isClicked = NO; });
    AWLog(@"%s, args=%@",__func__, args);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    args = [NSString stringWithFormat:@"mailto:%@",args];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:args] options:@{} completionHandler:^(BOOL success) {
        //
    }];
}



+(void)startTel:(id)args
{
    if (_isClicked) {
        return;
    }
    _isClicked = YES;
    NSTimeInterval delay = 0.5;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){ _isClicked = NO; });
    
    AWLog(@"%s, args=%@",__func__, args);
    if ([args isKindOfClass:[NSArray class]]) {
        args = args[0];
    }
    if (args) {
        [AWTools telWithPhoneNO:args];
    }
}
@end
