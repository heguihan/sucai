//
//  HGHAccount.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHAccount : NSObject
@property(nonatomic, strong)UIView *redview;
-(void)gotoAccount;
+(instancetype)shareinstance;
@end

NS_ASSUME_NONNULL_END
