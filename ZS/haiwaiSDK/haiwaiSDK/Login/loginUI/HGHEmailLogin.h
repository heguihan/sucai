//
//  HGHEmailLogin.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/11.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHEmailLogin : NSObject<UITextFieldDelegate>
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic,strong)UITextField *userNameTF;
@property(nonatomic,strong)UITextField *pwdTF;

+(instancetype)shareInstance;

-(void)emailLogin;
@end

NS_ASSUME_NONNULL_END
