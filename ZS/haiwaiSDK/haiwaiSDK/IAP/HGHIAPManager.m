//
//  HGHIAPManager.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/2.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "HGHHttprequest.h"
#import "HGHConfig.h"
#import "HGHTools.h"
#import "ProgressHUD.h"
#import "HGHFlyer.h"
#import "HGHAlertview.h"
@implementation HGHIAPManager

+(instancetype)shareinstance
{
    static HGHIAPManager *iap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iap = [[HGHIAPManager alloc]init];
    });
    return iap;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    self.isPaying=NO;
    return self;
}

-(NSMutableArray *)resendOrderinfo
{
    if (!_resendOrderinfo) {
        _resendOrderinfo = [[NSMutableArray alloc]init];
    }
    return _resendOrderinfo;
}

-(void)requestIAPWithOrderInfo:(HGHOrderInfo *)orderinfo
{
    [ProgressHUD show];
    if (self.isPaying==YES) {
        return;
    }
    self.isPaying=YES;
    NSString *productId = orderinfo.product_id;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"shuID"];
    
    NSString *idfa = [HGHFlyer getIDFA];
    NSString *appsflyerid = [HGHFlyer getAppsflyerID];
    NSDictionary *platformDic =@{@"appflyer":@{@"appsflyer_id":appsflyerid,@"idfa":idfa}
                                 };
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:platformDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *appsFlyer = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.orderInfo = @{@"user_id":userID,
                       @"server_id":orderinfo.server_id,
                       @"app_id":[HGHConfig shareInstance].appID,
                       @"product_id":orderinfo.product_id,
                       @"amount":orderinfo.amount,
                       @"currency":orderinfo.currency,
                       @"trade_no":orderinfo.trade_no,
                       @"subject":orderinfo.subject,
                       @"body":orderinfo.body,
                       @"platform":@"ios",
                       @"ad":appsFlyer,
                       @"timestamp":[HGHTools getTimeString],
                       @"nonce_str":[HGHTools getnonce_str]
                       };
    if (productId.length > 0) {
        NSArray *array = @[productId];
        NSLog(@"array=%@",array);
//        [self getApplePayWithproductIDS:array];
        [self getButtonRestore:array];
        
        //发起请求
    } else {
        NSLog(@"商品ID为空");
    }
}

-(void)getButtonRestore:(NSArray *)array
{
//    [ProgressHUD show];
    self.purchaArr = array;
    [ProgressHUD dismiss];
    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    
    self.appView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-300)/2, (SCREENHEIGHT-100)/2, 300, 100)];
//    self.appView.backgroundColor = [UIColor redColor];
    UIImageView *imageVxx = [[UIImageView alloc]initWithFrame:self.appView.bounds];
    [self.appView addSubview:imageVxx];
    imageVxx.image = [UIImage imageNamed:@"outSea.bundle/bgwhite.png"];
    imageVxx.userInteractionEnabled = YES;
    
    UIButton *purchaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 100, 40)];
    [purchaseBtn setTitle:@"Purchase" forState:UIControlStateNormal];
    purchaseBtn.backgroundColor = [UIColor blueColor];
    [imageVxx addSubview:purchaseBtn];
    purchaseBtn.layer.cornerRadius = 15;
    
    UIButton *restoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(170, 30, 100, 40)];
    [restoreBtn setTitle:@"Restore" forState:UIControlStateNormal];
    restoreBtn.backgroundColor = [UIColor blueColor];
    restoreBtn.layer.cornerRadius = 15;
    [imageVxx addSubview:restoreBtn];
    
    [purchaseBtn addTarget:self action:@selector(purchClick:) forControlEvents:UIControlEventTouchUpInside];
    [restoreBtn addTarget:self action:@selector(restoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"hghhaiwailoginway"];
        if ([dict[@"face_book"] integerValue]==0) {
            [currentVC.view addSubview:self.appView];
        }else{
            [self getApplePayWithproductIDS:array];
        }
    
}

-(void)purchClick:(UIButton *)sender
{
    [self.appView removeFromSuperview];
    if ( [SKPaymentQueue canMakePayments]) {
        //*****************************************
        NSArray *trans = [SKPaymentQueue defaultQueue].transactions;
        if (trans.count) {
            NSLog(@"trans.count=%lu",(unsigned long)trans.count);
            //                SKPaymentTransaction* transaction = [trans firstObject];
            for (SKPaymentTransaction *transaction in trans) {
                NSLog(@"state=%ld",(long)transaction.transactionState);
                if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                    NSLog(@"未完成的订单");
//                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    [HGHAlertview showAlertViewWithMessage:@"It's has been purchased already,please restore."];
                    self.isPaying=NO;
                    return;
                }
            }
            
        }
        
        
        [self getApplePayWithproductIDS:self.purchaArr];
    }else{
        NSLog(@"不允许应用内支付");
    }
}

