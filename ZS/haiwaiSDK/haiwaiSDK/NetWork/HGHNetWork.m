//
//  HGHNetWork.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHNetWork.h"
#import "HGHAlertview.h"
#import "HGHExchange.h"
#import "HGHConfig.h"

@implementation HGHNetWork

+(instancetype)shareInstance
{
    static HGHNetWork *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[super alloc] init];
    });
    
    return network;
}
+(void)POST:(NSString*)URL paramString:(NSString*)paramString ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    
    NSLog(@"url=%@",URL);
    NSLog(@"param=%@",paramString);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dict);
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
//            [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
//            [HGHAlertview shareInstance]show
            [HGHAlertview showAlertViewWithMessage:@"网络连接失败"];
            failure(connectionError);
        }
    }];
}
+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    
    
    NSLog(@"请求方式=%@",request.HTTPMethod);
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.根据会话对象，创建一个Task任务：
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        if (data) {
            
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dict);
            });
        }else
        {
            NSLog(@"%@",error);
            failure(error);
        }
    }];
    [sessionDataTask resume];
}

+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    
    NSLog(@"url=%@",URL);
    NSString *signToContent = [HGHExchange getSignStrWithDict:dict];
    NSString *signBe = [NSString stringWithFormat:@"%@&key=%@",signToContent,[HGHConfig shareInstance].secret];
    NSLog(@"signBe=%@",signBe);
    NSString *sign = [HGHExchange md5:signBe];
    NSLog(@"sign=%@",sign);
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [mutableDict setObject:sign forKey:@"sign"];
    NSString *resultParamStr = [HGHExchange exchangeStringWithdict:mutableDict];
    NSLog(@"iapStr=%@",resultParamStr);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:500];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[resultParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"hghwwwwwwwaaaaa%@",dict);
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
            //            [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
            //            [HGHAlertview shareInstance]show
            [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"网络连接失败")];
            failure(connectionError);
        }
    }];
}



@end
