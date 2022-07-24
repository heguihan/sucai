//
//  AWWelcomeView.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/9.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWWelcomeView : AWBaseView
+(instancetype)factory_welcomeViewWithAccount:(NSString *)account andType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
