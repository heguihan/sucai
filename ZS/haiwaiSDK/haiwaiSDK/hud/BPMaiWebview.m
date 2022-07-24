//
//  BPMaiWebview.m
//  YingSDK
//
//  Created by SkyGame on 2018/6/27.
//  Copyright © 2018年 John Cheng. All rights reserved.
//

#import "BPMaiWebview.h"

@interface BPMaiWebview ()<UIWebViewDelegate>

{
//    BPOrderInfo *orderInfoList;
    
}

@end

@implementation BPMaiWebview



static BPMaiWebview *methodView =nil;

+(BPMaiWebview *)shareInstance{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        methodView = [[BPMaiWebview alloc] init];
        
        
    });
    return methodView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor redColor];
        self.tag = 757575;
//        orderInfoList = [[BPOrderInfo alloc]init];
    }
    return self;
}



-(void) showProtol:(NSString *)protolStr
{
//    orderInfoList = orderInfo;

    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 30, 40)];
//    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIWebView *webview = [[UIWebView alloc]initWithFrame:self.bounds];
    
    
    
    
    webview.delegate = self;
    [self addSubview:webview];
    [self addSubview:backBtn];
//    [self addSubview:leftButton];
    NSLog(@"full url is =%@",protolStr);
    NSURL *url = [NSURL URLWithString:protolStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"loading...");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}
-(void)clickCancelButtonAction
{
    NSLog(@"关闭");
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}




@end