-(void)restoreClick:(UIButton *)sender
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [self.appView removeFromSuperview];
        if ( [SKPaymentQueue canMakePayments]) {
            //*****************************************
            NSArray *trans = [SKPaymentQueue defaultQueue].transactions;
            if (trans.count) {
                NSLog(@"trans.count=%lu",(unsigned long)trans.count);
                //                SKPaymentTransaction* transaction = [trans firstObject];
                for (SKPaymentTransaction *transaction in trans) {
                    NSLog(@"state=%ld",(long)transaction.transactionState);
                    if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                        NSLog(@"未完成的订单");
                        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                        [HGHAlertview showAlertViewWithMessage:@"Purchase restored."];
                        self.isPaying=NO;
                        return;
                    }else{
                        [HGHAlertview showAlertViewWithMessage:@"No Restoring Purchases detected."];
                        self.isPaying=NO;
                        return;
                    }
                }
                
            }
            else{
                [HGHAlertview showAlertViewWithMessage:@"No Restoring Purchases detected."];
            }
            self.isPaying=NO;
            
//            [self getApplePayWithproductIDS:self.purchaArr];
        }else{
            NSLog(@"不允许应用内支付");
        }
}

-(void)getApplePayWithproductIDS:(NSArray *)array
{
    if ( [SKPaymentQueue canMakePayments]) {
        //*****************************************
        NSArray *trans = [SKPaymentQueue defaultQueue].transactions;
        if (trans.count) {
            NSLog(@"trans.count=%lu",(unsigned long)trans.count);
            //                SKPaymentTransaction* transaction = [trans firstObject];
            for (SKPaymentTransaction *transaction in trans) {
                NSLog(@"state=%ld",(long)transaction.transactionState);
                if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                    NSLog(@"未完成的订单");
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    return;
                }
            }
            
        }
        
        
        //*****************************************
        NSSet *set = [NSSet setWithArray:array];
        SKProductsRequest * appStoreRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        appStoreRequest.delegate = self;
        [appStoreRequest start];
        NSLog(@"允许应用内支付,请求的productID: %@",set);
    }else{
        NSLog(@"不允许应用内支付");
    }
}


