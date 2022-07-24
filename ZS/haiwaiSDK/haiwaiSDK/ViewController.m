//
//  ViewController.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "ViewController.h"
#import "HGHLogin.h"
#import "HGHRegister.h"
#import "HGHEmailBand.h"
#import "HGHForgotPassword.h"
#import "HGHChangePassword.h"
#import "HGHBindAccount.h"
#import "HGHHttprequest.h"
#import "HGHExchange.h"
#import "HGHTools.h"
#import "HGHGoogleLoginViewController.h"
#import "HGHAccessApi.h"
#import "HGHIAPManager.h"
#import "HGHOrderInfo.h"
#import <Foundation/Foundation.h>
#import "HGHLoginAlertview.h"
#import "HGHUIFrame.h"
#import "HGHConfig.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HGHAccessApi SDKinit];
      
    [HGHAccessApi initSDKWithAppid:@"1902183084" appsecret:@"0ead9f831261024a71fbe77c42f33e70"];

    [self creatUI];
}

-(void)creatUI
{
    if (SCREEN_IS_LANDSCAPE||SCREEN_IS_LANDSCAPE) {
        NSLog(@"横屏");
    }else
    {
        NSLog(@"竖屏");
    }
    
    NSArray *arr = @[@"登录",@"支付",@"注册",@"登出",@"绑定",@"其他测试"];
    for (int i=0; i<6; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100+100*i, 100, 50)];
        btn.backgroundColor = [UIColor orangeColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    [HGHAccessApi logout:^(NSString * _Nonnull result) {
//        NSLog(@"result=%@",result);
//    }];
    [HGHAccessApi logoutCallback:^(NSString * _Nonnull result) {
        NSLog(@"result=%@",result);
    }];
    
    
}


-(void)click:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            //登录
            NSLog(@"开始登录");
            [self login];
            break;
        case 101:
            //支付
            NSLog(@"开发功能测试");
            [self pay];
            break;
        case 102:
            //其他
            NSLog(@"注册");
            [self regist];
            break;
        case 103:
            //登录
            NSLog(@"登出");
            [self logout];
            break;
        case 104:
            //支付
            NSLog(@"绑定");
            [self bind];
            break;
        case 105:
            //其他
            NSLog(@"测试");
            [self test];
            break;
            
        default:
            break;
    }
}


-(void)testWidth
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"width=%f,height=%f",screenWidth,screenHeight);
}
-(void)login
{
//    [self testWidth];
    
    [HGHAccessApi login:^(NSDictionary * _Nonnull loginInfo) {
        NSDictionary *dict = loginInfo;
        NSLog(@"dictUserInfo=%@",dict);
    }];
//    [self testFoundation];
//    [self testipa];
//    [self testnet];
//    [HGHConfig getFacebookClose];
//    [HGHConfig getGoogleClose];
//    [HGHConfig getGuestClose];
}

-(void)testnet
{
//    NSDictionary *dict = @{@"user_id"}
}

-(void)testipa
{
    HGHOrderInfo *orderInfo = [HGHOrderInfo shareinstance];
    orderInfo.server_id = @"111";
    orderInfo.product_id = @"com.acingame.afkmaster.601";  //com.acingame.afkmaster.601
    orderInfo.amount = @"6";
    orderInfo.currency = @"SNY";
    orderInfo.trade_no = @"123456789078766";
    orderInfo.subject = @"ssss";
    orderInfo.body = @"qqqqq";
    [[HGHIAPManager shareinstance] requestIAPWithOrderInfo:orderInfo];
}

-(void)testFoundation
{
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor redColor];
    label.numberOfLines=1;
    label.text = @"测试的是啊但是但是多所多ad是ad";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [self.view addSubview:label];
    [label setFrame:CGRectMake(200, 100, textSize.width, textSize.height)];
}

-(void)pay
{
    [self testipa];
//    [self testFoundation];
//    [self testalert];
//    [self testUUIDxxx];
    
    
}

-(void)testUUIDxxx
{
    NSString *uuid = [HGHTools getUUID];
    NSLog(@"uuid=%@",uuid);
}

-(void)testalert
{
//    [[HGHLoginAlertview shareinstance]showLoginmeg:@"xxxxxxaa"];
    NSString *uuid = [HGHTools getUUID];
    NSLog(@"uuid=%@",uuid);
}
-(void)regist
{
//    [HGHRegister regist];
//    [[HGHForgotPassword shareInstance] gotoForgotPassword];
    NSString *loginStr = NSLocaleLanguageCode;
    NSLog(@"langxxx=%@",loginStr);
    
//    NSString *loginStr = NSLocalizedString(@"登录", nil);
//    NSLog(@"sssss=%@",loginStr);
//    NSString *loginxx = GuoJiHua(@"登录");
//    NSLog(@"loginxxxx=%@",loginxx);
    
    
    [self testFunction];
}

-(void)testFunction
{
//    CGFloat *screenW = screenW;
//    NSLog(@"screenW=%lf",SCREENWIDTH);
    [[HGHLoginAlertview shareinstance] showLoginmeg:@"222211111"];
}


-(void)logout
{
    
}
-(void)bind
{
    
}
-(void)test
{
    NSString *ipaddress = [self deviceWANIPAdress];
    NSLog(@"ipaddress=%@",ipaddress);
}


-(NSString *)deviceWANIPAdress
{
    
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"mutableIP=%@",ip);
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict=%@",dict);
        return dict[@"cip"];
    }
    return nil;
}

@end
