//
//  HGHGoogleLoginViewController.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHGoogleLoginViewController : UIViewController<GIDSignInDelegate,GIDSignInUIDelegate>
//+(void)googleLogin;
+(instancetype)shareinstance;
@property(nonatomic,assign)BOOL islogin;
@end

NS_ASSUME_NONNULL_END
