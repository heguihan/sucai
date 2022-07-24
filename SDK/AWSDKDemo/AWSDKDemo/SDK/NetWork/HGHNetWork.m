//
//  HGHNetWork.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHNetWork.h"
#import "HGHExchange.h"
#import "AWSocketManager.h"
#import "urls.h"

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



+(void)POSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *signToContent = [HGHExchange getSignStrWithDict:dict];
    NSString *secret = [AWConfig CurrentAppKey];
    NSString *signBe = [NSString stringWithFormat:@"%@%@",signToContent,secret];
    NSString *sign = [HGHExchange md5:signBe];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [mutableDict setObject:sign forKey:@"sign"];
//    [mutableDict setObject:[AWUserInfoManager shareinstance].account forKey:@"user_id"];
    NSString *resultParamStr = [HGHExchange exchangeStringWithdict:mutableDict];
    NSString *allUrl = [NSString stringWithFormat:@"%@?%@",URL,resultParamStr];
    AWLog(@"allUrl=%@",allUrl);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrl] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    [request setHTTPMethod:@"GET"];
    [request setValue:GUOJIHUA(@"langeCode") forHTTPHeaderField:@"accept-language"];
//    NSData*paraData=[resultParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
//    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 500) {
            /////
        }
        if (data) {
            NSError *error;
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"str-===%@",str);
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (!dict) {
                failure(connectionError);
                return;
            }
            if ([dict[@"code"] intValue]==402) {
                [AWLoginViewManager forceLogoutWithMsg:dict[@"msg"]];
                return;
            }
            success(dict);
            
        }else
        {
            AWLog(@"%@",connectionError);
            failure(connectionError);
            NSLog(@"网络繁忙 allurl===%@",allUrl);
            [AWTools makeToastWithText:GUOJIHUA(@"网络错误")];
        }
    }];
}

+(void)POSTNEWVerSion:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *signToContent = [HGHExchange getSignStrWithDict:dict];
    NSString *secret = [AWConfig CurrentAppKey];
    NSString *signBe = [NSString stringWithFormat:@"%@%@",signToContent,secret];
    NSString *sign = [HGHExchange md5:signBe];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [mutableDict setObject:sign forKey:@"sign"];
    [mutableDict setObject:[AWUserInfoManager shareinstance].account forKey:@"user_id"];
    NSString *resultParamStr = [HGHExchange exchangeStringWithdict:mutableDict];
    NSString *allUrl = [NSString stringWithFormat:@"%@?%@",URL,resultParamStr];
    AWLog(@"allUrl=%@",allUrl);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:allUrl] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    [request setHTTPMethod:@"GET"];
    
//    NSData*paraData=[resultParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
//    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 500) {
            /////
        }
        if (data) {
            NSError *error;
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"str-===%@",str);
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (!dict) {
                failure(connectionError);
                return;
            }
            if ([dict[@"code"] intValue]==402) {
                [AWLoginViewManager forceLogoutWithMsg:dict[@"msg"]];
                return;
            }
            success(dict);
            
        }else
        {
            AWLog(@"%@",connectionError);
            failure(connectionError);
            NSLog(@"网络繁忙 allurl===%@",allUrl);
            [AWTools makeToastWithText:GUOJIHUA(@"网络错误")];
        }
    }];
}


+(void)POSTPOSTNEW:(NSString*)URL paramString:(NSDictionary*)dict ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *signToContent = [HGHExchange getSignStrWithDict:dict];
    NSString *secret = [AWConfig CurrentAppKey];
    NSString *signBe = [NSString stringWithFormat:@"%@%@",signToContent,secret];
    NSString *sign = [HGHExchange md5:signBe];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [mutableDict setObject:sign forKey:@"sign"];
    NSString *resultParamStr = [HGHExchange exchangeStringWithdict:mutableDict];
    NSString *allUrl = [NSString stringWithFormat:@"%@?%@",URL,resultParamStr];
    AWLog(@"allUrl=%@",allUrl);
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[resultParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSError *error;
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"str-===%@",str);
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (!dict) {
                failure(connectionError);
                return;
            }
            if ([dict[@"code"] intValue]==402) {
                [AWLoginViewManager forceLogoutWithMsg:dict[@"msg"]];
                return;
            }
            success(dict);
            
        }else
        {
            AWLog(@"%@",connectionError);
            failure(connectionError);
            [AWTools makeToastWithText:@"网络繁忙"];
        }
    }];
}


