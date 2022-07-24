//
//  HGHRegister.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHRegister.h"
#import "HGHExchange.h"
#import "HGHNetWork.h"
@implementation HGHRegister
+(instancetype)shareinstance
{
    static HGHRegister *regist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regist = [[HGHRegister alloc]init];
    });
    return regist;
}

+(void)regist
{
//    [[HGHRegister shareinstance] registWithUserName:@"shushizhizhang@qq.com" password:@"1234567890" device:@"123456"];
}

-(void)registWithUserName:(NSString *)userName password:(NSString *)password device:(NSString *)device
{
    NSDictionary *dict = @{@"username":userName,
                           @"password":password,
                           @"imei":device
                           };
    NSString *resultStr = [HGHExchange exchangeStringWithdict:dict];
    NSString *regist = [NSString stringWithFormat:@"%@%@",URL_DOMAIN,URL_REGISTER];
    [HGHNetWork POSTNEW:regist paramString:dict ifSuccess:^(id  _Nonnull response) {
//        NSLog(@"register=%@",response);
        NSDictionary *userDict = response;
        NSLog(@"userDict=%@",userDict);
        if ([userDict[@"code"] intValue]!=1) {
            NSLog(@"错误");
        }else{
            NSDictionary *userData = userDict[@"data"];
            NSString *token = userData[@"token"];
            NSString *userId = userData[@"userId"];
        }
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"regist error");
    }];
}
@end
