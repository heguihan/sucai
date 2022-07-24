//
//  AWWebview.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/10.
//

#define CHANGELOGIN                     @"changeLogin"
#define CHANGEPASSWORD                  @"changePassword"
#define CERTIFICATION                   @"certification"
#define BINDPHONE                       @"bindPhone"
#define LOGINFAILURE                    @"loginFailure"
#define OPENBROWSER                     @"openBrowser"
#define REPORTEVENT                     @"reportEvent"
#define RESETLOGFLAG                    @"resetLogFlag"       //删掉了 不用
#define BINDWX                          @"bindWX"
#define STARTAPPLICATION                @"startApplication"
#define SETACCOUNTALIAS                 @"setAccountAlias"
#define TOAST                           @"toast"
#define SHOWHINTMSG                     @"showHintMsg"
#define QUERYROLLMSG                    @"queryRollMsg"
#define SHARE                           @"share"
#define CLOSEFLOATING                   @"closeFloatBall"
#define SHOWFLOATING                    @"showFloatBall"
#define SYNCPWD                         @"syncPassWord"
#define REALNAMEAUTH                    @"isCertification"
#define SHARELINKTOWEIXIN               @"weChatShareUrl"
#define SHAREPICTOWEIXIN                @"weChatSharePicture"
#define CALLBACKURL                     @"callBackFloatUrl"         //h5返回路由
#define SYNCBINDPHONE                   @"syncBindPhone"
#define SENDEMAIL                       @"sendEmail"
#define STARTTEL                        @"startTel"

#import "AWWebview.h"
#import <WebKit/WebKit.h>
#import "AWWebBridge.h"

@interface AWWebview()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webview;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@end

@implementation AWWebview

//+(instancetype)factory_webviewWithUrl:(NSString *)urlStr
//{
//    AWWebview *
//}

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

    
//    [self.webview evaluateJavaScript:@"awsdk" completionHandler:nil];
    
    [self.webview loadRequest:request];

    
}

//reloadwebview
-(void)reloadwebview
{
    
    [self.webview reload];
}

-(void)reSizeWebView
{
    self.webview.frame = self.bounds;
}

#pragma mark 懒加载
-(WKWebView *)webview
{
    if (!_webview) {
        _webview = [[WKWebView alloc]initWithFrame:self.bounds configuration:self.wkConfig];
        _webview.scrollView.bounces = NO;
        
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.userContentController = [[WKUserContentController alloc] init];
        // 注册交互对象
        NSArray *methodArr = @[SHARE,CHANGELOGIN,CHANGEPASSWORD,CERTIFICATION,BINDPHONE,
                               LOGINFAILURE,OPENBROWSER,REPORTEVENT,RESETLOGFLAG,
                               BINDWX,STARTAPPLICATION,SETACCOUNTALIAS,TOAST,SHOWHINTMSG,QUERYROLLMSG,CLOSEFLOATING,SHOWFLOATING,SYNCPWD,REALNAMEAUTH,SHARELINKTOWEIXIN,SHAREPICTOWEIXIN,CALLBACKURL,SYNCBINDPHONE,SENDEMAIL,STARTTEL
        ];
        
        for (NSString *methodStr in methodArr) {
            [_wkConfig.userContentController addScriptMessageHandler:self name:methodStr];
        }
//        [_wkConfig.userContentController addScriptMessageHandler:self name:@"changeLogin"];
//        [_wkConfig.userContentController addScriptMessageHandler:self name:@"changePassword"];
        _wkConfig.processPool = [[WKProcessPool alloc] init];
        
    }
    return _wkConfig;
}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    AWLog(@"方法名：%@", message.name);
    AWLog(@"参数：%@", message.body);
    if ([message.name isKindOfClass:[NSString class]]) {

    }
    if ([message.name isEqualToString:@"resetLogFlag"]) {
        AWLog(@"找到你了");
    }
    
    NSString *methodStr = [NSString stringWithFormat:@"%@:",message.name];
    NSMethodSignature *signature = [[AWWebBridge class] methodSignatureForSelector:@selector(test:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = [AWWebBridge class];
    SEL selectorx = NSSelectorFromString(methodStr);
    invocation.selector = selectorx;
    id args = message.body;
    NSArray *arr = args;
    args = arr[0];
    if ([args isKindOfClass:[NSString class]]) {
        args = [AWTools jsonStrtodictWithStr:args];
    }
    if (!args) {
        args = message.body;
    }
    if ([args isKindOfClass:[NSArray class]]) {
        
    }
    
    [invocation setArgument:&args atIndex:2];
    [invocation invoke];
    
    
    
}





- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    AWLog(@"message=%@",message);
    completionHandler();
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
    
//    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];


//    [self presentViewController:alertController animated:YES completion:nil];
}

//

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{



    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;

    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];

    //读取wkwebview中的cookie

    for (NSHTTPCookie *cookie in cookies) {

    // 这里就是你需要的cookie
        AWLog(@"name=%@ value=%@",cookie.name,cookie.value);

    }

    decisionHandler(WKNavigationResponsePolicyAllow);

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    AWLog(@"did finished");
    NSString *jsStr = @"var awsdk = new Object();";
    [self.webview evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        AWLog(@"xxxxxxxx%@, error=%@",obj,error);
    }];
    
}





@end
