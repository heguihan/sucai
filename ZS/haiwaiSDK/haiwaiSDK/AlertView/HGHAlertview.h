//
//  HGHAlertview.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHAlertview : NSObject
+(instancetype)shareInstance;

+(void)showAlertViewWithMessage:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
