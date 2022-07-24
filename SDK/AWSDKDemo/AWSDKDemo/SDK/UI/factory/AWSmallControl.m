//
//  AWSmallControl.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWSmallControl.h"

@implementation AWSmallControl
+(AWHGHALLButton *)getBackBtn
{
    AWHGHALLButton *backBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(17, 15, 11, 19)];
    [backBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/back.png"] forState:UIControlStateNormal];
    return backBtn;
}
+(AWHGHALLButton *)getCloseBtn
{
    AWHGHALLButton *closeBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(ViewWidth-33, 16, 17, 17)];
    [closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/close.png"] forState:UIControlStateNormal];
    return closeBtn;
}

+(AWHGHALLButton *)getEyesBtn
{
    AWHGHALLButton *eyesBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(10, (TFHeight-11)/2.0, 17, 11)];
    [eyesBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/closeeye.png"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/openeye.png"] forState:UIControlStateSelected];
    return eyesBtn;
}

+(UIImageView *)getLogoView
{
    CGFloat logoWidth = AdaptWidth(160); 
    CGFloat logoHeight = AdaptWidth(62);
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake((ViewWidth-logoWidth)/2.0, LOGOYY, logoWidth, logoHeight)];
    
    NSString *logoImageStr = @"aw_logo";
    NSArray *logoArr = @[@"aw",@"afy",@"qiba"];
    NSString *logoEndName = [AWSDKConfigManager shareinstance].brand;
    

    
    if (![logoArr containsObject:logoEndName]) {
        logoEndName = @"afy";
    }
    NSString *logoImageName = [NSString stringWithFormat:@"%@_%@.png",logoImageStr,logoEndName];
    
    
//    if ([AWSDKConfigManager shareinstance].brand && [[AWSDKConfigManager shareinstance].brand isEqualToString:@"aw"]) {
//        logoImageStr = @"aw_logo.png";
//    }
    NSString *wholeImageName = [NSString stringWithFormat:@"AWSDK.bundle/%@",logoImageName];
    [AWGlobalDataManage shareinstance].wholeLogoName = wholeImageName;
    logoView.image = [UIImage imageNamed:wholeImageName];
    
    
    return logoView;
}

@end
