//
//  AWGotoSettingView.m
//  AWSDKDemo
//
//  Created by admin on 2021/2/24.
//

#import "AWGotoSettingView.h"

@implementation AWGotoSettingView

+(instancetype)factory_gotosetting
{
    AWGotoSettingView *gotosetting = [[AWGotoSettingView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [gotosetting configUI];
    return gotosetting;
}


-(void)configUI
{
    [self addLogo];
    [self addContent];
}

-(void)addLogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{
//    您的手机没有授权，请前往"设置->隐私->跟踪"，打开"允许该应用请求跟踪"。
//    NSArray *titleArr = @[@"网络错误",@"请检查网络连接重试"];
//    for (int i=0; i<2; i++) {
//        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, 100+(22 * i), ViewWidth-MarginX*2, 20)];
//        [self addSubview:lab];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.font = FONTSIZE(18);
//        lab.text = titleArr[i];
//    }
    
    NSString *showTitle = @"您的手机没有授权，会影响游戏体验。请前往\"设置->隐私->跟踪\"，打开\"允许该应用请求跟踪\"。";
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, 100, ViewWidth-MarginX*2, 80)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.font = FONTSIZE(18);
    lab.text = showTitle;
    lab.textColor = [UIColor blackColor];
    [self addSubview:lab];
    
    
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    cancelBtn.titleLabel.font = FONTSIZE(14);
    cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = TFHeight/2.0;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(200), btnWidth, TFHeight)];
    confirmBtn.titleLabel.font = FONTSIZE(14);
    [confirmBtn setTitle:@"前往设置" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickgotoSetting) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:cancelBtn];
    [self addSubview:confirmBtn];
}

-(void)clickCancel
{
    [self closeNotCloseView];
}

-(void)clickgotoSetting
{
    [self closeNotCloseView];
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingUrl options:nil completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"yes");
            }
    }];
}

@end
