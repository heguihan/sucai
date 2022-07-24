//
//  AWGoogleLogin.m
//  AWSDKDemo
//
//  Created by admin on 2022/1/7.
//

#import "AWGoogleLoginManager.h"
#import "AWGoogleViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

@implementation AWGoogleLoginManager
+(void)googleLogin
{
    AWGoogleViewController *gvc = [[AWGoogleViewController alloc]init];;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:gvc];
    
    [[AWTools getCurrentVC] presentViewController:navi animated:NO completion:nil];
}

+(void)googleSignOut
{
    [[GIDSignIn sharedInstance] signOut];
}
@end
