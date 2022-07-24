//
//  HGHTourists.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHTourists.h"
#import "HGHHttprequest.h"
#import "HGHTools.h"
#import "HGHAccessApi.h"
@implementation HGHTourists

+(instancetype)shareInstance
{
    static HGHTourists *tourists = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tourists = [[HGHTourists alloc]init];
    });
    return tourists;
}

+(void)touristsLogin
{
    NSLog(@"uuid=%@",[HGHTools getUUID]);
    [[self shareInstance] touristsWithuuid:[HGHTools getUUID] type:@"1" tp:@"shabi"];
}

-(void)touristsWithuuid:(NSString *)imei type:(NSString *)type tp:(NSString *)tp
{
    [[HGHHttprequest shareinstance]touristsWithuuid:imei type:type tp:tp ifSuccess:^(id  _Nonnull response) {
        //
        [HGHAccessApi shareinstance].loginBackBlock(response);
    } failure:^(NSError * _Nonnull error) {
        //
//        [HGHAccessApi shareinstance].logoutBackBlock();
        NSLog(@"error=%@",error);
    }];
    
}
@end