//本地日志上报
+(void)POSTReportRequestWithURL:(NSString *)urlSTr param:(NSString *)jsonStr ifSuccess:(void(^)(NSInteger response))success
{
    NSString *urlStr = @"https://collect-test.awgame.cn/api/v1/event";
    urlStr = @"https://collect-dc.awgame.cn/api/v1/event";
    urlStr = URLREPORTDOMAIN;
    urlStr = [NSString stringWithFormat:@"%@%@",URLREPORTDOMAIN,@"/api/v1/event"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *dcKey = [AWSDKConfigManager shareinstance].dc_key;
    NSString *aliasx = [AWSDKConfigManager shareinstance].dc_alias;
    if (!dcKey) {
        success(400);
        return;
    }
    if (!aliasx) {
        success(400);
        return;
    }
    
//    jsonStr = [NSString stringWithFormat:@"%@xxxxxxx",jsonStr];
//    aliasx = @"test";
    
    NSString *key = [AWTools decryptBase64StringToString:dcKey stringKey:[AWConfig CurrentAppKey]];

//    aliasx = @"test";
//    key = @"57FC4FED932D396900CFEAA48BE59326";

    
    NSString *aliasTime = [NSString stringWithFormat:@"%@_%@_",aliasx,[AWTools getCurrentTimeString]];
    NSString *signBe = [NSString stringWithFormat:@"%@%@_%@",aliasTime,jsonStr,key];
    NSString *signx = [HGHExchange md5:signBe];
    aliasTime = [NSString stringWithFormat:@"%@%@",aliasTime,signx];
    NSData *data = [aliasTime dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authori = [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    authori = [authori stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    authori = [authori stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    AWLog(@"url===%@",URLREPORTDOMAIN);
    AWLog(@"authori===%@",authori);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"close" forHTTPHeaderField:@"connection"];
    [request setValue:authori forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    AWLog(@"jsonxxx====%@",[jsonStr dataUsingEncoding:NSUTF8StringEncoding]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        AWLog(@"status http===%ld",(long)httpResponse.statusCode);
        if (data) {
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            AWLog(@"%@dict data=%@",dict,TAG_OK_HTTP);
            
        }
        success((long)httpResponse.statusCode);
    }];
    [task resume];
}

//游戏角色信息上报

+(void)POSTGameRoleReportRequestWithparam:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:CPLDOMAIN];
    NSString *cplKey = @"bde8b6beef7e";
    NSString *app_id = [AWConfig CurrentAppID];
    NSString *channelID = [AWConfig CUrrentCHannelID];
    NSString *idfa = [AWTools getIdfa];
    NSString *os = @"ios";
    NSString *openid = [AWUserInfoManager shareinstance].account;
    
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:params];
    
    NSString *signBefor = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",app_id,channelID,params[@"level"],openid,params[@"posttime"],params[@"serverid"],cplKey];
    NSString *sign = [HGHExchange md5:signBefor];
    [mutableDict setValue:app_id forKey:@"appid"];
    [mutableDict setValue:channelID forKey:@"channelid"];
    [mutableDict setValue:idfa forKey:@"imei"];
    [mutableDict setValue:os forKey:@"imei2"];
    [mutableDict setValue:[AWTools getUUID] forKey:@"oaid"];
    [mutableDict setValue:openid forKey:@"openid"];
    [mutableDict setValue:sign forKey:@"sign"];
    
    NSString *jsonStr = [self convertToJsonData:[mutableDict copy]];
    AWLog(@"jsonStr=%@",jsonStr);
    
    int cmd = 202;
    [AWSocketManager sendMsg:jsonStr Adntype:cmd];
    return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"close" forHTTPHeaderField:@"connection"];
//    [request setValue:authori forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        AWLog(@"status===%ld",(long)httpResponse.statusCode);
        if (data) {
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//            success(dict);
            AWLog(@"%@ dict data=%@",TAG_SDK_EVENT_GAME,dict);
            
        }
    }];
    [task resume];
}



//头条上报
+(void)POSTToutiaoReportRequest
{
    NSURL *url = [NSURL URLWithString:TOUTIAOREPORTDOMAIN];
    NSString *cplKey = @"bde8b6beef7e";
    NSString *app_id = [AWConfig CurrentAppID];
    NSString *channelID = [AWConfig CUrrentCHannelID];
    NSString *idfa = [AWTools getIdfa];
//    NSString *os = @"ios";
    NSNumber *os = @1;
//    NSString *openid = [AWUserInfoManager shareinstance].account;
    
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    
    
    NSString *signBefor = [NSString stringWithFormat:@"%@%@%@%@%@",app_id,channelID,idfa,os,cplKey];
    NSLog(@"signBefore==%@",signBefor);
    NSString *sign = [HGHExchange md5:signBefor];
    [mutableDict setValue:app_id forKey:@"app_id"];
    [mutableDict setValue:channelID forKey:@"channel"];
    [mutableDict setValue:idfa forKey:@"idfa"];
    [mutableDict setValue:os forKey:@"os"];
    [mutableDict setValue:sign forKey:@"sign"];
    
    NSString *jsonStr = [self convertToJsonData:[mutableDict copy]];
    AWLog(@"jsonStr=%@",jsonStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"close" forHTTPHeaderField:@"connection"];
//    [request setValue:authori forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        AWLog(@"status===%ld",(long)httpResponse.statusCode);
        if (data) {
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            AWLog(@"%@ dict data=%@",TAG_SDK_EVENT_GAME,dict);
            
        }
    }];
    [task resume];
}



+(NSString *)convertToJsonData:(NSDictionary *)dict
{

    NSError *error;
    AWLog(@"tools datatojson");
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        AWLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}


+(id)jsontoother:(NSString *)json
{
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        //json解析
        id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        return obj;
}

@end
