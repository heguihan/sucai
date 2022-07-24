//
//  HGHLoginAlertview.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/10.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHLoginAlertview : NSObject
@property(nonatomic,strong)UIView *alertView;
@property(nonatomic,strong)NSTimer *timer;
+(instancetype)shareinstance;
-(void)showLoginmeg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
