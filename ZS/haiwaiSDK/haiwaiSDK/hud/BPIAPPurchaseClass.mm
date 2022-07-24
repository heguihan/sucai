//
//  BPIAPPurchaseClass.m
//  BigPlayerSDK
//
//  Created by teamtop on 16/1/5.
//  Copyright © 2016年 John Cheng. All rights reserved.
//

#import "BPIAPPurchaseClass.h"
#import <CommonCrypto/CommonCrypto.h>
#import <iconv.h>
#import "ProgressHUD.h"
#define appid @"G101273"
#define openKey @"f33108fb25737154f938879d6080a22a"

@interface BPIAPPurchaseClass ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
//    U8ProductInfo *payInfo;
     UIViewController *rootVC;
    UIActivityIndicatorView *juhua;
  
}

@property(nonatomic, strong)NSMutableArray *receiptArray;
@property (nonatomic,strong) NSTimer*timer;
@end
@implementation BPIAPPurchaseClass

-(NSMutableArray *)receiptArray
{
    if (_receiptArray==nil) {
        _receiptArray=[NSMutableArray array];
    }
    return _receiptArray;
}


//-(void)dealloc
//{
//     [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//     [super dealloc];
// }
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    }
    return self;
}
+(BPIAPPurchaseClass *)ShareInstance{
    
    static BPIAPPurchaseClass *applePayClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        applePayClass = [[BPIAPPurchaseClass alloc]init];;
        
    });
    return applePayClass;
}
//请求数据
-(void)appstorePayInfo:(NSString *)orderInfo{
{
    // 加载动画
    juhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC.view addSubview:juhua];
    juhua.center = rootVC.view.center;
    [juhua setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [juhua startAnimating];
//    payInfo = orderInfo;
        // 苹果支付
    [ProgressHUD show];
    NSArray *array = @[orderInfo];
    if ( [SKPaymentQueue canMakePayments]) {
        NSSet *set = [NSSet setWithArray:array];
        SKProductsRequest * appStoreRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        appStoreRequest.delegate = self;
        [appStoreRequest start];
        NSLog(@"允许应用内支付,请求的productID: %@",set);
        }else{
            NSLog(@"不允许应用内支付");
        }
  }
}
#pragma mark -SKProductsRequestDelegate 获取appstroe产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *gameProduct = response.products;
    if (gameProduct.count == 0) {
        NSLog(@"无法获取产品信息,购买失败");
        if(juhua){
            [juhua stopAnimating];
        }
        return;
    }
    for (SKProduct *product in gameProduct) {
        NSLog(@"产品标题 %@ ", product.localizedTitle);
        NSLog(@"产品描述信息: %@ ", product.localizedDescription);
        NSLog(@"价格: %@", product.price);
        NSLog(@"Product id: %@ ", product.productIdentifier);
        SKMutablePayment *Mpayment = [SKMutablePayment paymentWithProduct:product];
        int price = [product.price intValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",price] forKey:@"IAPMoney"];
        if ([[SKPaymentQueue defaultQueue] respondsToSelector:@selector(addPayment:)]) {
         [[SKPaymentQueue defaultQueue] addPayment:Mpayment];  //请求已经生效

        }
    }
}
// transaction 交易成功服务器
// Read the Receipt Data 获取
//observer在用户成功购买后提供相应的product
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [juhua stopAnimating];

    NSLog(@"支付完成---completeTransaction:%@",transaction.transactionIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //处理错误
    [request cancel];
    request = nil;
}

// 交易失败,通知IAP进行UI刷新
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        NSLog(@"%@",transaction.error);
    } else {
   }
    if (juhua) {
        [juhua stopAnimating];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark-SKPayment TransactionObserver支付结果
//----监听购买结果
//然后当用户输入正确的appStore帐号密码后进入（再次说明 如果是测试 必须是你注册的测试账号 不能使用真实的AppleID ）
//方法在新交易被创建或更新时都会被调用
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [ProgressHUD dismiss];
    for (SKPaymentTransaction *transaction in transactions) {
        
  
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: //交易完成
                NSLog(@"交易完成transactionIdentifier= %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
//                // The unique server-provided identifier.  Only valid if state is SKPaymentTransactionStatePurchased or SKPaymentTransactionStateRestored.
//                @property(nonatomic, readonly, nullable) NSString *transactionIdentifier NS_AVAILABLE_IOS(3_0);
//
//                // Only valid if state is SKPaymentTransactionStatePurchased.
//                @property(nonatomic, readonly, nullable) NSData *transactionReceipt
                
        
                NSLog(@"交易========交易完成");
                
                [juhua stopAnimating];
                
//                [self payNotifyU8sdkLikeBanmehuyu:@"1" andTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"%@",transaction.error);
                [self failedTransaction:transaction];
                [juhua stopAnimating];
                NSLog(@"交易========交易失败");

//                [self payNotifyU8sdkLikeBanmehuyu:@"2" andTransaction:transaction];

                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                
                [self restoreTransaction:transaction];
                [juhua stopAnimating];
                
                break;
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
//                [juhua stopAnimating];
                break;
                
            default:
                break;
        }
    }
}

-(void)createTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:9 target:self selector:@selector(chongfajizhi) userInfo:nil repeats:YES];
    
    
}

-(void)chongfajizhi
{
    
    if (self.receiptArray.count!=0) {
        
        [self timeRsendReceipt:self.receiptArray[0]];
    }else
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    
    
}

