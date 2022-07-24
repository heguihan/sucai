//
//  HGHShowBall.h
//  testFunc
//
//  Created by Lucas on 2019/11/29.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGHFloatingBall.h"
NS_ASSUME_NONNULL_BEGIN

@interface HGHShowBall : NSObject
@property(nonatomic,strong)HGHFloatingBall *floatBall;
@property(nonatomic,assign)BOOL isaready;
+(instancetype)shareInstance;
+(void)showFloatingball;
+(void)hiddenWindow;
+(void)unHiddenWindow;
+(void)isSHowGif:(BOOL)isshowGif;
+(void)closeFloatingBall;
@end

NS_ASSUME_NONNULL_END
