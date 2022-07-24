//
//  HGHEmailRegister.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHEmailRegister : NSObject<UITextFieldDelegate>
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UITextField *usernameTF;
@property(nonatomic, strong)UITextField *pwdTF;
@property(nonatomic, strong)UITextField *emailTF;
@property(nonatomic, strong)UITextField *verifyTF;
@property(nonatomic, strong)UIButton *confirmBtn;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic, assign)NSInteger showNum;
@property(nonatomic, strong)UIButton *verifyBtn;
@property(nonatomic, strong)UIButton *fxkBtn;
+(instancetype)shareInstance;

-(void)emailRegister;
@end

NS_ASSUME_NONNULL_END
