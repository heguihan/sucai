//
//  AWRedNevelopeView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/28.
//


#define redwidth   400
#define redheight  300

#import "AWRedNevelopeView.h"
@interface AWRedNevelopeView()

@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIImageView *imageV;
@property(nonatomic, strong)AWHGHALLButton *closeBtn;
@end

@implementation AWRedNevelopeView

+(instancetype)factory_rednevelopeView
{
    AWRedNevelopeView *rednevelopeview = [[AWRedNevelopeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [rednevelopeview configUI];
    return rednevelopeview;
}

-(void)configUI
{
    self.backgroundColor = RGBA(1, 1, 1, 0.5);
//    self.backgroundColor = [UIColor blackColor];
//    self.contentView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-redwidth)/2.0, (SCREENHEIGHT-redheight)/2.0, redwidth, redheight)];
//    [self.contentView setAutoresizesSubviews:YES];
//    [self addSubview:self.contentView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-redwidth)/2.0, (SCREENHEIGHT-redheight)/2.0, redwidth, redheight)];
    self.imageV = imageV;
    [imageV setAutoresizesSubviews:YES];
    imageV.userInteractionEnabled = YES;
    imageV.autoresizingMask = 0;
    AWHGHALLButton *closeBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(360, 15, 20, 20)];
    self.closeBtn = closeBtn;
//    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/rednevelopeClose.png"] forState:UIControlStateNormal];
    [self addSubview:imageV];
    [imageV addSubview:closeBtn];
    imageV.image = [UIImage imageNamed:@"AWSDK.bundle/rednevelope.png"];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRedNevelope)];
    [imageV addGestureRecognizer:tap];
    
    
}

-(void)clickClose
{
    
    [AWDataReport saveEventWittEvent:@"app_click_banner_close" properties:@{}];
    CGFloat sclar = redwidth/50.0;
    [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect floatingFrame = [AWGlobalDataManage shareinstance].floadtingFrame;
        
        self.imageV.frame = floatingFrame;
        CGRect btnFrame = self.closeBtn.frame;
        btnFrame.origin.x = btnFrame.origin.x / sclar;
        btnFrame.origin.y = btnFrame.origin.y / sclar;
        btnFrame.size.width = btnFrame.size.width / sclar;
        btnFrame.size.height = btnFrame.size.height / sclar;
        self.closeBtn.frame = btnFrame;
    } completion:^(BOOL finished) {
        [AWTools removeViews:self];
    }];
    
}

-(void)tapRedNevelope
{
    NSLog(@"tap");
    [AWTools removeViews:self];
    [AWDataReport saveEventWittEvent:@"app_click_banner_red" properties:@{}];
//    NSString *urlStr = [AWSDKConfigManager shareinstance].menu;
    NSString *urlStr = [AWSDKConfigManager shareinstance].name_auth_menu;
    [AWLoginViewManager showUsercenterWithUrl:urlStr];
//    [AWLoginViewManager showUsercenter];
}


-(void)showRednevelope
{
    [[AWTools currentWindow] addSubview:self];
}

@end
    
