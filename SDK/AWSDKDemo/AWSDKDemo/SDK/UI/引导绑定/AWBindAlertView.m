//
//  AWBindAlertView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWBindAlertView.h"

@interface AWBindAlertView()
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *ContentLab;
@property(nonatomic, strong)AWOrangeBtn *forcedUpdateBtn;
@property(nonatomic, strong)AWOrangeBtn *updateBtn;
@property(nonatomic, strong)AWHGHALLButton *cancelBtn;
@end

@implementation AWBindAlertView
+(instancetype)factory_bindalert
{
    AWBindAlertView *bindAlert = [[AWBindAlertView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [bindAlert configUI];
    return bindAlert;
}

-(void)configUI
{
//    [self addlogo];
    [self addContent];
}

-(void)addlogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(30), 200, 20)];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = FONTSIZE(18);
    self.titleLab.textColor = RGBA(70, 71, 71, 1);
    self.titleLab.text = @"发现新版本_v2.0";
    
    self.ContentLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(111), TFWidth, AdaptWidth(60))];
    
    self.ContentLab.textColor = RGBA(71, 71, 71, 1);
    self.ContentLab.font = FONTSIZE(14);
    self.ContentLab.textAlignment = NSTextAlignmentLeft;
    self.ContentLab.numberOfLines = 0;
    self.ContentLab.text = @"建议您尽快绑定手机号，以防数据丢失。";
    
    
    CGFloat btnWidth = AdaptWidth(129);
    self.cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(161), btnWidth, TFHeight)];
    self.cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    self.cancelBtn.layer.cornerRadius = TFHeight/2.0;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.updateBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth, AdaptWidth(161), btnWidth, TFHeight)];
    [self.updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.updateBtn addTarget:self action:@selector(clickUpdate) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.forcedUpdateBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(161), TFWidth, TFHeight)];
    [self.forcedUpdateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.forcedUpdateBtn addTarget:self action:@selector(clickUpdate) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.ContentLab];
    [self addSubview:self.titleLab];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.updateBtn];
    [self addSubview:self.forcedUpdateBtn];
}

-(void)clickCancel
{
    
}

-(void)clickUpdate
{
    
}

-(void)show
{
    self.titleLab.text = [NSString stringWithFormat:@"发现新版本_%@",self.gameVersion];
    self.ContentLab.text = self.updateContentStr;
    if (self.isForcedUpdate) {
        self.cancelBtn.hidden = YES;
        self.updateBtn.hidden = YES;
    }else{
        self.forcedUpdateBtn.hidden = NO;
    }
    [MAINVIEW addSubview:self];
}

@end
