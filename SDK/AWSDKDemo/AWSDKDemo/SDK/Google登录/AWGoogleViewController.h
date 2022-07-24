//
//  AWGoogleViewController.h
//  AWSDKDemo
//
//  Created by admin on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
NS_ASSUME_NONNULL_BEGIN

@interface AWGoogleViewController : UIViewController<GIDSignInDelegate,GIDSignInUIDelegate>
+(instancetype)shareinstance;
@property(nonatomic,assign)BOOL islogin;
@end

NS_ASSUME_NONNULL_END
