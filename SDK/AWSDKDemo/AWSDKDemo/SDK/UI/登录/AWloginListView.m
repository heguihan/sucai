//
//  AWloginV.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWloginListView.h"
#import "AWLoginTypeBtn.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"
#import "AWBindWechat.h"

#import "AWFacebookLogin.h"
#import "AWGoogleLoginManager.h"

@interface AWloginListView()
@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)AWHGHALLButton *backBtn;
@property(nonatomic, assign)CGFloat addHeight;
@property(nonatomic, assign)CGFloat lessHeight;
@property(nonatomic, assign)CGFloat addWidth;
@property(nonatomic, assign)BOOL isChecked;
@property(nonatomic, strong)UIImageView *logoview;
@property(nonatomic, strong)UIView *mainView;
@end

@implementation AWloginListView

+(instancetype)factory_loginlistWithArr:(NSArray *)arr
{
    
    AWloginListView *looginListV = [[AWloginListView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-LogoViewHeight)];
    looginListV.isChecked = YES;
    [looginListV configUIWithArr:arr];
    return looginListV;
}


-(void)configUIWithArr:(NSArray *)arr
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyShowView) name:NOTIFICATIONLOGINLIST object:nil];
    [self landScapeUIWithArr:arr];
}

//横屏
-(void)landScapeUIWithArr:(NSArray *)arr
{
    self.addWidth = 0;
    self.backBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(18, 16, AdaptWidth(11), AdaptWidth(20))];
    [self.backBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/back.png"] forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
//    CGFloat logoWidth = AdaptWidth(146);
//    CGFloat logoHeight = AdaptWidth(62);
//    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((ViewWidth-logoWidth)/2.0, 16, logoWidth, logoHeight)];
    self.logoview = [AWSmallControl getLogoView];
    CGRect frame = self.logoview.frame;
    frame.origin.y = frame.origin.y + 10;
    self.logoview.frame = frame;

    CGFloat mainY = AdaptWidth(30);
    self.lessHeight = 0;
    NSString *logoEndName = [AWSDKConfigManager shareinstance].brand;
    if ([logoEndName isEqualToString:@"qiba"]) {
        self.lessHeight = AdaptWidth(40);
        mainY = AdaptWidth(60);
    }
    [self changeBigFrame];
    [self addMainViewWithYY:mainY];
}

-(void)setIsFirstView:(BOOL)isFirstView
{
    if (isFirstView) {
        self.backBtn.hidden = YES;
    }
}

-(void)addMainViewWithYY:(CGFloat)mainY
{
//    CGFloat mainY = AdaptWidth(100);
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, mainY, ViewWidth, ViewHeight-mainY)];
//    self.mainView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.mainView];
}


