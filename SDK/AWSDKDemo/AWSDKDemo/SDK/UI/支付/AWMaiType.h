//
//  AWMaiType.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/14.
//

#import "AWNaviView.h"
#import "AWOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@class AWMaiType;

@protocol AWMaiTypeDelegate <NSObject>

@optional

+(void)selectType:(NSString *)type andOrderInfo:(AWOrderModel *)orderInfo;

@end


@interface AWMaiType : AWNaviView
+(instancetype)factory_maitypeWithOrderInfo:(AWOrderModel *)orderInfo;
//-(void)show;

@property(nonatomic, weak)id <AWMaiTypeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
