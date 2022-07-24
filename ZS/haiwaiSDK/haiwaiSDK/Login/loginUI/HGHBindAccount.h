//
//  HGHBindAccount.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHBindAccount : NSObject
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *btnFB;
@property(nonatomic,strong)UIButton *btnGUEST;
@property(nonatomic,strong)UIButton *btnGOOGLE;
@property(nonatomic,strong)UITextField *usernameTF;
@property(nonatomic,strong)UITextField *pwdTF;
@property(nonatomic,strong)NSString *plamt;
@property(nonatomic,strong)NSString *platType;
@property(nonatomic, assign)BOOL isFirst;

@property(nonatomic, assign)BOOL isFirstClick;
@property(nonatomic, strong)NSTimer *timer;
+(instancetype)shareinstance;
-(void)gotoBindAccount;
@end

NS_ASSUME_NONNULL_END
