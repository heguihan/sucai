//
//  AWIAPManager.h
//  AWSDKDemo
//
//  Created by admin on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AWOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AWIAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property(nonatomic,strong)NSDictionary *orderInfo;
@property(nonatomic,strong)NSMutableArray *resendOrderinfo;
@property (nonatomic,strong) NSTimer*timer;
@property(nonatomic,strong)NSTimer *orderTimer;
@property(nonatomic,assign)BOOL isPaying;
@property(nonatomic,strong)NSArray *purchaArr;
@property(nonatomic,strong)UIView *appView;
+(instancetype)shareinstance;
-(void)requestIAPWithOrderInfo:(AWOrderModel *)orderinfo andOrderID:(NSString *)orderID;
-(void)initResendreceipt:(NSMutableArray *)orderInfoArr;
//检测沙箱里面是否有未完成的订单
-(void)checkLastOrder;
@end

NS_ASSUME_NONNULL_END
