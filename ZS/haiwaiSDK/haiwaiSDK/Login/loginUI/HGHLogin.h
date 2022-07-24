//
//  HGHLogin.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHLogin : NSObject
+(instancetype)shareinstance;
@property(nonatomic, strong)UIButton *testBtn;
@property(nonatomic,strong)UIView *baseView;
//@property(nonatomic,strong)
-(void)Login;
+(void)fblogin;
@end

NS_ASSUME_NONNULL_END
