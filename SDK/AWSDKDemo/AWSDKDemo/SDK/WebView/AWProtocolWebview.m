//
//  AWProtocolWebview.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/9.
//

#import "AWProtocolWebview.h"
#import <WebKit/WebKit.h>


@interface AWProtocolWebview()
@property(nonatomic,strong)WKWebView *webview;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@end

@implementation AWProtocolWebview

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configUIWithframe:frame];
    }
    return self;
}

-(void)configUIWithframe:(CGRect)frame
{
    [self addSubview:self.webview];
}


-(void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
//    _urlStr = @"https://gamecn-sdk.jxywl.cn/v8/Agreement?app_id=bdz83pnzenvqjr7l";
//    urlStr = @"http://game-cn.51shaha.com/v4/Redpacket?token=Nwle8nyzMiDAxMDkxMV8xNjA3Njc2NDYwX3NkazAwMTAxMDAzMDAO0O0O&gravity=left";
    NSURL *url = [NSURL URLWithString:urlStr];
    AWLog(@"url===%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self.webview loadRequest:request];

    
}



#pragma mark 懒加载
-(WKWebView *)webview
{
    if (!_webview) {
        _webview = [[WKWebView alloc]initWithFrame:self.bounds configuration:self.wkConfig];
        _webview.scrollView.bounces = NO;
        
//        _webview.UIDelegate = self;
//        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.userContentController = [[WKUserContentController alloc] init];
        _wkConfig.processPool = [[WKProcessPool alloc] init];
        
    }
    return _wkConfig;
}


@end
