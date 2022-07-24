//
//  AWOrderModel.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWOrderModel : NSObject
@property(nonatomic,strong)NSString *timeStr;           //10位时间戳
@property(nonatomic,assign)float amount;                //金额  单位元
@property(nonatomic,strong)NSString *amount_unit;       //金额类型 国内传  @”CNY“
@property(nonatomic,strong)NSDictionary *ext;           //扩展字段
@property(nonatomic,strong)NSString *item_id;           //商品ID
@property(nonatomic,strong)NSString *item_name;         //商品名
@property(nonatomic,strong)NSString *notify_url;        //回调地址
@property(nonatomic,strong)NSString *out_trade_no;      //游戏订单号
@property(nonatomic,strong)NSString *site_uid;          //SDK uid  不用传
@property(nonatomic,strong)NSString *product_type;      //商品类型 例如：元宝 、月卡
@property(nonatomic,strong)NSString *server_id;         //区服ID
@property(nonatomic,strong)NSString *role_id;           //角色ID
@property(nonatomic,strong)NSString *productID;         //商品ID 内购用的
@end

NS_ASSUME_NONNULL_END
