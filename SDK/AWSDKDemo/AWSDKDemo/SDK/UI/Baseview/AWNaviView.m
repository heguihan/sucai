//
//  AWNaviView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWNaviView.h"

@interface AWNaviView()

@end

@implementation AWNaviView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configFatherUI];
    }
    return self;
}

-(void)configFatherUI
{
    UIView *naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    
    naviView.backgroundColor = RGBA(238, 242, 246, 1);
    [naviView addSubview:self.backBtn];
    [naviView addSubview:self.titleLab];
    [naviView addSubview:self.closeBtn];
    [self addSubview:naviView];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text =title;
}

-(void)CloseView
{
    [self closeAllView];
}

-(void)goback
{
    [self gobackFromSelfView];
}

-(AWHGHALLButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(17, 15, 11, 19)];
        [_backBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/back.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(AWHGHALLButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(ViewWidth-34, 15, 17, 17)];
        [_closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/close.png"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(CloseView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake((ViewWidth-200)/2.0, 15, 200, 20)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONTSIZE(17);
        _titleLab.textColor = BLACKCOLOR;
//        _titleLab.backgroundColor = [UIColor redColor];
//        _titleLab.text = @"凄凄切切";
    }
    return _titleLab;
}

@end
