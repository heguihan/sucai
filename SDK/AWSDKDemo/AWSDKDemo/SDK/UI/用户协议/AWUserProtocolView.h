//
//  AWUserProtcolView.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWUserProtocolView : AWBaseView
+(instancetype)factory_userProtocolWithKey:(NSString *)key;
@property(nonatomic,strong)NSString *protocolKey;
-(void)show;
@end

NS_ASSUME_NONNULL_END
