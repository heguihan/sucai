//
//  AWAppleLogin.h
//  AWSDKDemo
//
//  Created by admin on 2021/7/19.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
API_AVAILABLE(ios(13.0))
NS_ASSUME_NONNULL_BEGIN


@interface AWAppleLogin : NSObject<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
+(instancetype)shareInstance;
-(void)signinWithApple;
@end

NS_ASSUME_NONNULL_END
