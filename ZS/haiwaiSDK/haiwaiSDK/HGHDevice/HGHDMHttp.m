//
//  HGHDMHttp.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/11/28.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHDMHttp.h"
#import "HGHExchange.h"
@implementation HGHDMHttp
+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    
//    NSLog(@"url=%@",URL);
//    NSString *signBe =@"";
//    NSLog(@"signBe=%@",signBe);
//    NSString *sign = [HGHExchange md5:signBe];
//    NSLog(@"sign=%@",sign);
//    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
//    [mutableDict setObject:sign forKey:@"sign"];
    NSLog(@"dict device上报 =%@",dict);
    NSString *resultParamStr = [HGHExchange exchangeStringWithdict:dict];
    NSLog(@"resultParamStr=%@",resultParamStr);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:500];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[resultParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
            failure(connectionError);
        }
    }];
}
@end
