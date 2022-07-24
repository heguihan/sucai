//
//  AWUserCenterView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWUserCenterView.h"
#import "HGHShowBall.h"
#import "AWWebview.h"

#define WEBHEIGHT 465

@interface AWUserCenterView()
@property(nonatomic, strong)AWWebview *webview;
@property(nonatomic, strong)UIView *closeView;
@property(nonatomic, strong)UIButton *zoomBtn;

@property(nonatomic, assign)CGRect smallCloseFrame;
@property(nonatomic, assign)CGRect smallWebviewFrame;
@property(nonatomic, assign)CGRect smallZoomBtnFrame;
@property(nonatomic, assign)CGRect smallSelfFrame;
@end

@implementation AWUserCenterView

+(instancetype)factory_usercenterview
{
    CGFloat marginXX = 0;  //这里要分刘海屏做调整  横竖屏  刘海不用试配了H5那边做了
    CGFloat addcloseWidth = 25;
    //横屏
    CGFloat webWidth=465 + addcloseWidth;
    CGFloat webheight = SCREENHEIGHT;
    CGFloat weby = 0;
    NSString *gravity = [AWConfig Currentgravity];
    if ([AWTools DeviceOrientation]==3) {
        //竖屏
        if ([gravity isEqualToString:@"bottom"]) {
            webWidth = SCREENWIDTH;
            webheight = 465 + addcloseWidth;
            weby = SCREENHEIGHT - webheight;
        }else{
            webWidth = SCREENWIDTH;
            webheight = 465 + addcloseWidth;
            weby = 0;
        }
    }else
    {
        //横屏
        if (IphoneX&&[AWTools DeviceOrientation]==1) {
            NSLog(@"刘海左");
            marginXX = -44;
        }else if (IphoneX&&[AWTools DeviceOrientation]==2){
            NSLog(@"刘海右");
            marginXX = -14;
        }
        
    }
    AWUserCenterView *usercenter = [[AWUserCenterView alloc]initWithFrame:CGRectMake(marginXX, weby, webWidth, webheight)];
    [usercenter noticeScreen];
    [usercenter configUI];
    return usercenter;
}

-(void)noticeScreen
{
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

- (void)orientationChanged:(NSNotification *)note  {
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    CGRect frame = self.frame;
    switch (o) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
//            [self  rotation_icon:0.0];
            break;
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
//            [self  rotation_icon:180.0];
            break;
        case UIDeviceOrientationLandscapeLeft:      // Device oriented horizontally, home button on the right
            frame.origin.x = 0;
            if (IphoneX) {
                frame.origin.x = -14;
            }
            self.frame = frame;
 
            break;
        case UIDeviceOrientationLandscapeRight:
            frame.origin.x = -44;
            if (IphoneX) {
                self.frame = frame;
            }
            break;
        default:
            break;
    }
 }


-(void)configUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addWebview];
}