-(void)configPortrailUIWithArr:(NSArray *)arr
{

    
    if (arr.count >= 3) {
        self.addHeight = 50 * (arr.count -1);
        self.addWidth = 0;
        if (ViewHeight >280) {
            self.addHeight = self.addHeight + 280 - ViewHeight;
        }
        [self changeBigFrame];
    }else if (arr.count==2){
        self.addHeight += 20;
        if (ViewHeight >280) {
            self.addHeight = self.addHeight + 280 - ViewHeight;
        }
        [self changeBigFrame];
    }
    NSDictionary *imageDict = @{LOGIN_FACEBOOK:@"AWSDK.bundle/login_facebook.png",LOGIN_PHONE:@"AWSDK.bundle/login_phone.png",LOGIN_VISITOR:@"AWSDK.bundle/login_fast.png",LOGIN_GOOGLE:@"AWSDK.bundle/login_google.png"};
    NSDictionary *titleDict = @{LOGIN_FACEBOOK:GUOJIHUA(@"facebook"),LOGIN_PHONE:GUOJIHUA(@"手机"),LOGIN_VISITOR:GUOJIHUA(@"快速游戏"),LOGIN_GOOGLE:GUOJIHUA(@"google")};
    for (int i=0; i<arr.count; i++) {
        
        NSString *key = arr[i];
        NSString *imageName = @"";
        NSString *titleStr = @"";
        if ([imageDict.allKeys containsObject:key]) {
            imageName = [imageDict objectForKey:key];
        }
        if ([titleDict.allKeys containsObject:key]) {
            titleStr = [titleDict objectForKey:key];
        }
        AWLoginTypeBtn *loginBtn = [AWLoginTypeBtn factory_BtnWithTitle:titleStr imageName:imageName marginY:(TFHeight +10)*i+AdaptWidth(10)];
        loginBtn.tag = 222+i;
        [loginBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:loginBtn];
    }
    [self addProtolLabWithYY:ViewHeight-30+self.addHeight-AdaptWidth(80)];
    AWHGHALLButton *CustomerBtn=  [[AWHGHALLButton alloc]initWithFrame:CGRectMake((ViewWidth-180)/2.0, ViewHeight-40+self.addHeight-AdaptWidth(40), 180, 15)];
    [CustomerBtn setTitle:@"Contact customer" forState:UIControlStateNormal];
    [CustomerBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    CustomerBtn.titleLabel.font = FONTSIZE(12);
    [CustomerBtn addTarget:self action:@selector(clickCustomer) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *fb = [AWSDKConfigManager shareinstance].kefu_fb;
    NSString *email = [AWSDKConfigManager shareinstance].kefu_email;
    NSString *telPhone = [AWSDKConfigManager shareinstance].kefu_phone;
    
    if (!fb && !email && !telPhone) {
//        CGRect frame = self.frame;
//        frame.size.height = frame.size.height - 20;
//        self.frame = frame;
    }else{
        [self.mainView addSubview:CustomerBtn];
    }

    NSArray *loginList2 = [AWSDKConfigManager shareinstance].login_type2;
    
    if (loginList2 && loginList2.count>=1) {
        [self addMoreLoginBtn];
    }
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(MarginX, ViewHeight - 105 + 15  +self.addHeight-AdaptWidth(100), ViewWidth-2*MarginX, 1)];
    lineview.backgroundColor = RGBA(200, 200, 200, 1);
//    [self.mainView addSubview:lineview];
}

-(void)addMoreLoginBtn
{
    AWHGHALLButton *moreLoginBtn=  [[AWHGHALLButton alloc]initWithFrame:CGRectMake((ViewWidth-180)/2.0, ViewHeight-75+self.addHeight-AdaptWidth(80)-AdaptWidth(20), 180, 16)];
    [moreLoginBtn setTitle:GUOJIHUA(@"更多登录方式") forState:UIControlStateNormal];
    [moreLoginBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    moreLoginBtn.titleLabel.font = FONTSIZE(14);
    [moreLoginBtn addTarget:self action:@selector(moreLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:moreLoginBtn];
    
    GGGLabel *noticeLab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, ViewHeight-55+self.addHeight-AdaptWidth(80)-AdaptWidth(20), TFWidth, 35)];
    noticeLab.numberOfLines = 0;
    [self.mainView addSubview:noticeLab];
    NSString *appendStr = [NSString stringWithFormat:@"%@%@",GUOJIHUA(@"注意："),GUOJIHUA(@"不同登录方式的账号是独立的")];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:appendStr];
    [attr yy_setColor:RGBA(255, 1, 1 , 1) range:NSMakeRange(0, 6)];
    
    
    noticeLab.attributedText = attr;
    noticeLab.textAlignment = NSTextAlignmentCenter;
    
}


-(void)moreLogin
{
    [AWLoginViewManager showLoginSubView];
}


-(void)addProtolLabWithYY:(CGFloat)labYY
{
    AWHGHALLButton *checkBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, labYY, 15, 15)];
    [self.mainView addSubview:checkBtn];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_is_select.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_not_select.png"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:checkBtn];
    
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX+18, labYY, TFWidth, 15)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLog)];
    tap.numberOfTapsRequired = 5;
    [lab addGestureRecognizer:tap];
    
    [self.mainView addSubview:lab];
    
    
    BOOL isprivacy = NO;
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:GUOJIHUA(@"同意用户协议")];
    NSArray *linkList = [AWSDKConfigManager shareinstance].link;
    if (linkList.count>0) {
        for (NSDictionary *dic in linkList) {
            if ([dic.allKeys containsObject:@"key"]) {
                if ([dic[@"key"] isEqualToString:@"Privacy"]) {
                    [mutableStr appendString:GUOJIHUA(@"&隐私协议")];
                    isprivacy = YES;
                }
            }
        }
    }
    
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: [mutableStr copy]];
     text.yy_lineSpacing = 5;
     text.yy_font = FONTSIZE(12);
     text.yy_color = BLACKCOLOR;
     [text yy_setTextHighlightRange:NSMakeRange(5, 15) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
         AWLog(@"xxx协议被点击了");
         [AWLoginViewManager showUserProtocol];

     }];
    if (isprivacy) {
        [text yy_setTextHighlightRange:NSMakeRange(23, 14) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            AWLog(@"xxx协议被点击了");
            [AWLoginViewManager showPrivacyProtocol];

        }];
    }

    
     lab.numberOfLines = 0;  //设置多行显示
     lab.preferredMaxLayoutWidth = TFWidth; //设置最大的宽度
     lab.attributedText = text;  //设置富文本
}


