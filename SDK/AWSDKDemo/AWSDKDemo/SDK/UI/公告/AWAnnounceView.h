//
//  AWAnnounceView.h
//  AWSDKDemo
//
//  Created by admin on 2021/9/26.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWAnnounceView : AWBaseView
+(instancetype)factory_AnnounceViewWithTitle:(NSString *)title andContent:(NSString *)content isCloseServer:(int)isCloseServer btnText:(NSString *)btnStr urlstr:(NSString *)urlStr freq:(NSString *)freq;
@end

NS_ASSUME_NONNULL_END
