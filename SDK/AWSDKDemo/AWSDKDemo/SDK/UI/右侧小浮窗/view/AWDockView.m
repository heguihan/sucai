//
//  AWDockView.m
//  AWSDKDemo
//
//  Created by admin on 2021/10/27.
//

#import "AWDockView.h"

@implementation AWDockView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    
    self.backgroundColor = RGBA(255, 0, 0, 0.85);
    self.layer.cornerRadius = 5.0;
    CGFloat labWidth = 230;
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, labWidth, 30)];
    [self addSubview:textLab];
    textLab.textColor = [UIColor whiteColor];
    textLab.text = GUOJIHUA(@"当时版本是测试版本");
    
    CGFloat closeX = 8 + labWidth;
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(closeX, 8, 16, 16)];
    [closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/close.png"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor blueColor];
    
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)clickClose
{
    NSLog(@"docking close");
    [self removeFromSuperview];
    [AWGlobalDataManage shareinstance].isShowingDocking = NO;
}

@end
