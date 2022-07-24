//
//  AWBindAlertView.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWBindAlertView : AWBaseView
@property(nonatomic, strong)NSString *gameVersion;
@property(nonatomic, strong)NSString *updateContentStr;
@property(nonatomic, assign)BOOL isForcedUpdate;
+(instancetype)factory_bindalert;
-(void)show;
@end

NS_ASSUME_NONNULL_END