-(void)addWebview
{
    CGFloat closeHeight = 90;
    CGFloat closeWidth = 15;
    CGFloat marginb = 10;
    
    UIView *closeView = [[UIView alloc]init];
    closeView.backgroundColor = [UIColor clearColor];
    closeView.backgroundColor = [UIColor redColor];
    UIButton *closeBtn = [[UIButton alloc]init];
    self.closeView = closeView;
    self.zoomBtn = [[UIButton alloc]init];
    CGFloat zoomBtnWidth = 25;
    
//    self.webview = [[AWWebview alloc]initWithFrame:self.bounds];
    CGRect webframe = self.bounds;
    NSArray *arr = @[@"left",@"top",@"bottom"];
    NSString *urlStr = [AWGlobalDataManage shareinstance].flotingUrl;
    NSString *gravity = [AWConfig Currentgravity];
    if (![arr containsObject:gravity]) {
        gravity = [self getDefaultGravity];
    }
    if ([AWTools DeviceOrientation]!=3) {
        gravity = @"left";
        webframe.size.width = 465;
        NSLog(@"x=%f,width=%f",webframe.origin.x,webframe.size.width);
        closeView.frame = CGRectMake(465+marginb, (SCREENHEIGHT-closeHeight)/2.0, closeWidth, closeHeight);
        closeBtn.frame = closeView.bounds;
    }else{
        if ([gravity isEqualToString:@"top"]) {
            webframe.size.height = 465;
            closeView.frame = CGRectMake((SCREENWIDTH - closeHeight)/2.0, 465+marginb, closeHeight, closeWidth);
            closeBtn.frame = closeView.bounds;
        }else{
            webframe.size.height = 465;
            webframe.origin.y += closeWidth+marginb;
            closeView.frame = CGRectMake((SCREENWIDTH - closeHeight)/2.0, 0, closeHeight, closeWidth);
            closeBtn.frame = closeView.bounds;
            self.zoomBtn.frame = CGRectMake(SCREENWIDTH-20-zoomBtnWidth, 0, zoomBtnWidth, zoomBtnWidth);
        }
    }
    NSString *imageName = [NSString stringWithFormat:@"AWSDK.bundle/aw_icon_float_fewer_%@.png",gravity];
    [closeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.closeView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(clickCloseWeb) forControlEvents:UIControlEventTouchUpInside];
    
    [self.zoomBtn addTarget:self action:@selector(clickZoom:) forControlEvents:UIControlEventTouchUpInside];
    [self.zoomBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/zoom_out"] forState:UIControlStateNormal];
    [self.zoomBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/zoom_in"] forState:UIControlStateSelected];
    
    
    self.webview = [[AWWebview alloc]initWithFrame:webframe];
    
    
//https://gamecn-sdk.jxywl.cn/v18/community?postsid=617a1d7541c8ffcb74b217ef&
    
    NSString *token = [AWConfig CurrentToken];
    NSString *version_name = [AWConfig SDKversion];
    if (![urlStr containsString:@"?"]) {
        urlStr = [urlStr stringByAppendingFormat:@"?"];
    }
    if ([urlStr containsString:@"="]) {
        urlStr = [NSString stringWithFormat:@"%@&",urlStr];
    }
    NSString *resultUrl = [NSString stringWithFormat:@"%@token=%@&gravity=%@&version_name=%@&lang=%@",urlStr,token,gravity,version_name,GUOJIHUA(@"langeCode")];
    BOOL isEndWithRed = [urlStr hasSuffix:@"Redpacket?"];
    if ([AWGlobalDataManage shareinstance].redpackageUrl && [AWGlobalDataManage shareinstance].redpackageUrl.length >0 && isEndWithRed) {
        resultUrl = [AWGlobalDataManage shareinstance].redpackageUrl;
    }
    AWLog(@"weburl===%@",resultUrl);
    self.webview.urlStr = resultUrl;
    [self addSubview:self.webview];
    [self addSubview:closeView];
//    [self addSubview:self.zoomBtn];
    
    
}

-(void)clickZoom:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self changeFullScreen];
    }else{
        [self changeSmallScreen];
    }
    
}


//竖屏按钮触发全屏
-(void)changeFullScreen
{
    self.smallCloseFrame = self.closeView.frame;
    self.smallWebviewFrame = self.webview.frame;
    self.smallZoomBtnFrame = self.zoomBtn.frame;
    self.smallSelfFrame = self.frame;
    
    CGFloat liuhaiHeight = 44;
    self.frame = [UIScreen mainScreen].bounds;
    CGRect closeViewFrame = self.closeView.frame;
    closeViewFrame.origin.y = 0 + liuhaiHeight;
    self.closeView.frame = closeViewFrame;
    
    CGRect webViewFrame = self.webview.frame;
    CGFloat addcloseWidth = 25;
    webViewFrame.origin.y = addcloseWidth+liuhaiHeight;
    webViewFrame.size.height = SCREENHEIGHT - addcloseWidth - liuhaiHeight;
    self.webview.frame = webViewFrame;
    
    CGRect zoomBtnFrame = self.zoomBtn.frame;
    zoomBtnFrame.origin.y = 0 + liuhaiHeight;
    self.zoomBtn.frame = zoomBtnFrame;
    
    
    [self.webview reSizeWebView];
}

-(void)changeSmallScreen
{
    self.closeView.frame = self.smallCloseFrame;
    self.webview.frame = self.smallWebviewFrame;
    self.zoomBtn.frame = self.smallZoomBtnFrame;
    self.frame = self.smallSelfFrame;
    [self.webview reSizeWebView];
}


-(NSString *)getDefaultGravity
{
    if ([AWTools DeviceOrientation] == 3) {
        return @"bottom";
    }
    return @"left";
}

-(void)show
{
    [WEBBACKVIEW addSubview:self];
    [HGHShowBall hiddenWindow];
    [AWViewManager shareInstance].iswebviewShow = YES;

}

-(void)reloadwebview
{
    //这样要保存实例对象  在想想是单例还是那边保存对象 在刷新
    [self.webview reloadwebview];
}

-(void)clickCloseWeb
{
    [[AWViewManager shareInstance].webbackView closeWeb];
}

@end
