//
//  HGHOrderInfo.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/7.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHOrderInfo : NSObject
+(instancetype)shareinstance;
//@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *server_id;
//@property(nonatomic,strong)NSString *app_id;
@property(nonatomic,strong)NSString *product_id;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *currency;
@property(nonatomic,strong)NSString *trade_no;
@property(nonatomic,strong)NSString *subject;
@property(nonatomic,strong)NSString *body;
@property(nonatomic,strong)NSString *roleID;
//@property(nonatomic,strong)NSString *platform;
//@property(nonatomic,strong)NSString *
@end

NS_ASSUME_NONNULL_END