#pragma mark -SKProductsRequestDelegate 获取appstroe产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *gameProduct = response.products;
    if (gameProduct.count == 0) {
        NSLog(@"无法获取产品信息,购买失败");
        self.isPaying=NO;
        return;
    }
    
    for (SKProduct *product in gameProduct) {
        NSLog(@"产品标题 %@ ", product.localizedTitle);
        NSLog(@"产品描述信息: %@ ", product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@ ", product.productIdentifier);
        
        SKMutablePayment *Mpayment = [SKMutablePayment paymentWithProduct:product];
        int price = [product.price intValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",price] forKey:@"IAPMoney"];
        
        
        [[SKPaymentQueue defaultQueue] addPayment:Mpayment];  //请求已经生效
        //           [hud  hide:YES afterDelay:2.0];
        //        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *out_trans = transaction.transactionIdentifier;
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData * transactionReceiptdata = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding] ;
    
    NSString*transactionReceiptString=[transactionReceiptdata base64EncodedStringWithOptions:0];
    if ([transactionReceiptString length] > 0) {
        
        NSLog(@"凭证打印%@",transactionReceiptString);
        
        
        [self sendReceipt:transactionReceiptString andtransxxx:out_trans];
        
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

#pragma mark --这里验证票据
-(void)sendReceipt:(NSString*)receipt andtransxxx:(NSString *)out_trade_no
{
    //在这里 如果请求失败  需要重新发送票据
//    NSMutableArray *mu code=40005充值违规， 不再发送
//    [NSUserDefaults standardUserDefaults] setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
    
    NSMutableDictionary *mutableDic =[[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    [mutableDic setObject:receipt forKey:@"iap_data"];
    [mutableDic setObject:out_trade_no forKey:@"out_trade_no"];
    double money = [self.orderInfo[@"amount"] integerValue]/100.0;
    
    [HGHFlyer FlyersReportEvent:@"af_purchase" params:@{@"af_revenue":[NSString stringWithFormat:@"%lf",money],@"number":@"1"}];
    [[HGHHttprequest shareinstance]sendReceptWithOrderInfo:mutableDic ifSuccess:^(id  _Nonnull response) {
        NSLog(@"response=%@",response);
        if ([response[@"code"] intValue] ==20000) {
            NSLog(@"发送成功");
        }else
        {
            [self.resendOrderinfo addObject:mutableDic];
            if (self.timer==nil) {
                [self createTimer];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        [self.resendOrderinfo addObject:mutableDic];
        if (self.timer==nil) {
            [self createTimer];
        }
    }];

    
}

-(void)createTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:9 target:self selector:@selector(resendRecipt) userInfo:nil repeats:YES];
    
    
}

-(void)resendRecipt
{
    NSLog(@"timer----------->");
    if (self.resendOrderinfo.count!=0) {
        [self verifyReceiptFromCompanyServerWhenLogin:self.resendOrderinfo[0]];
    }else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}




// 交易失败,通知IAP进行UI刷新
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"支付请求取消");
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"UserCancel",@"result", nil];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



#pragma mark - 购买商品
//- (void)buyProduct:(SKProduct *)product
//{
//    // 1.创建票据
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
//
//    // 2.将票据加入到交易队列中
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//
//}

#pragma mark-SKPayment TransactionObserver支付结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"购买结果");
//    NSLog(@"transactions=%@",transactions);
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"transaction=%@",transaction);
//        [self restoreTransaction:transaction];
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: //交易完成
                [ProgressHUD dismiss];
                NSLog(@"交易完成transactionIdentifier= %@", transaction.transactionIdentifier);
                self.isPaying=NO;
                [self completeTransaction:transaction];
//                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [ProgressHUD dismiss];
                NSLog(@"交易失败");
                self.isPaying=NO;
                [self failedTransaction:transaction];
//                [self restoreTransaction:transaction];
                NSLog(@"交易失败");
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"已经购买的商品");
                [ProgressHUD dismiss];
                self.isPaying=NO;
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"添加到商品列表");
                [ProgressHUD dismiss];
//                [self restoreTransaction:transaction];
                break;

            default:
                break;
        }
    }
}





- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [ProgressHUD dismiss];
    self.isPaying=NO;
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [ProgressHUD dismiss];
    self.isPaying=NO;
}

-(void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    // 对于已经购买的产品,恢复其处理逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}



- (NSString *)getHttpSing:(NSMutableDictionary *)dic
{
    NSString *str = nil;
    NSMutableArray *parameters_array = [NSMutableArray arrayWithArray:[dic allKeys]];
    [parameters_array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
        //return [obj2 compare:obj1];//降序
    } ];
    for (int i = 0; i<parameters_array.count; i++) {
        NSString *key = [parameters_array objectAtIndex: i];
        NSString * value = [dic objectForKey:key];
        value = [self encodeString:value];
        if (i==0) {
            
            str = [NSString stringWithFormat:@"%@=%@",key,value] ;
            
        }else{
            
            str = [NSString stringWithFormat:@"%@&%@=%@",str,key,value];
        }
        
    }
    
    return str;
}

-(NSString*)encodeString:(NSString*)unencodedString{
    
    NSString *encodedString=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0f) {
        
        encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)unencodedString,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));
    }
    
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return encodedString;
}



// 登录时二次验证
+ (void)verifyReceiptFromCompanyServerWhenAccident
{

}

// 断网漏单时二次验证
- (void)verifyReceiptFromCompanyServerWhenLogin:(NSMutableDictionary *)orderInfoDic
{
    [[HGHHttprequest shareinstance]sendReceptWithOrderInfo:orderInfoDic ifSuccess:^(id  _Nonnull response) {
        NSLog(@"response=%@",response);
        if ([response[@"code"] intValue]==20000 || [response[@"code"] intValue]==40005) {
            [self.resendOrderinfo removeObjectAtIndex:0];
            NSLog(@"发送成功");
        }else
        {
            [self.resendOrderinfo addObject:orderInfoDic];
            if (self.timer==nil) {
                [self createTimer];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        [self.resendOrderinfo addObject:orderInfoDic];
        if (self.timer==nil) {
            [self createTimer];
        }
    }];
}

@end
