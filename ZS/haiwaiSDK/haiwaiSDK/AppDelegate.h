//
//  AppDelegate.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

