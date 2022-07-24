//
//  AWFastLoginView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWHistoryLoginView.h"
#import "SelectView.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@interface AWHistoryLoginView()<SelectViewDelegate>
@property(nonatomic, strong)AWTextField *fastTF;
@property(nonatomic, strong)SelectView *selectView;
@property(nonatomic, strong)AWHGHALLButton *downBtn;
@property(nonatomic, strong)UIImageView *iconV;
@property(nonatomic, strong)UIView *tfBackgroundView;
@property(nonatomic, assign)CGFloat lessHeight;
//当前选择的userinfo
@property(nonatomic, strong)NSDictionary *CurrentUserinfo;
@property(nonatomic, assign)BOOL isChecked;
@property(nonatomic, strong)UIView *mainView;

@end

@implementation AWHistoryLoginView
+(instancetype)factory_historyLoginview
{
    AWHistoryLoginView *fastv = [[AWHistoryLoginView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-LogoViewHeight)];
    fastv.isChecked = YES;
    return fastv;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
//    [self addlogo];
    
    CGFloat mainY = AdaptWidth(30);
    self.lessHeight = 0;
    NSString *logoEndName = [AWSDKConfigManager shareinstance].brand;
    if ([logoEndName isEqualToString:@"qiba"]) {
        self.lessHeight = AdaptWidth(40);
        mainY = AdaptWidth(60);
    }
    [self changeFrame];
    [self addMainViewWithYY:mainY];
    [self addTF];
    [self addbtn];
    [self addselectView];
}

-(void)addlogo
{
//    CGFloat logoWidth = AdaptWidth(146);
//    CGFloat logoHeight = AdaptWidth(62);
//    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((ViewWidth-logoWidth)/2.0, 16, logoWidth, logoHeight)];
    UIImageView *logoView = [AWSmallControl getLogoView];
//    logoView.image = [UIImage imageNamed:@"AWSDK.bundle/logo.png"];
    [self addSubview:logoView];
}

-(void)addMainViewWithYY:(CGFloat)mainY
{
//    CGFloat mainY = AdaptWidth(100);
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, mainY, ViewWidth, ViewHeight-mainY)];
    [self addSubview:self.mainView];
//    self.mainView.backgroundColor = [UIColor greenColor];
}

-(void)addTF
{
    
    UIView *tfbackview = [[UIView alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(5), TFWidth, TFHeight)];
    self.tfBackgroundView = tfbackview;
    tfbackview.backgroundColor = TFCOLOR;
    tfbackview.layer.cornerRadius = TFHeight/2.0;
    tfbackview.layer.masksToBounds = YES;
    self.fastTF = [[AWTextField alloc]initWithFrame:CGRectMake(0, 0, TFWidth-80, TFHeight)];
//    self.fastTF.backgroundColor = TFCOLOR;
    self.fastTF.layer.cornerRadius = TFHeight/2.0;
    [self.fastTF.layer masksToBounds];
    [self.fastTF setEnabled:NO];

    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(TFWidth-80, 0, 80, TFHeight)];
//    self.fastTF.rightView = rightView;
//    self.fastTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 1)];
    self.fastTF.leftView = leftView;
    self.fastTF.leftViewMode = UITextFieldViewModeAlways;
    
    CGFloat iconHeight = 19;
    CGFloat iconWidth = 19;
    UIImageView *accountIconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(13, (TFHeight-iconHeight)/2.0, iconWidth, iconHeight)];
    accountIconImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.iconV = accountIconImageV;
    [self.fastTF addSubview:accountIconImageV];
//    accountIconImageV.image = [UIImage imageNamed:@"login_wechat.png"];
    
    CGFloat downBtnWidth = 12;
    self.downBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(50, 16, downBtnWidth, 7)];
    [self.downBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/down.png"] forState:UIControlStateNormal];
    [self.downBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/up.png"] forState:UIControlStateSelected];
    [self.downBtn addTarget:self action:@selector(clickEmnu:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.downBtn];
    
//    [self addSubview:self.fastTF];
    [self.mainView addSubview:tfbackview];
    [tfbackview addSubview:self.fastTF];
    [tfbackview addSubview:rightView];
    
    
    
}

-(void)addbtn
{
    AWHGHALLButton *loginBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(60), ViewWidth-MarginX*2, TFHeight)];

    CAGradientLayer *layer = [AWTools setGradualChangingColor:loginBtn fromColor:RGBA(239, 165, 105, 1) toColor:RGBA(236, 128, 51, 1)];
    layer.cornerRadius = TFHeight/2.0;
    [layer masksToBounds];
    [loginBtn.layer addSublayer:layer];
//    loginBtn.layer.cornerRadius = TFHeight/2.0;
//    [loginBtn.layer masksToBounds];
    [loginBtn setTitle:GUOJIHUA(@"登录") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = FONTSIZE(15);
    [loginBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self addProtolLab];
    
    
    UIButton *otherLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake((ViewWidth-100)/2.0, AdaptWidth(140), 100, 25)];
    [otherLoginBtn setTitle:GUOJIHUA(@"更多登录方式") forState:UIControlStateNormal];
    [otherLoginBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    otherLoginBtn.titleLabel.font = FONTSIZE(13);
    [otherLoginBtn addTarget:self action:@selector(clickOtherLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:loginBtn];
    [self.mainView addSubview:otherLoginBtn];
}

// Agree User agreement & Privacy policy

-(UIView *)getAgreementView
{
    CGFloat height = 20;
    CGFloat firWidth = 30;
    CGFloat secWidth = 50;
    CGFloat thirdWidth = 5;
    
    UIView *fatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFWidth, 20)];
    UILabel *firLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    
    
    return fatherView;
}

