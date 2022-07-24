//
//  AWIAPManager.m
//  AWSDKDemo
//
//  Created by admin on 2021/4/27.
//

#import "AWIAPManager.h"
#import "NSObject+orderAW.h"
#import "AWEventReportManager.h"

@implementation AWIAPManager


static NSString *_amount_unit = @"";

+(instancetype)shareinstance
{
    static AWIAPManager *iap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iap = [[AWIAPManager alloc]init];
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

-(void)requestIAPWithOrderInfo:(AWOrderModel *)orderinfo andOrderID:(NSString *)orderID
{
    _amount_unit = orderinfo.amount_unit;
    if (self.isPaying==YES) {
        return;
    }
    self.isPaying=YES;
    [ProgressHUD show];
    NSString *productId = orderinfo.productID;
    self.orderInfo = @{@"orderID":orderID};
    [self saveOrderToLocal:orderID];
    if (productId.length > 0) {
        NSArray *array = @[productId];
        [self getApplePayWithproductIDS:array];
        
        //发起请求
    } else {
        ////NSLog(@"商品ID为空");
    }
}


-(void)getApplePayWithproductIDS:(NSArray *)array
{
    if ( [SKPaymentQueue canMakePayments]) {
        //*****************************************
        NSArray *trans = [SKPaymentQueue defaultQueue].transactions;
        if (trans.count) {
            for (SKPaymentTransaction *transaction in trans) {
                ////NSLog(@"state=%ld",(long)transaction.transactionState);
                
                
                /*
                 SKPaymentTransactionStatePurchasing,    // Transaction is being added to the server queue.
                 SKPaymentTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
                 SKPaymentTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
                 SKPaymentTransactionStateRestored,
                 */
                if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                    ////NSLog(@"未完成的订单");
                    NSString *orderID = transaction.payment.applicationUsername;
                    NSLog(@"未完成的orderID=%@",orderID);
                    [self completeTransaction:transaction];
                    return;
                }else if (transaction.transactionState == SKPaymentTransactionStatePurchasing){
                    NSLog(@"purchasing");
                }else if (transaction.transactionState == SKPaymentTransactionStateFailed){
                    NSLog(@"failed");
                }else if (transaction.transactionState == SKPaymentTransactionStateRestored){
                    NSLog(@"Restored,");
                }
            }
        }
        
        [ProgressHUD show];
        //*****************************************
        NSSet *set = [NSSet setWithArray:array];
        SKProductsRequest * appStoreRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        appStoreRequest.delegate = self;
        [appStoreRequest start];
        ////NSLog(@"允许应用内支付,请求的productID: %@",set);
    }else{
        ////NSLog(@"不允许应用内支付");
    }
}


-(void)checkLastOrder
{
    NSArray *trans = [SKPaymentQueue defaultQueue].transactions;
    if (trans.count) {
        ////NSLog(@"trans.count=%lu",(unsigned long)trans.count);
        //                SKPaymentTransaction* transaction = [trans firstObject];
        for (SKPaymentTransaction *transaction in trans) {
            ////NSLog(@"state=%ld",(long)transaction.transactionState);
            
            
            /*
             SKPaymentTransactionStatePurchasing,    // Transaction is being added to the server queue.
             SKPaymentTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
             SKPaymentTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
             SKPaymentTransactionStateRestored,
             */
            if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                ////NSLog(@"未完成的订单");
                NSString *orderID = transaction.payment.applicationUsername;
                NSLog(@"未完成的orderID=%@",orderID);
                [self completeTransaction:transaction];
                
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                return;
            }else if (transaction.transactionState == SKPaymentTransactionStatePurchasing){
                NSLog(@"purchasing");
            }else if (transaction.transactionState == SKPaymentTransactionStateFailed){
                NSLog(@"failed");
            }else if (transaction.transactionState == SKPaymentTransactionStateRestored){
                NSLog(@"Restored,");
            }
        }
    }
}


