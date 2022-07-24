//
//  HGHAppleLogin.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/11/22.
//  Copyright © 2019 Lucas. All rights reserved.
//

#define APPLEUSERID @"hghsigninwithappleuser"
#import "HGHHttprequest.h"
#import "HGHAppleLogin.h"
#import "HGHTools.h"
#import "HGHFlyer.h"
#import "HGHAccessApi.h"
@implementation HGHAppleLogin
+(instancetype)shareinstance
{
    static HGHAppleLogin *apple = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apple = [[HGHAppleLogin alloc]init];
    });
    
    return apple;
}

-(void)HGHsignInWithApple
{
    [self observeAuthticationState];
}

- (void)observeAuthticationState {
    
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        // 基于用户的Apple ID 生成授权用户请求的机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        // 注意 存储用户标识信息需要使用钥匙串来存储 这里笔者简单期间 使用NSUserDefaults 做的简单示例
        NSString *userIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:APPLEUSERID];
        
        if (userIdentifier) {
            NSString* __block errorMsg = nil;
            //Returns the credential state for the given user in a completion handler.
            // 在回调中返回用户的授权状态
            [appleIDProvider getCredentialStateForUserID:userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
                switch (credentialState) {
                        // 苹果证书的授权状态
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        // 苹果授权凭证失效
                        errorMsg = @"苹果授权凭证失效";
                        [self appleLogin];
                        break;
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        // 苹果授权凭证状态良好
                        errorMsg = @"苹果授权凭证状态良好";
                        [self perfomExistingAccountSetupFlows];
                        break;
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        // 未发现苹果授权凭证
                        errorMsg = @"未发现苹果授权凭证";
                        [self appleLogin];
                        // 可以引导用户重新登录
                        break;
                    case ASAuthorizationAppleIDProviderCredentialTransferred:
                        errorMsg = @"苹果授权凭证转移";
                        [self appleLogin];
                        break;
                }
            }];
            
        }else{
            [self appleLogin];
        }
    }
}


-(void)appleLogin
{
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}


// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows{
    NSLog(@"///已经认证过了/////");
    
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 授权请求AppleID
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordProvider *passwordProvider = [[ASAuthorizationPasswordProvider alloc] init];
        ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest, passwordRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}



#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    // 测试配置UI显示
    NSMutableString *mStr = [NSMutableString string];
    
    if (@available(iOS 13.0, *)) {
        if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            // 用户登录使用ASAuthorizationAppleIDCredential
            ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
            NSString *user = appleIDCredential.user;
            [[NSUserDefaults standardUserDefaults] setObject:user forKey:APPLEUSERID];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSString *familyName = appleIDCredential.fullName.familyName;
//            NSString *givenName = appleIDCredential.fullName.givenName;
            NSString *email = appleIDCredential.email;
            NSData *identityToken = appleIDCredential.identityToken;
            NSData *authorizationCode = appleIDCredential.authorizationCode;
            
            NSString *str1 = [[NSString alloc]initWithData:identityToken encoding:NSUTF8StringEncoding];
//            NSLog(@"str1=%@",str1);
            NSString *str2 = [[NSString alloc]initWithData:authorizationCode encoding:NSUTF8StringEncoding];
            NSLog(@"user=%@,email=%@,token=%@,code=%@",user,email,str1,str2);
            
            [[HGHHttprequest shareinstance] thirdLoginWithuuid:[HGHTools getUUID] type:@"3" tp:@"ap" tpToken:str1 ifSuccess:^(id  _Nonnull response) {
                NSLog(@"response=%@",response);
                [HGHFlyer FlyersReportEvent:@"register" params:@{@"loginType":@"Apple"}];
                NSLog(@"response=%@",response);
                [HGHAccessApi shareinstance].loginBackBlock(response);
            } failure:^(NSError * _Nonnull error) {
                //
            }];
            
            // Create an account in your system.
            // For the purpose of this demo app, store the userIdentifier in the keychain.
            //  需要使用钥匙串的方式保存用户的唯一信息
//            [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
        }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
            // Sign in using an existing iCloud Keychain credential.
            // 用户登录使用现有的密码凭证
            ASPasswordCredential *passwordCredential = authorization.credential;
            // 密码凭证对象的用户标识 用户的唯一标识
            NSString *user = passwordCredential.user;
            // 密码凭证对象的密码
            NSString *password = passwordCredential.password;
            
//            []
            [mStr appendString:user];
            [mStr appendString:@"\n"];
            [mStr appendString:password];
            [mStr appendString:@"\n"];
            NSLog(@"mStr:::%@", mStr);
//            _appleIDInfoLabel.text = mStr;
            NSLog(@"mStr=%@",mStr);
        }else{
            NSLog(@"授权信息均不符");
            mStr = [@"授权信息均不符" copy];
//            _appleIDInfoLabel.text = mStr;
            NSLog(@"mStr=%@",mStr);
        }
    } else {
        // Fallback on earlier versions
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    NSLog(@"error msg=%@",errorMsg);
}

// 告诉代理应该在哪个window 展示内容给用户
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].keyWindow;
}


@end
