//
//  AWMaimaimai.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/14.
//

#import "AWMaimaimai.h"
#import "AWMaiType.h"
#import "AWLocalFile.h"
#import "AWIAPManager.h"
#import "AWEventReportManager.h"

@interface AWMaimaimai()<AWMaiTypeDelegate>

@end

static AWOrderModel *_orderInfo;

@implementation AWMaimaimai
+(void)AWMaimaimaiWithOrderInfo:(AWOrderModel *)orderInfo
{
    //弹框  选择  下单
//    AWMaiType *maiv = [AWMaiType factory_maitypeWithOrderInfo:orderInfo];
//    maiv.delegate = self;
    NSString *type = [AWConfig WeixinPayChannel];
    
    NSString *applePay_no = [AWSDKConfigManager shareinstance].apple_pay_no;
    if ([type isEqualToString:applePay_no]) {
//        [self AWGetOrderIDWithType:type andOrderInfo:orderInfo];
        [self selectType:type andOrderInfo:orderInfo];
        return;
    }
    [AWDataReport saveEventWittEvent:@"app_show_pay" properties:@{}];
//    [maiv show];
}

// 直接下单
+(void)AWGetOrderIDWithType:(NSString *)type andOrderInfo:(AWOrderModel *)orderInfo
{
    [AWHTTPRequest AWGetOrderIDWithOrderInfo:orderInfo payType:type RequestIfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}


+(void)selectType:(NSString *)type andOrderInfo:(AWOrderModel *)orderInfo
{
    WeakSelf
    _orderInfo = orderInfo;
    [AWHTTPRequest AWGetOrderIDWithOrderInfo:orderInfo payType:type RequestIfSuccess:^(id  _Nonnull response){
        if ([response[@"code"] intValue]==200) {
            [weakself dealWithData:response[@"data"] andType:type];
        }else{
            [AWTools makeToastWithText:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

/*
 data =     {
     AMOUNT = 22;
     "AMOUNT_RATE" = "0.143877";
     "AMOUNT_UNIT" = CNY;
     "AMOUNT_USD" = "3.1653";
     "APP_ID" = bdz83pnzenvqjr7l;
     CHANNEL = 431;
     "ITEM_ID" = "xxxx.oooo";
     "ITEM_NAME" = "\U6d4b\U8bd51";
     MSG = SUCC;
     "ORDER_NO" = zszl20201223095218v6umya4n;
     RET = 0;
     "SITE_UID" = 200109116194;
     appid = wx431c881e155d559b;
     noncestr = 383522d9b571e7d4bc7763e73a7f6d17;
     package = "Sign=WXPay";
     "package_str" = "Sign=WXPay";
     partnerid = 1580999031;
     prepayid = wx23095219148939632a022e47e61a810000;
     sign = D4C2037C5C4028596617C8D785FB0BF7;
     timestamp = 1608688339;
 };
 */

+(void)dealWithData:(NSDictionary *)orderInfo andType:(NSString *)type
{
    NSMutableDictionary *mutableOrder = [NSMutableDictionary dictionary];
    [mutableOrder setValue:orderInfo[@"ORDER_NO"] forKey:@"ORDER_NO"];
    [mutableOrder setValue:type forKey:@"mai_type"];
    [mutableOrder setValue:@3 forKey:@"request_count"];
    [mutableOrder setValue:orderInfo[@"AMOUNT"] forKey:@"amount"];
    [mutableOrder setValue:_orderInfo.item_id forKey:@"itemID"];
    [mutableOrder setValue:_orderInfo.item_name forKey:@"itemName"];
    [mutableOrder setValue:_orderInfo.product_type forKey:@"product_type"];
    
    [AWLocalFile saveToLocalWithPath:LOCALORDERINFO withData:mutableOrder];
    NSString *applePay_no = [AWSDKConfigManager shareinstance].apple_pay_no;
    if ([type isEqualToString:applePay_no]) {
        //苹果内购
        NSLog(@"apple内购");
        AWOrderModel *order = [AWOrderModel new];
//        order.productID = @"com.awsdk.demo.product.30";//com.awsdk.demo.product.6
        [AWEventReportManager charge_page];
        order.productID = orderInfo[@"ITEM_ID"];
        [[AWIAPManager shareinstance] requestIAPWithOrderInfo:order andOrderID:orderInfo[@"ORDER_NO"]];
    }
    
}


@end
