//
//  AWLoginSuccessAlertView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/5.
//

#import "AWLoginSuccessAlertView.h"

@implementation AWLoginSuccessAlertView

+(instancetype)factory_LoginsuccessView
{
    CGFloat width = 300;
    CGFloat height = 50;
    AWLoginSuccessAlertView *alertView = [[AWLoginSuccessAlertView alloc]initWithFrame:CGRectMake((SCREENWIDTH-width)/2.0, (SCREENHEIGHT-height)/2.0, width, height)];
    [alertView configUI];
    return alertView;
}

-(void)configUI
{
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    
    
    
}

@end
