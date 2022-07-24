//
//  HGHGoogleLoginViewController.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHGoogleLoginViewController.h"
#import "HGHTools.h"
#import "HGHHttprequest.h"
#import "HGHAccessApi.h"
#import "HGHTools.h"
#import "HGHFlyer.h"
@interface HGHGoogleLoginViewController ()

@end

@implementation HGHGoogleLoginViewController

+(instancetype)shareinstance
{
    static HGHGoogleLoginViewController *google = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        google = [[HGHGoogleLoginViewController alloc]init];
    });
    return google;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view]
//    self.view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 500, 300)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self googleLogin];
//    [self test];
}
-(void)test
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)googleLogin
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;

    [[GIDSignIn sharedInstance] signIn];
}


/*
 userID=106785560452081946928, idToken=eyJhbGciOiJSUzI1NiIsImtpZCI6IjI4ZjU4MTNlMzI3YWQxNGNhYWYxYmYyYTEyMzY4NTg3ZTg4MmI2MDQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI5ODQ0NDUzMzc2NDUtdDNhNmE0aTgzcXN1cnI2Z3NsZmcxZ2IydDB1Z2IxcjQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI5ODQ0NDUzMzc2NDUtdDNhNmE0aTgzcXN1cnI2Z3NsZmcxZ2IydDB1Z2IxcjQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDY3ODU1NjA0NTIwODE5NDY5MjgiLCJlbWFpbCI6Imxhbmd4aWFveWkyMDE2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiNVo2RGRPeERrVHJSb1RoMF9mZEw5USIsIm5hbWUiOiLkvZXlnK3pn6kiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy02aFZ6X0pDZGNDVS9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BQ0hpM3JkQ3VlN29RaVU3Q3UxRGF6MjhtRDBzOXpBQnBnL3M5Ni1jL3Bob3RvLmpwZyIsImdpdmVuX25hbWUiOiLlnK3pn6kiLCJmYW1pbHlfbmFtZSI6IuS9lSIsImxvY2FsZSI6InpoLUNOIiwiaWF0IjoxNTU3MTk5MzA5LCJleHAiOjE1NTcyMDI5MDl9.Q4bbLZaRkUwadfzDMBGFXTXPdhPxvJCyRVTkHwDDUvqCBS18bBJ-bFxUlNNrdACCuJ96jE2Ke5l-eoZOWmRFShA8WtzyZa6qJL0-eCeJ7iyeTGwv9qp7iun9BNQT2NNEiGGq2vmiuur-r49Cwi76WggqiKbLGDpliD4A6c3RRmt_zVBmwJvsHCM-xEahHrGmZWlQkWkeKxCgmgKaM-PMcyPbrcMJSkMsdUR5JWcWcvgZVQ4MMZiu_tZvKQam6KQ5s-hQV_yDYfPI2hgJddlScq0zc1TgELVGODe3sca5IgVsbO47fVEIxAL_eKM1ivACOwRXPjH_ZveSubDC20gpGw, fullName=何圭韩, givenName=圭韩,familyName=何, email=langxiaoyi2016@gmail.com
 */

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
    
    if (self.islogin) {
        [[HGHHttprequest shareinstance] thirdLoginWithuuid:[HGHTools getUUID] type:@"3" tp:@"gp" tpToken:idToken ifSuccess:^(id  _Nonnull response) {
            [HGHFlyer FlyersReportEvent:@"register" params:@{@"loginType":@"Google"}];
            NSLog(@"response=%@",response);
            [HGHAccessApi shareinstance].loginBackBlock(response);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error=%@",error);
        }];
    }else
    {
        [HGHAccessApi shareinstance].bindBackBlock(idToken);
    }
    

    
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
