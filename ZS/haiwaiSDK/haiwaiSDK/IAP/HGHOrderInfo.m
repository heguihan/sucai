//
//  HGHOrderInfo.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/7.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHOrderInfo.h"

@implementation HGHOrderInfo
+(instancetype)shareinstance
{
    static HGHOrderInfo *order = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        order = [[HGHOrderInfo alloc]init];
    });
    return order;
}
@end
