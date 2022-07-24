//
//  HGHExchange.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHExchange.h"

@implementation HGHExchange
+ (NSString *)exchangeStringWithdict:(NSDictionary *)dict
{
//    NSArray *keysArray = [dict allKeys];
    NSLog(@"dict=%@",dict);
    
    NSString *paramStr = @"";
    for (NSString *key in dict) {
        NSLog(@"key=%@ andValue=%@",key,dict[key]);
        if (dict[key]==nil) {
            NSLog(@"kong key=%@",key);
            continue;
        }
        paramStr = [NSString stringWithFormat:@"%@%@=%@&",paramStr,key,dict[key]];
    }
    NSString *resutlStr = [paramStr substringWithRange:NSMakeRange(0, [paramStr length]-1)];
    return resutlStr;
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


+ (nullable NSString *)md5:(nullable NSString *)str {
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
@end
