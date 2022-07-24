//
//  AWGoogleViewController.m
//  AWSDKDemo
//
//  Created by admin on 2022/1/7.
//

#import "AWGoogleViewController.h"

@interface AWGoogleViewController ()

@end

@implementation AWGoogleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self googleLogin];
}



-(void)googleLogin
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;

    [[GIDSignIn sharedInstance] signIn];
}



- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    [self dismissViewControllerAnimated:NO completion:nil];
    if (error) {
        NSLog(@"error=%@",error);
        NSLog(@"失败了xxxxxxxxxxx");
        [[GIDSignIn sharedInstance] signOut];
        return;
    }
    
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSLog(@"userID=%@, idToken=%@, fullName=%@, givenName=%@,familyName=%@, email=%@",userId,idToken,fullName,givenName,familyName,email);
    NSLog(@"finished");
    
    [AWHTTPRequest AWOUTSEAloginRequest:idToken loginType:@"LOGIN_GOOGLE" ifSuccess:^(id  _Nonnull response) {
        NSLog(@"response facebook ==%@",response);
    } failure:^(NSError * _Nonnull error) {
        //
    }];

//        [[HGHHttprequest shareinstance] thirdLoginWithuuid:[HGHTools getUUID] type:@"3" tp:@"gp" tpToken:idToken ifSuccess:^(id  _Nonnull response) {
//            [HGHFlyer FlyersReportEvent:@"register" params:@{@"loginType":@"Google"}];
//            NSLog(@"response=%@",response);
//            [HGHAccessApi shareinstance].loginBackBlock(response);
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"error=%@",error);
//        }];
   
    

    
    // ...
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