-(void)setArr:(NSArray *)arr
{
    
    //这里把后台获取到的登录方式 和本地已有的登录方式进行对比，如果本地没有的登录方式 直接删除
    NSArray *containArr = @[LOGIN_FACEBOOK,LOGIN_PHONE,LOGIN_VISITOR,LOGIN_GOOGLE];
    NSMutableArray *serverLoginArr = [[NSMutableArray alloc]initWithArray:arr];
    
    //过滤数组
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",containArr];
    NSArray *resulArr = [serverLoginArr filteredArrayUsingPredicate:filterPredicate];

    arr = resulArr;
    
    
    _arr = arr;
    
    if ([AWTools DeviceOrientation] == 3) {
        [self configPortrailUIWithArr:arr];
        return;
    }
    
    
    NSDictionary *imageDict = @{LOGIN_FACEBOOK:@"AWSDK.bundle/login_facebook.png",LOGIN_PHONE:@"AWSDK.bundle/login_phone.png",LOGIN_VISITOR:@"AWSDK.bundle/login_fast.png",LOGIN_GOOGLE:@"AWSDK.bundle/login_google.png"};
    NSDictionary *titleDict = @{LOGIN_FACEBOOK:GUOJIHUA(@"facebook"),LOGIN_PHONE:GUOJIHUA(@"手机"),LOGIN_VISITOR:GUOJIHUA(@"快速游戏"),LOGIN_GOOGLE:GUOJIHUA(@"google")};
    
    CGFloat currentViewWidth = ViewWidth;
    if (arr.count==4) {
        currentViewWidth = AdaptWidth(380);
        self.addWidth = AdaptWidth(60);
        CGRect frame = self.frame;
        frame.size.width = AdaptWidth(380);
        self.frame = frame;
        
        
        CGRect logoFrame = self.logoview.frame;
        logoFrame.origin.x = logoFrame.origin.x +AdaptWidth(30);
        self.logoview.frame = logoFrame;
//
//        CGRect mainFrame = [AWViewManager shareInstance].mainView.frame;
//        mainFrame.size.width = AdaptWidth(380);
//        mainFrame.origin.x = mainFrame.origin.x-AdaptWidth(40);
//        [AWViewManager shareInstance].mainView.frame = mainFrame;
    }
    
    CGFloat btnWidth = 50;
    CGFloat labWidth = btnWidth +30;
    CGFloat marginW = (currentViewWidth -(arr.count*btnWidth)) / (arr.count+1);
    
    for (int i=0; i<arr.count; i++) {
        
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((marginW + btnWidth)*i+marginW, AdaptWidth(10), btnWidth, btnWidth)];
        [self.mainView addSubview:loginBtn];
//        loginBtn.backgroundColor = [UIColor redColor];
        loginBtn.tag = 222+i;
        NSString *key = arr[i];
        if ([imageDict.allKeys containsObject:key]) {
            [loginBtn setImage:[UIImage imageNamed:[imageDict objectForKey:key]] forState:UIControlStateNormal];
        }
        [loginBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [loginBtn addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *loginLab = [[UILabel alloc]initWithFrame:CGRectMake((marginW + btnWidth)*i+marginW -15, AdaptWidth(73), labWidth, 15)];
        if ([titleDict.allKeys containsObject:key]) {
            loginLab.text = [titleDict objectForKey:key];
        }

        [self.mainView addSubview:loginLab];
        loginLab.textAlignment = NSTextAlignmentCenter;
        loginLab.font = FONTSIZE(14);
        loginLab.textColor = [UIColor blackColor];
    }
    [self addProtolLabWithYY:AdaptWidth(175)-AdaptWidth(15)];
    AWHGHALLButton *CustomerBtn=  [[AWHGHALLButton alloc]initWithFrame:CGRectMake((currentViewWidth-140)/2.0, AdaptWidth(185), 140, 15)];
    [CustomerBtn setTitle:@"Contact customer" forState:UIControlStateNormal];
    [CustomerBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    CustomerBtn.titleLabel.font = FONTSIZE(12);
    [CustomerBtn addTarget:self action:@selector(clickCustomer) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *fb = [AWSDKConfigManager shareinstance].kefu_fb;
    NSString *email = [AWSDKConfigManager shareinstance].kefu_email;
    NSString *telPhone = [AWSDKConfigManager shareinstance].kefu_phone;
    if (!fb && !email && !telPhone) {
        CGRect frame = self.frame;
//        frame.size.height = frame.size.height - 20;
        self.frame = frame;
    }else{
        [self.mainView addSubview:CustomerBtn];
    }
    NSArray *loginList2 = [AWSDKConfigManager shareinstance].login_type2;
    
    if (loginList2 && loginList2.count>=1) {
        [self addMoreLoginBtn];
    }
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(MarginX, ViewHeight - 95 + 15  +self.addHeight-AdaptWidth(100), ViewWidth-2*MarginX, 1)];
    lineview.backgroundColor = RGBA(200, 200, 200, 1);
//    [self.mainView addSubview:lineview];
}


-(void)clickLogin:(AWHGHALLButton *)sender
{
    if (!self.isChecked) {
        [AWTools makeToastWithText:GUOJIHUA(@"请勾选用户隐私协议等等")];
        return;
    }
    NSString *methodStr = self.arr[sender.tag-222];
    methodStr = [NSString stringWithFormat:@"show_%@",methodStr];
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(clickBack)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    SEL selectorx = NSSelectorFromString(methodStr);
    invocation.selector = selectorx;
    [invocation invoke];
}

-(void)show_LOGIN_VISITOR
{
    AWLog(@"show vistor");
    [AWDataReport saveEventWittEvent:@"app_login_fast" properties:@{}];
    [AWHTTPRequest AWRegistRequestWithAccount:@"" pwd:@"" phoneNO:@"" captcha:@"" loginType:LOGIN_VISITOR ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}
-(void)show_LOGIN_USER
{
    AWLog(@"show user");
    [self changeSmallFrame];
    [AWLoginViewManager showAccountLogin];
}
-(void)show_LOGIN_PHONE
{
    AWLog(@"show phone");
    [self changeSmallFrame];
    [AWLoginViewManager showPhone];
}

-(void)show_LOGIN_WEIXIN
{
    NSLog(@"login weixin");
//    [self changeSmallFrame];
    [AWGlobalDataManage shareinstance].isWeixinLogin = YES;
    [AWBindWechat bindWeiChat];
}

-(void)show_LOGIN_FACEBOOK
{
    NSLog(@"facebook login click");
    [[AWFacebookLogin shareinstance] facebookLogin];
}

-(void)show_LOGIN_GOOGLE
{
    NSLog(@"google login click");
    [AWGoogleLoginManager googleLogin];
}

-(void)clickBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATIONLOGINLIST object:nil];
    [self gobackFromSelfView];
}

-(void)clickCustomer
{
    [self changeSmallFrame];
    [AWDataReport saveEventWittEvent:@"app_contact_service" properties:@{}];
    NSString *fb = [AWSDKConfigManager shareinstance].kefu_fb;
    NSString *email = [AWSDKConfigManager shareinstance].kefu_email;
    NSString *telPhone = [AWSDKConfigManager shareinstance].kefu_phone;
    
    if (!fb && !email && !telPhone) {
        [AWTools makeToastWithText:@"暂无客服信息"];
    }
    [AWLoginViewManager showCustomer];
}


#pragma notify show
-(void)notifyShowView
{
    AWLog(@"notify");
    [self changeBigFrame];
}

//这是适配竖屏 竖屏的时候显示会高出其他的视图  这边跳转到下一个缩小视图  等跳回来再还原视图
-(void)changeSmallFrame
{
    CGRect frame = self.frame;
    frame.size.height = ViewHeight-LogoViewHeight;
    frame.size.width = ViewWidth;
    self.frame = frame;
}

-(void)changeBigFrame
{
    CGRect frame = self.frame;
    frame.size.height = ViewHeight-LogoViewHeight+self.addHeight-self.lessHeight;
    frame.size.width = ViewWidth + self.addWidth;
    self.frame = frame;
}

-(void)clickCheck:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isChecked = !sender.selected;
}

-(void)tapLog
{
    NSLog(@"打开日志开关");
    [AWGlobalDataManage shareinstance].isOpneLog = YES;
}
@end
