//
//  AWUserProtcolView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWUserProtocolView.h"
//#import "AWWebview.h"
#import "AWProtocolWebview.h"

@interface AWUserProtocolView()
@property(nonatomic, strong)NSString *protocolName;
@property(nonatomic, strong)NSString *urlstr;

@end

@implementation AWUserProtocolView


+(instancetype)factory_userProtocolWithKey:(NSString *)key
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-100;
    CGFloat height = SCREENHEIGHT -40;
    AWUserProtocolView *userProtocolV = [[AWUserProtocolView alloc]initWithFrame:CGRectMake(50, 20, width, height)];
    [userProtocolV configUIWithKey:key];
    return userProtocolV;
}

//横屏
-(void)configUIWithKey:(NSString *)protocolKey
{
    NSArray *linkList = [AWSDKConfigManager shareinstance].link;
    NSString *linkStr = @"";
    if (linkList.count>0) {
        for (NSDictionary *dic in linkList) {
            if ([dic.allKeys containsObject:@"key"]) {
                if ([dic[@"key"] isEqualToString:protocolKey]) {
                    linkStr = dic[@"url"];
                }
            }
        }
    }
    
    NSDictionary *dict = @{@"Agreement":GUOJIHUA(@"用户协议"),@"Privacy":GUOJIHUA(@"隐私协议")};
    self.protocolName = [dict objectForKey:protocolKey];
    self.urlstr = linkStr;
    
    if ([AWTools DeviceOrientation] ==3) {
        [self addPortrait];
    }else{
        [self addLandscape];
    }

}

//横屏
-(void)addLandscape
{
    
    CGFloat lWidth = SCREENWIDTH*2/3.0;
    CGFloat lHeight = SCREENHEIGHT - 40;
    CGFloat lX = (SCREENWIDTH -lWidth)/2.0;
    CGFloat lY = (SCREENHEIGHT-lHeight)/2.0;
    
    CGRect frame = self.frame;
    frame.size.width = lWidth;
    frame.size.height = lHeight;
    frame.origin.x = lX;
    frame.origin.y = lY;
    self.frame = frame;
    
    CGFloat viewwidth = self.frame.size.width;
    CGFloat logoWidth = AdaptWidth(84);
    CGFloat logoHeight = AdaptWidth(36);
    
    UIImageView *logoview = [AWSmallControl getLogoView];
    logoview.frame =CGRectMake(viewwidth/2.0-logoWidth-14, AdaptWidth(16), logoWidth, logoHeight);
    
//    UIImageView *logoview = [[UIImageView alloc]initWithFrame:CGRectMake(viewwidth/2.0-logoWidth-14, AdaptWidth(16), logoWidth, logoHeight)];
//    NSString *logoImageNmae = [AWGlobalDataManage shareinstance].wholeLogoName;
//    logoview.image = [UIImage imageNamed:logoImageNmae];
//    logoview.image = [UIImage imageNamed:@"AWSDK.bundle/logo.png"];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(16), TFWidth, logoHeight)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = FONTSIZE(20);
    titleLab.textColor = RGBA(100, 107, 116, 1);
    titleLab.text = self.protocolName;
    

    
    CGFloat webviewheight = AdaptWidth(170);

    webviewheight = lHeight - AdaptWidth(70) - TFHeight - AdaptWidth(20);
    AWProtocolWebview *webview = [[AWProtocolWebview alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(70), viewwidth-MarginX*2, webviewheight)];
    
    
    CGFloat btnwidth = AdaptWidth(233);
    AWOrangeBtn *agreeBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake((viewwidth-btnwidth)/2.0, AdaptWidth(80)+webviewheight, btnwidth, TFHeight)];
    [agreeBtn setTitle:GUOJIHUA(@"同意") forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(clickAgree) forControlEvents:UIControlEventTouchUpInside];
    
    webview.urlStr = self.urlstr;
    [self addSubview:webview];
    
    
//    [self addSubview:logoview];
    [self addSubview:titleLab];
    [self addSubview:agreeBtn];
}

//竖屏
-(void)addPortrait
{
    
    CGFloat pWidth = SCREENWIDTH-40;
    CGFloat pHeight = SCREENHEIGHT*2/3.0;
    CGFloat pX = (SCREENWIDTH -pWidth)/2.0;
    CGFloat pY = (SCREENHEIGHT-pHeight)/2.0;
    CGRect frame = self.frame;
    frame.size.width = pWidth;
    frame.size.height = pHeight;
    frame.origin.x = pX;
    frame.origin.y = pY;
    self.frame = frame;
    
    CGFloat viewwidth = self.frame.size.width;
    CGFloat logoWidth = AdaptWidth(94);
    CGFloat logoHeight = AdaptWidth(36);
    
    UIImageView *logoview = [AWSmallControl getLogoView];
    logoview.frame =CGRectMake(viewwidth/2.0-logoWidth-14, AdaptWidth(16), logoWidth, logoHeight);
    
//    UIImageView *logoview = [[UIImageView alloc]initWithFrame:CGRectMake(viewwidth/2.0-logoWidth-14, AdaptWidth(16), logoWidth, logoHeight)];

//    NSString *logoImageNmae = [AWGlobalDataManage shareinstance].wholeLogoName;
//    logoview.image = [UIImage imageNamed:logoImageNmae];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(16), TFWidth, logoHeight)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = FONTSIZE(20);
    titleLab.textColor = RGBA(100, 107, 116, 1);
    titleLab.text = self.protocolName;
    
    CGFloat btnwidth = AdaptWidth(233);
    CGFloat btnYY = frame.size.height - TFHeight -10;
    AWOrangeBtn *agreeBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake((viewwidth-btnwidth)/2.0, btnYY, btnwidth, TFHeight)];
    [agreeBtn setTitle:GUOJIHUA(@"同意") forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(clickAgree) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat webviewheight = AdaptWidth(180);
    webviewheight = pHeight - logoHeight - AdaptWidth(16) - TFHeight - AdaptWidth(50);
    
    AWProtocolWebview *webview = [[AWProtocolWebview alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(80), viewwidth-MarginX*2, webviewheight)];
    webview.urlStr = self.urlstr;
    [self addSubview:webview];
    
    
//    [self addSubview:logoview];
    [self addSubview:titleLab];
    [self addSubview:agreeBtn];
}


-(void)clickAgree
{
//    [self gobackFromSelfView];
    [self removeFromSuperview];
    [[AWViewManager shareInstance].protoclFutherview removeFromSuperview];
}

-(void)show
{
    [[AWViewManager shareInstance].protoclFutherview addSubview:self];
//    [WHOLEVIEW addSubview:self];
}

@end