#pragma mark -SKProductsRequestDelegate 获取appstroe产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *gameProduct = response.products;
    if (gameProduct.count == 0) {
        NSLog(@"无法获取产品信息,购买失败");
        [ProgressHUD dismiss];
        self.isPaying=NO;
        return;
    }
    
    for (SKProduct *product in gameProduct) {
        ////NSLog(@"产品标题 %@ ", product.localizedTitle);
        ////NSLog(@"产品描述信息: %@ ", product.localizedDescription);
        ////NSLog(@"价格: %@" , product.price);
        ////NSLog(@"Product id: %@ ", product.productIdentifier);
        
        SKMutablePayment *Mpayment = [SKMutablePayment paymentWithProduct:product];
        int price = [product.price intValue];
        Mpayment.applicationUsername = self.orderInfo[@"orderID"];
        Mpayment.aworder = self.orderInfo[@"orderID"];
        NSData *requestData = [self.orderInfo[@"orderID"] dataUsingEncoding:NSUTF8StringEncoding];
//        Mpayment.requestData = requestData;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",price] forKey:@"IAPMoney"];
        
        
        [[SKPaymentQueue defaultQueue] addPayment:Mpayment];  //请求已经生效
        //           [hud  hide:YES afterDelay:2.0];
        //        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
//    NSString *orderID =  transaction.payment.applicationUsername;
    NSString *orderID =  self.orderInfo[@"orderID"];
//    NSString *orderdata = [[NSString alloc]initWithData:transaction.payment.requestData encoding:NSUTF8StringEncoding];
    NSLog(@"userName=%@",orderID);
    NSString *order = transaction.payment.aworder;
    NSLog(@"propety order==%@",order);
    NSString *out_trans = transaction.transactionIdentifier;
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData * transactionReceiptdata = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding] ;
    self.isPaying=NO;
    NSString*transactionReceiptString=[transactionReceiptdata base64EncodedStringWithOptions:0];
    if ([transactionReceiptString length] > 0) {
        
        ////NSLog(@"凭证打印%@",transactionReceiptString);
        
        
        [self sendReceipt:transactionReceiptString andtransxxx:out_trans orderID:orderID];
        
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

#pragma mark --这里验证票据
-(void)sendReceipt:(NSString*)receipt andtransxxx:(NSString *)out_trade_no orderID:(NSString *)orderID
{
    
    
    
    NSMutableDictionary *mutableDic =[[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    [mutableDic setObject:receipt forKey:@"receipt"];
    [mutableDic setObject:out_trade_no forKey:@"out_trade_no"];
    
//    NSDictionary *dict = @{@"cpOrderID":receipt[@"sdkorderID"],
//                           @"transactionReceipt":receipt[@"transaction"],
//                           @"platformOrderID":receipt[@"platformOrderID"],
//                           @"money":receipt[@"money"]
    
    NSString *money = [NSString stringWithFormat:@"%@",self.orderInfo[@"money"]];
//    NSString *orderID = self.orderInfo[@"orderID"];
    NSString *newOrderID = orderID?orderID:self.orderInfo[@"orderID"];
    
    [mutableDic setObject:newOrderID forKey:@"sdkorderID"];
    [mutableDic setObject:money forKey:@"money"];
    
    [AWHTTPRequest AWCheckReceiptRequestwithorderID:newOrderID deal_no:out_trade_no andreceipt:receipt IfSuccess:^(id  _Nonnull response) {
        NSLog(@"验证票据成功");
        NSLog(@"response==%@",response);
        if ([response[@"code"] intValue] == 200) {
            //
            [AWEventReportManager charge_ok:@{@"amount":money,@"amount_unit":_amount_unit}];
        }else{
            [self.resendOrderinfo addObject:mutableDic];
            if (self.timer==nil) {
                [self createTimer];
            }
            
        }
    } failure:^(NSError * _Nonnull error) {
        //失败
        NSLog(@"验证票据失败");
        [self.resendOrderinfo addObject:mutableDic];
        if (self.timer==nil) {
            [self createTimer];
        }
    }];



    
}

-(void)createTimer
{
    self.timer=[NSTimer timerWithTimeInterval:9.0 target:self selector:@selector(resendRecipt) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)createExceptionOrderTimer
{
    if (self.orderTimer) {
        [self.orderTimer invalidate];
    }
    self.orderTimer = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(checkExceptionOrder) userInfo:nil repeats:YES];

     [[NSRunLoop mainRunLoop] addTimer:self.orderTimer forMode:NSRunLoopCommonModes];

//    NSTimer *newtimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(checkExceptionOrder) userInfo:nil repeats:NO];
}

-(void)checkExceptionOrder
{
    NSMutableArray *getMuatbleArr = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"testExceptionOrderID"]];
    NSLog(@"orderArr=%@",getMuatbleArr);
    for (NSDictionary *dict in [getMuatbleArr copy]) {
        NSString *orderTs = dict[@"ts"];
        NSString *currentTs = [AWTools getCurrentTimeString];
        if ([currentTs intValue]-[orderTs intValue]>60) {
//            [self sendExceptionOrder:dict];
            [getMuatbleArr removeObject:dict];
            [[NSUserDefaults standardUserDefaults] setObject:getMuatbleArr forKey:@"testExceptionOrderID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    if (getMuatbleArr.count<1) {
        [self.orderTimer invalidate];
    }
}

-(void)saveOrderToLocal:(NSString *)orderID
{
    NSDictionary *dictOrder = @{@"orderID":orderID,@"ts":[AWTools getCurrentTimeString]};
    NSMutableArray *mutableOrder = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"testExceptionOrderID"]];
    if (mutableOrder.count==0) {
        mutableOrder = [NSMutableArray array];
    }
//    NSLog(@"mutalearr.count=%ld",mutableOrder.count);
    [mutableOrder addObject:dictOrder];
    
    NSLog(@"add order=%@",mutableOrder);
    [[NSUserDefaults standardUserDefaults] setObject:mutableOrder forKey:@"testExceptionOrderID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)removeOrderFromLocal:(NSString *)orderID
{
    NSMutableArray *getMuatbleArr = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"testExceptionOrderID"]];
    NSLog(@"orderArr=%@",getMuatbleArr);
    for (NSDictionary *dict in [getMuatbleArr copy]) {
        if ([orderID isEqualToString:dict[@"orderID"]]) {
            [getMuatbleArr removeObject:dict];
            [[NSUserDefaults standardUserDefaults] setObject:getMuatbleArr forKey:@"testExceptionOrderID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    if (getMuatbleArr.count<1) {
        [self.orderTimer invalidate];
    }
}

-(void)resendRecipt
{
//    NSLog(@"timer----------->");
//    return;
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
        ////NSLog(@"购买失败");
    } else {
        ////NSLog(@"支付请求取消");
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

    ////NSLog(@"购买结果");
//    ////NSLog(@"transactions=%@",transactions);
    for (SKPaymentTransaction *transaction in transactions) {
        ////NSLog(@"transaction=%@",transaction);
//        [self restoreTransaction:transaction];
        NSString *orderID = transaction.payment.applicationUsername;
        NSString *newOrderID = orderID?orderID:self.orderInfo[@"orderID"];
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: //交易完成
                [ProgressHUD dismiss];
                ////NSLog(@"交易完成transactionIdentifier= %@", transaction.transactionIdentifier);
                
//                NSString *userName =  transaction.payment.applicationUsername;
//                NSLog(@"userName=%@",userName);

                [self removeOrderFromLocal:newOrderID];
                [self completeTransaction:transaction];
                
//                NSString *copyOrderID = [self.orderInfo[@""] copy];
//                self.orderInfo[@""] = @"";
//                [self check:copyOrderID];
                // 1、调用方法
                // 2、订单置空
                
//                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [ProgressHUD dismiss];
                NSLog(@"交易失败");
                self.isPaying=NO;
                [self removeOrderFromLocal:newOrderID];
                [self failedTransaction:transaction];
//                [self restoreTransaction:transaction];
                ////NSLog(@"交易失败");
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                ////NSLog(@"已经购买的商品");
                [ProgressHUD dismiss];
                self.isPaying=NO;
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                ////NSLog(@"添加到商品列表");
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
    }];
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
    NSString *newOrderID = orderInfoDic[@"sdkorderID"];
    NSString *out_trade_no = orderInfoDic[@"out_trade_no"];
    NSString *receipt = orderInfoDic[@"receipt"];
    [AWHTTPRequest AWCheckReceiptRequestwithorderID:newOrderID deal_no:out_trade_no andreceipt:receipt IfSuccess:^(id  _Nonnull response) {
        NSLog(@"验证票据成功");
        NSLog(@"response==%@",response);
    } failure:^(NSError * _Nonnull error) {
        //失败
        NSLog(@"验证票据失败");
    }];
    
//    [HGHFunctionHttp HGHSendRecieptWithReceiptInfo:orderInfoDic ifSuccess:^(id  _Nonnull response) {
//        if ([response[@"ret"] integerValue]==0) {
//            ////NSLog(@"二次 发送票据成功");
//            [self.resendOrderinfo removeObjectAtIndex:0];
//            [[NSUserDefaults standardUserDefaults] setObject:self.resendOrderinfo forKey:@"hghreciptresend"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }else
//            {
////            [self.resendOrderinfo addObject:orderInfoDic];
//            if (self.timer==nil) {
//                [self createTimer];
//            }
//            }
//    } failure:^(NSError * _Nonnull error) {
////        [self.resendOrderinfo addObject:orderInfoDic];
//        if (self.timer==nil) {
//            [self createTimer];
//        }
//    }];
    
    
}

-(void)initResendreceipt:(NSMutableArray *)orderInfoArr
{
//    if (orderInfoArr.count!=0) {
//        for (NSMutableDictionary *dict in orderInfoArr) {
//            [[HGHIAPManager shareinstance] initVerifyReceiptFromCompanyServerWhenLogin:dict];
//        }
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hghreciptresend"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}
// 重启漏单时二次验证
- (void)initVerifyReceiptFromCompanyServerWhenLogin:(NSMutableDictionary *)orderInfoDic
{
    
////    orderInfoDic
////    NSMutableDictionary *orderInfoDic = orderInfoArr[0];
//    [HGHFunctionHttp HGHSendRecieptWithReceiptInfo:orderInfoDic ifSuccess:^(id  _Nonnull response) {
//        if ([response[@"ret"] integerValue]==0) {
//            ////NSLog(@"二次 发送票据成功");
////            [self.resendOrderinfo removeObjectAtIndex:0];
//        }else
//            {
//            [self.resendOrderinfo addObject:orderInfoDic];
//            if (self.timer==nil) {
//                [self createTimer];
//            }
//            }
//    } failure:^(NSError * _Nonnull error) {
//        [self.resendOrderinfo addObject:orderInfoDic];
//        if (self.timer==nil) {
//            [self createTimer];
//        }
//    }];
    
    
}


@end
