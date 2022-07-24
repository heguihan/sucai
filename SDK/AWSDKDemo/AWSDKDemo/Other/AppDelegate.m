//
//  AppDelegate.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//



#import "AppDelegate.h"
#import "SignalHandler.h"
#import "UncaughtExceptionHandler.h"
#import "AWMaiSuccessResult.h"
#import "AWMaiResult.h"

#import "AWSDKApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    InstallUncaughtExceptionHandler();
    // 424326371859-6adteo4eg938k6tdt802pufec0nfu6f3.apps.googleusercontent.com
//    [GIDSignIn sharedInstance].clientID=@"424326371859-6adteo4eg938k6tdt802pufec0nfu6f3.apps.googleusercontent.com";
    
//    GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:@"YOUR_IOS_CLIENT_ID"];
    
    [GIDSignIn sharedInstance].delegate = self;
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"did become active");
    [AWMaiResult searchOrderIDWithToast:NO];
    [AWSDKApi applicationDidBecomeActive:application];
    //查询订单
}
//
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL google = [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return [AWSDKApi application:app openURL:url options:options];

}


//
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
        return [AWSDKApi application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}
//

//-(void) onReq:(BaseReq*)reqonReq
//{
//    NSLog(@"weixin request===%@",reqonReq);
//}
//
//-(void)onResp:(BaseResp*)resp
//{
//    NSLog(@"weixin response===%@",resp);
//    if([resp isKindOfClass:[SendAuthResp class]]){
//        SendAuthResp *resp2 = (SendAuthResp *)resp;
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONWEIXINBIND object:resp2];
//    }
//    if ([resp isKindOfClass:[PayResp class]]) {
//        NSLog(@"errorCode===%d",resp.errCode);
//        [AWLoginViewManager showMaiResultView];
//        switch (resp.errCode) {
//            case WXSuccess:
//                [AWMaiSuccessResult maiResultWithType:@"weixin"];
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"awmairesultnotice" object:nil userInfo:@{@"payType":@"weixin",@"status":@"success"}];
//                break;
//                
//            default:
//                [AWTools makeToastWithText:resp.errStr];
//                break;
//        }
//    }
//}

@end
