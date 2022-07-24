//
//  HGHChangePassword.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHChangePassword : NSObject
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)UITextField *accountTF;
@property(nonatomic,strong)UITextField *oldPwdTF;
@property(nonatomic,strong)UITextField *newsPwdTF;
@property(nonatomic,strong)UITextField *confirmPwdTF;
@property(nonatomic, assign)BOOL isFirst;
@property(nonatomic, strong)NSTimer *timer;
+(instancetype)shareinstance;
-(void)gotoChangePassword;
@end

NS_ASSUME_NONNULL_END
