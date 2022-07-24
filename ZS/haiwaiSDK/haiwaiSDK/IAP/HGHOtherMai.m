//
//  HGHOtherMai.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/7/25.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHOtherMai.h"
#import <CommonCrypto/CommonDigest.h>
#import "HGHConfig.h"
#import "HGHFlyer.h"
@implementation HGHOtherMai
+(void)requestWithorderInfo:(HGHOrderInfo *)orderInfo
{
    NSString *PayUrl = @"https://hw.pay.acingame.com/payment/checkout/sdk";
    NSString *user_id=@"1906043349";
    NSString *role_id=orderInfo.roleID;
    NSString *server_id=orderInfo.server_id;
    NSString *product_id=orderInfo.product_id;
    NSString *app_id = [HGHConfig shareInstance].appID;
    NSString *amount=@"1";
    NSString *currency=@"USD";
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payPlatformData options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *trade_no=orderInfo.trade_no;
    NSString *subject=orderInfo.subject;
    NSString *body=orderInfo.body;
    NSString *timestamp=[self getTimeString];
//    NSString *sign=@"sss";
    NSString *idfa = [HGHFlyer getIDFA];
    NSString *appsflyerid = [HGHFlyer getAppsflyerID];
    NSDictionary *platformDic =@{@"appflyer":@{@"appsflyer_id":appsflyerid,@"idfa":idfa}
                                 };
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:platformDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *appsFlyer = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *nonce_str=@"rsasssssssssssssssssssss";
    NSDictionary *dict_sign = @{@"user_id":user_id,
                                @"role_id":role_id,
                                @"server_id":server_id,
                                @"app_id":app_id,
                                @"product_id":product_id,
                                @"amount":amount,
                                @"currency":currency,
                                @"trade_no":trade_no,
                                @"subject":subject,
                                @"body":body,
                                @"timestamp":timestamp,
                                @"platform":@"ios",
                                @"ad":appsFlyer,
                                @"nonce_str":nonce_str
                                };
    
    NSString *signToContent = [self getSignStrWithDict:dict_sign];
    NSString *signBe = [NSString stringWithFormat:@"%@&key=%@",signToContent,[HGHConfig shareInstance].secret];
    NSString *sign_result = [self md5String:signBe];
    NSLog(@"signbefore=%@,  sign_result=%@",signBe,sign_result);
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&role_id=%@&server_id=%@&app_id=%@&product_id=%@&amount=%@&currency=%@&trade_no=%@&subject=%@&body=%@&timestamp=%@&sign=%@&nonce_str=%@",user_id,role_id,server_id,app_id,product_id,amount,currency,trade_no,subject,body,timestamp,sign_result,nonce_str];
    NSString *fullUrl = [NSString stringWithFormat:@"%@?%@",PayUrl,params];
    NSLog(@"fullUrl=%@",fullUrl);
    NSString *urlEncode = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlEncode=%@",urlEncode);
    NSMutableURLRequest *requestH = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlEncode] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [[UIApplication sharedApplication] openURL:requestH.URL];
}

+(NSString *)getSignStrWithDict:(NSDictionary *)dict
{
    NSArray *keys = dict.allKeys;
    NSLog(@"keys=%@",keys);
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    NSLog(@"keys_new=%@",keys);
    NSString *resultStr = @"";
    for (NSString *key in keys) {
        NSLog(@"key=%@,value=%@",key,dict[key]);
        if (dict[key]==nil||[[NSString stringWithFormat:@"%@",dict[key]] isEqualToString:@""]) {
            NSLog(@"key=%@, and value=%@",key,dict[key]);
            continue;
        }
        resultStr = [NSString stringWithFormat:@"%@&%@=%@",resultStr,key,dict[key]];
    }
    //    NSString *newResultStr=[resultStr dele]
    NSMutableString *mutableStr = [NSMutableString stringWithString:resultStr];
    [mutableStr deleteCharactersInRange:NSMakeRange(0, 1)];
    NSLog(@"mutableStr=%@",mutableStr);
    //    NSLog(@"resultStr=%@",resultStr);
    return mutableStr;
    
}

+(NSString *)getTimeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

+(NSString *) md5String:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
