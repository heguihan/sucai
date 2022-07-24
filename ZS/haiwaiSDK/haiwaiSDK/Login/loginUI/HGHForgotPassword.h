//
//  HGHForgotPassword.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHForgotPassword : NSObject<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)UITextField *usernameTF;
@property(nonatomic, strong)UITextField *verifycodeTF;
@property(nonatomic, assign)BOOL isFirst;
@property(nonatomic, strong)NSTimer *timer;
+(instancetype)shareInstance;
-(void)gotoForgotPassword;
@end

NS_ASSUME_NONNULL_END
