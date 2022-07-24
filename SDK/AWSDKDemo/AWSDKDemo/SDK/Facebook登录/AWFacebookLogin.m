//
//  AWFacebookLogin.m
//  AWSDKDemo
//
//  Created by admin on 2022/1/7.
//

#import "AWFacebookLogin.h"

@implementation AWFacebookLogin


+(instancetype)shareinstance
{
    static AWFacebookLogin *fb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fb = [[AWFacebookLogin alloc]init];
    });
    
    return fb;
}



/*
 appid = 460656767708214, token=EAAGi9wMArDYBAGZCZCfatDvfrBm22FGPhaT9Ubfif1P4GuzoYUPtVohIZADH06AfRdJqzzA35UFEBkAd0ZC5GpTO1ZCEosycZA1JmG1ZCw6xWUbREwh7F3FgSUTgZBRmVPjXQ6qLZCRUiP0NTaetNKzhmUBfCzZCRk4za9ZCU62qXevd5vgUE9kqqTRC42fxcIsfdY7nx9BBA4SkeAk1Pd4FolT2H9Ws1BGrvM42xZBiPjm9NQZDZD,userid=140468500154233,permission={(
 email,
 "public_profile",
 "user_friends"
 )}
 */
-(void)facebookLogin
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    
    if ([FBSDKAccessToken currentAccessToken]!=nil) {
        [login logOut];
    }
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    UIViewController *currentvc = [AWTools getCurrentVC];
    [login logInWithPermissions:@[@"public_profile",@"user_friends",@"email"] fromViewController:currentvc handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"process error");
        }else if (result.isCancelled){
            NSLog(@"Cancelled");
        }else{
            NSLog(@"success logged in");
            FBSDKAccessToken *token = result.token;
            NSString *appid = token.appID;
            NSString *stringToken = token.tokenString;
            NSString *userid = token.userID;
            NSSet *permission = token.permissions;
            NSLog(@"appid = %@, token=%@,userid=%@,permission=%@",appid,stringToken,userid,permission);
            NSLog(@"token=%@",token);
            NSLog(@"result=%@",result);
            
            
            
//            [[HGHHttprequest shareinstance] thirdLoginWithuuid:[HGHTools getUUID] type:@"3" tp:@"fb" tpToken:stringToken ifSuccess:^(id  _Nonnull response) {
//                [HGHFlyer FlyersReportEvent:@"register" params:@{@"loginType":@"Facebook"}];
//                NSLog(@"response=%@",response);
//                [HGHAccessApi shareinstance].loginBackBlock(response);
//            } failure:^(NSError * _Nonnull error) {
//                NSLog(@"error=%@",error);
//            }];
            //LOGIN_FACEBOOK
            [AWHTTPRequest AWOUTSEAloginRequest:stringToken loginType:@"LOGIN_FACEBOOK" ifSuccess:^(id  _Nonnull response) {
                NSLog(@"response facebook ==%@",response);
            } failure:^(NSError * _Nonnull error) {
                //
            }];
            
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"name,id",@"fields",
                                           nil];
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"me"
                                          parameters:params
                                          HTTPMethod:@"GET"];
            
            /*
             result={
             id = 140468500154233;
             name = "He Guihan";
             }
             */
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                NSLog(@"result=%@",result);
                NSLog(@"get it");
            }];
            
            
        }
    }];
}



#pragma --mark  facebook 新功能
-(void)facebookShare;
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    
    content.contentURL = [NSURL URLWithString:@"https://www.baidu.com"];

    content.quote = NSLocalizedString(@"Share_Message", nil);


    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];

    dialog.shareContent = content;

    dialog.fromViewController = self;

    dialog.delegate = self;

    dialog.mode = FBSDKShareDialogModeNative;

    [dialog show];

}

-(void)facebookInvite
{
   
}


@end
