//
//  AWSmallControl.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "AWHGHALLButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface AWSmallControl : NSObject

@property(nonatomic,assign)BOOL isLogoShow;
+(AWHGHALLButton *)getBackBtn;
+(AWHGHALLButton *)getCloseBtn;
+(AWHGHALLButton *)getEyesBtn;
+(UIImageView *)getLogoView;
@end

NS_ASSUME_NONNULL_END