-(void)timeRsendReceipt:(NSDictionary *)dict
{
//    NSString *transactionIdentifier = transaction.transactionIdentifier;
//
//    //    NSString *receipstr = [transaction.transactionReceipt :1];
//    NSString *receiptaa = [transaction.transactionReceipt base64Encoding];
//    //    NSLog(@"str=%@",str);
//    SKPayment *skp = transaction.payment;
//    NSString *productID = skp.productIdentifier;
//
    [ProgressHUD dismiss];
    if (juhua) {
        [juhua stopAnimating];
    }
    //1，创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //2,根据会话创建task
    NSURL *url = [NSURL URLWithString:@"http://u8svr.acingame.com/pay/apple/validate"];
    //3,创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4,请求方法改为post
    request.HTTPMethod = @"POST";
//    NSMutableDictionary *testInfo = [NSMutableDictionary dictionary];
//    [testInfo setObject:payInfo.orderID forKey:@"orderID"];
//    [testInfo setObject:transactionIdentifier forKey:@"transactionIdentifier"];
//    [testInfo setObject:productID forKey:@"productId"];
//    [testInfo setObject:receiptaa forKey:@"transactionReceipt"];
    //5,设置请求体
//    NSLog(@"请求提=%@",[self getSignString:testInfo]);
    NSLog(@"testInfo = %@",dict);
    NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dict];
    request.HTTPBody = [[self getHttpSing:newdic] dataUsingEncoding:NSUTF8StringEncoding];
    //6根据会话创建一个task（发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        NSLog(@"code=%d",responseStatusCode);
        NSLog(@"let us begin");
        NSLog(@"testInfo = %@",dict);
        
        if (responseStatusCode==200) {
            NSLog(@"发送成功");
            [self.receiptArray removeObjectAtIndex:0];
        }else{
            NSLog(@"发送失败");

        }
        if (juhua) {
            [juhua stopAnimating];
        }
        
    }];
    if (juhua) {
        [juhua stopAnimating];
    }
    [dataTask resume];
}



//-(void)payNotifyU8sdkLikeBanmehuyu:(NSString *)result andTransaction:(SKPaymentTransaction*)transaction{
//    
//    NSString *transactionIdentifier = transaction.transactionIdentifier;
//
////    NSString *receipstr = [transaction.transactionReceipt :1];
//    NSString *receiptaa = [transaction.transactionReceipt base64Encoding];
////    NSLog(@"str=%@",str);
//    SKPayment *skp = transaction.payment;
//    NSString *productID = skp.productIdentifier;
//   
//    if (juhua) {
//        [juhua stopAnimating];
//    }
//    //1，创建会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
//    //2,根据会话创建task
//    NSURL *url = [NSURL URLWithString:@"http://u8svr.acingame.com/pay/apple/validate"];
//    //3,创建可变的请求对象
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //4,请求方法改为post
//    request.HTTPMethod = @"POST";
////    NSMutableDictionary *backInfo = [NSMutableDictionary dictionary];
////    NSString *dateStr = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
//    NSMutableDictionary *testInfo = [NSMutableDictionary dictionary];
//    [testInfo setObject:payInfo.orderID forKey:@"orderID"];
//    [testInfo setObject:transactionIdentifier forKey:@"transactionIdentifier"];
//    [testInfo setObject:productID forKey:@"productId"];
//    [testInfo setObject:receiptaa forKey:@"transactionReceipt"];
//    //5,设置请求体
//    NSLog(@"请求提=%@",[self getSignString:testInfo]);
//    NSLog(@"testInfo = %@",testInfo);
//    request.HTTPBody = [[self getHttpSing:testInfo] dataUsingEncoding:NSUTF8StringEncoding];
//    //6根据会话创建一个task（发送请求）
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        NSLog(@"code=%d",responseStatusCode);
//        NSLog(@"let us begin");
//        NSLog(@"testInfo = %@",testInfo);
//        
//        if (responseStatusCode==200) {
//            NSLog(@"发送成功");
//        }else{
//            NSLog(@"发送失败");
//            [self.receiptArray addObject:testInfo];
//            
//            if (self.timer==nil) {
//                [self createTimer];
//            }
//            
//            
//        }
//        if (juhua) {
//            [juhua stopAnimating];
//        }
////        NSLog(@"post支付回调 dic = %@",dic);
//        
//    }];
//    if (juhua) {
//        [juhua stopAnimating];
//    }
//    [dataTask resume];
//}
//    
    


- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [ProgressHUD dismiss];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [ProgressHUD dismiss];
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
       // value = [self encodeString:value];
        if (i==0) {
            
            str = [NSString stringWithFormat:@"%@=%@",key,value] ;
            
        }else{
            
            str = [NSString stringWithFormat:@"%@&%@=%@",str,key,value];
        }
        
    }
    
    return str;
}
- (NSString *)getSignString:(NSMutableDictionary *)dic
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
      //  value = [self encodeString:value];
        if (i==0) {
            
            str = [NSString stringWithFormat:@"%@",value] ;
            
        }else{
            
            str = [NSString stringWithFormat:@"%@%@",str,value];
        }
        
    }
    
    return str;
}

+ (nullable NSString *)md5String:(nullable NSString *)str {
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

-(NSString*)encodeString:(NSString*)unencodedString{
    
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)unencodedString,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));

    
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return encodedString;
}
@end
