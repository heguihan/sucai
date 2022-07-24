//
//  AWFastAccountView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWFastAccountView.h"

@implementation AWFastAccountView

+(instancetype)facory_fastAccountviewWithAcooun:(NSString *)account andPwd:(NSString *)pwd
{
    AWFastAccountView *fastaccount = [[AWFastAccountView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [fastaccount configUIWithAcooun:account andPwd:pwd];
    return fastaccount;
}

-(void)configUIWithAcooun:(NSString *)account andPwd:(NSString *)pwd
{
//    [self addlogo];
    [self addAcountInfoWithAcooun:account andPwd:pwd];
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

-(void)addAcountInfoWithAcooun:(NSString *)account andPwd:(NSString *)pwd
{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(105), TFWidth, 15)];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = FONTSIZE(12);
    titleLab.textColor = BLACKCOLOR;
    titleLab.text = @"亲爱的用户，以下是您的账号信息：";
    [self addSubview:titleLab];
    
    AWTextField *accountTF = [AWTextField factoryBtnWithLeftWidth:60 marginY:AdaptWidth(130)];
    accountTF.text = account;
    UILabel *accountLeftLab = [self leftLabWithTitle:@"账号"];
    [accountTF addSubview:accountLeftLab];
    
    
    
    AWTextField *pwdTF = [AWTextField factoryBtnWithLeftWidth:60 marginY:AdaptWidth(179)];
    pwdTF.text = pwd;
    UILabel *pwdLeftLab = [self leftLabWithTitle:@"密码"];
    [pwdTF addSubview:pwdLeftLab];
    
    
    [self addSubview:accountTF];
    [self addSubview:pwdTF];
    
}

-(UILabel *)leftLabWithTitle:(NSString *)title
{
    CGFloat labHeight = 15;
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(20, (TFHeight-labHeight)/2.0, 35, labHeight)];
    leftLab.font = FONTSIZE(14);
    leftLab.textColor = GRAYTITLECOLOR;
    leftLab.textAlignment = NSTextAlignmentLeft;
    leftLab.text = title;
    return leftLab;
}

@end
