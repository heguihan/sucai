//
//  BPIAPPurchaseClass.h
//  BigPlayerSDK
//
//  Created by teamtop on 16/1/5.
//  Copyright © 2016年 John Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
//#import "U8Pay.h"


@interface BPIAPPurchaseClass : NSObject


@property(nonatomic,assign) int receiptValid;

@property(nonatomic,retain) NSMutableDictionary *orderInfoDic;

@property(nonatomic,retain) NSString *signString;





+(BPIAPPurchaseClass *)ShareInstance;

-(void)appstorePayInfo:(NSString *)orderInfo;




@end
