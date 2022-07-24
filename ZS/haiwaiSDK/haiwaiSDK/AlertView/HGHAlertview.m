//
//  HGHAlertview.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHAlertview.h"
#import <UIKit/UIKit.h>
@implementation HGHAlertview

+(instancetype)shareInstance
{
    static HGHAlertview *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[super alloc] init];
    });
    
    return alert;
}

+(void)showAlertViewWithMessage:(NSString *)msg
{
    NSLog(@"msg=%@",msg);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:GuoJiHua(@"警告") message:msg delegate:nil cancelButtonTitle:GuoJiHua(@"确认操作") otherButtonTitles:nil];
    [alertView show];
}

@end
