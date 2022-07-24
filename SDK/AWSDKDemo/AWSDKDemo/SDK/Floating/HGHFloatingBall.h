//
//  HGHFloatingBall.h
//  testFunc
//
//  Created by Lucas on 2019/11/29.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHFloatingBall : UIView

@property(nonatomic,assign)BOOL isHalfHidden;
@property(nonatomic,strong)NSTimer *timer;

+(void)hiddenWindow;
//-(void)shouGif:(BOOL)isgif;
@end

NS_ASSUME_NONNULL_END
