//
//  AWFacebookLogin.h
//  AWSDKDemo
//
//  Created by admin on 2022/1/7.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AWFacebookLogin : NSObject<FBSDKSharingDialog,FBSDKSharingDelegate>
+(instancetype)shareinstance;

-(void)facebookLogin;

-(void)facebookShare;

-(void)facebookInvite;
@end

NS_ASSUME_NONNULL_END
