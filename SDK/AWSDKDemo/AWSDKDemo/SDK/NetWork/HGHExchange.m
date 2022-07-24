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
    NSString *paramStr = @"";
    for (NSString *key in dict) {
        if (dict[key]==nil) {
            continue;
        }
        paramStr = [NSString stringWithFormat:@"%@%@=%@&",paramStr,key,[self encodeString:dict[key]]];
    }
    NSString *resutlStr = [paramStr substringWithRange:NSMakeRange(0, [paramStr length]-1)];
    return resutlStr;
}

+(NSString *)getSignStrWithDict:(NSDictionary *)dict
{
    NSArray *keys = dict.allKeys;
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    NSString *resultStr = @"";
    for (NSString *key in keys) {
        if (dict[key]==nil||[[NSString stringWithFormat:@"%@",dict[key]] isEqualToString:@""]) {
//            continue;
            
        }
        resultStr = [NSString stringWithFormat:@"%@&%@=%@",resultStr,key,dict[key]];
    }
//    NSString *newResultStr=[resultStr dele]
    NSMutableString *mutableStr = [NSMutableString stringWithString:resultStr];
    [mutableStr deleteCharactersInRange:NSMakeRange(0, 1)];
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


//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                    (CFStringRef)unencodedString,
                     NULL,
                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                     kCFStringEncodingUTF8));
    
    return encodedString;
}

@end