-(void)addProtolLab
{
    AWHGHALLButton *checkBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(120), 15, 15)];
    [self addSubview:checkBtn];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_is_select.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_not_select.png"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:checkBtn];
    
    
    // Agree User agreement & Privacy policy
    
    
    
    
    
    
    
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX+18, AdaptWidth(120), TFWidth, 15)];
    lab.numberOfLines = 0;
    
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
//    lab.backgroundColor = [UIColor blueColor];
}

-(void)addselectView
{
    
    /*
     @{LOGIN_FACEBOOK:@"AWSDK.bundle/zhanghao.png",LOGIN_PHONE:@"AWSDK.bundle/shouji.png",LOGIN_VISITOR:@"AWSDK.bundle/huojian.png",LOGIN_GOOGLE:@"AWSDK.bundle/history_weixin_light.png"};
     */
    NSDictionary *highlightIconDict =@{LOGIN_USER:@"AWSDK.bundle/zhanghao.png",LOGIN_PHONE:@"AWSDK.bundle/shouji.png",LOGIN_VISITOR:@"AWSDK.bundle/huojian.png",LOGIN_GOOGLE:@"AWSDK.bundle/google.png",LOGIN_FACEBOOK:@"AWSDK.bundle/facebook.png"};
    
    NSArray *arr = [AWConfig loadLoginAccount];
    NSDictionary *userinfo = arr[0];
    self.CurrentUserinfo = userinfo;
    NSString *imageName = [highlightIconDict objectForKey:userinfo[@"type"]];
    self.iconV.image = [UIImage imageNamed:imageName];
    self.fastTF.text = userinfo[@"show_account"];
    
    
    CGFloat yy = self.tfBackgroundView.frame.origin.y + self.fastTF.frame.size.height-TFHeight/2.0;
    
    self.selectView = [[SelectView alloc]initWithFrame:CGRectMake(MarginX, yy, TFWidth, ViewHeight-yy-AdaptWidth(100))];
//    self.selectView.backgroundColor = [UIColor redColor];
    self.selectView.dataArr = arr;
    self.selectView.delegate = self;
    self.selectView.frame = CGRectMake(MarginX, yy, TFWidth, 0);
    [self.mainView addSubview:self.selectView];
    [self.mainView bringSubviewToFront:self.tfBackgroundView];
}

-(void)clickOtherLogin
{
    [AWLoginViewManager showLoginListViewAsFirstview:NO];
}

-(void)clickLogin
{
    AWLog(@"login");
    if (!self.isChecked) {
        [AWTools makeToastWithText:@"请阅读并同意《服务协议》和《隐私策略》"];
        return;
    }
    NSString *account = self.CurrentUserinfo[@"account"];
    NSString *pwd = self.CurrentUserinfo[@"pwd"];
    NSString *loginType = self.CurrentUserinfo[@"type"];
    loginType = LOGIN_USER;
    [AWHTTPRequest AWLoginRequestWithAccount:account pwd:pwd phoneNO:@"" captcha:@"" loginType:loginType ifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
    
    
}

-(void)clickEmnu:(AWHGHALLButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self showSelectView];
    }else{
        [self hiddenSelecview];
    }

}

-(void)showSelectView
{
    self.selectView.hidden = NO;
    CGRect frame = self.selectView.frame;
    frame.size.height = 0;
    self.selectView.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.selectView.frame;
            frame.size.height = ViewHeight - frame.origin.y;
            self.selectView.frame = frame;
//        self.selectView.clipsToBounds = YES;
            
    }];
}

-(void)hiddenSelecview
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.selectView.frame;
        frame.size.height = 0;
        self.selectView.frame = frame;
    } completion:^(BOOL finished) {
        self.selectView.hidden = YES;
    }];
}


#pragma selectviewdelegate

-(void)didSelectWithIndex:(NSInteger)index selectedDic:(NSDictionary *)userinfo
{
    if (index==100) {
        self.downBtn.selected = NO;
        self.selectView.hidden = YES;
    }else{
        self.CurrentUserinfo = userinfo;
        [self updateCurrentUser];
        self.downBtn.selected = NO;
        self.selectView.hidden = YES;
    }
}

-(void)updateCurrentUser
{
    NSDictionary *highlightIconDict = @{LOGIN_USER:@"AWSDK.bundle/zhanghao.png",LOGIN_PHONE:@"AWSDK.bundle/shouji.png",LOGIN_VISITOR:@"AWSDK.bundle/huojian.png",LOGIN_GOOGLE:@"AWSDK.bundle/google.png",LOGIN_FACEBOOK:@"AWSDK.bundle/facebook.png"};
    NSString *imageName = [highlightIconDict objectForKey:self.CurrentUserinfo[@"type"]];
    self.iconV.image = [UIImage imageNamed:imageName];
    self.fastTF.text = self.CurrentUserinfo[@"show_account"];
}


-(NSDictionary *)CurrentUserinfo
{
    if (!_CurrentUserinfo) {
        _CurrentUserinfo = [[NSDictionary alloc]init];
    }
    return _CurrentUserinfo;
}

-(void)clickCheck:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isChecked = !sender.selected;
}


-(void)changeFrame
{
    CGRect frame = self.frame;
    frame.size.height = ViewHeight - LogoViewHeight-self.lessHeight;
//    frame.size.width = ViewWidth + self.addWidth;
    self.frame = frame;
}

@end
