//
//  HGHFacebookLogin.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/21.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHFacebookLogin : NSObject<FBSDKSharingDialog,FBSDKSharingDelegate>

+(instancetype)shareinstance;

-(void)facebookLogin:(BOOL)islogin;

-(void)facebookShare;

-(void)facebookInvite;
@end

NS_ASSUME_NONNULL_END
