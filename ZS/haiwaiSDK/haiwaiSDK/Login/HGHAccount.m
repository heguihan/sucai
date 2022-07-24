//
//  HGHAccount.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHAccount.h"
#import <UIKit/UIKit.h>
#import "HGHTools.h"



@implementation HGHAccount

+(instancetype)shareinstance
{
    static HGHAccount *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[HGHAccount alloc]init];
    });
    
    return account;
}

-(void)gotoAccount
{
//    HGHAccount *acc = [self shareinstance];
    self.redview = [[UIView alloc]initWithFrame:CGRectMake(XPOINT, YPOINT, VIEWWIDTH, VIEWHEIGHT)];
    UIViewController *cuvc = [HGHTools getCurrentViewcontronller];
    [cuvc.view addSubview:self.redview];
    
    self.redview.backgroundColor = [UIColor redColor];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.redview addSubview:closeBtn];
}

-(void)closebtn:(UIButton *)sender
{
    NSLog(@"关闭");
    [self.redview removeFromSuperview];
}

+(void)closebtn:(UIButton *)sender
{
    NSLog(@"类方法");
    [sender.superview removeFromSuperview];
}


@end
