//
//  HGHTranslation.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/5/23.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHTranslation.h"

@implementation HGHTranslation
+(instancetype)shareinstance
{
    static HGHTranslation *tran = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tran = [[HGHTranslation alloc]init];
    });
    return tran;
}

-(NSInteger)registNum
{
    if (!_registNum) {
        _registNum = 10;
    }
    return _registNum;
}

-(NSInteger)forgotNum
{
    if (!_forgotNum) {
        _forgotNum = 60;
    }
    return _forgotNum;
}
@end
