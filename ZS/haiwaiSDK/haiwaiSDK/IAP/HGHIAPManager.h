//
//  HGHIAPManager.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/2.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "HGHOrderInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface HGHIAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property(nonatomic,strong)NSDictionary *orderInfo;
@property(nonatomic,strong)NSMutableArray *resendOrderinfo;
@property (nonatomic,strong) NSTimer*timer;
@property(nonatomic,assign)BOOL isPaying;
@property(nonatomic,strong)NSArray *purchaArr;
@property(nonatomic,strong)UIView *appView;
+(instancetype)shareinstance;
-(void)requestIAPWithOrderInfo:(HGHOrderInfo *)orderinfo;
@end

NS_ASSUME_NONNULL_END
