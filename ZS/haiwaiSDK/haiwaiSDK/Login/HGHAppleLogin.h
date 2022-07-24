//
//  HGHAppleLogin.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/11/22.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
API_AVAILABLE(ios(13.0))
NS_ASSUME_NONNULL_BEGIN

@interface HGHAppleLogin : NSObject<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
+(instancetype)shareinstance;
-(void)HGHsignInWithApple;
@end

NS_ASSUME_NONNULL_END
