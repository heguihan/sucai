//
//  HGHLogin.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHLogin.h"
#import "HGHNetWork.h"
#import "HGHExchange.h"
#import "HGHTools.h"
#import "HGHUIFrame.h"
#import "HGHGoogleLoginViewController.h"
#import "HGHAccount.h"
#import "HGHFacebookLogin.h"
#import "HGHEmailLogin.h"
#import "HGHAccountManager.h"
#import "HGHTourists.h"
#import "HGHConfig.h"
#import "HGHAppleLogin.h"
#import "HGHAlertview.h"
@implementation HGHLogin
+(instancetype)shareinstance
{
    static HGHLogin *login = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[HGHLogin alloc]init];
    });
    return login;
}

-(UIView *)baseView
{
    if (!_baseView) {
        _baseView =[[UIView alloc]initWithFrame:CGRectMake(XPOINT, YPOINT, VIEWWIDTH, VIEWHEIGHT)];
    }
    return _baseView;
}
+(void)fblogin
{
    [[HGHFacebookLogin shareinstance]facebookLogin:YES];
}

-(void)Login
{
    

    UIViewController *currentVC = [HGHTools getCurrentViewcontronller];
    UIImageView *orangeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
//    orangeView.backgroundColor = [UIColor orangeColor];
    [orangeView setImage:[UIImage imageNamed:@"outSea.bundle/bg.png"]];
//    [currentVC.view addSubview:orangeView];
    orangeView.userInteractionEnabled = YES;
//    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(XPOINT, YPOINT, VIEWWIDTH, VIEWHEIGHT)];
    self.baseView.userInteractionEnabled = YES;
    [self.baseView addSubview:orangeView];
    [currentVC.view addSubview:self.baseView];
    CGFloat btnWidth = [HGHUIFrame adapterWidth:362];
    CGFloat btnWidthnew = btnWidth;
    CGFloat emailBtnY = [HGHUIFrame adapterHeight:106];
    UIButton *emailAccountBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-btnWidthnew)/2, emailBtnY+56, btnWidthnew, 40)];
    [emailAccountBtn setImage:[UIImage imageNamed:@"outSea.bundle/hgh_acingameLogin.png"] forState:UIControlStateNormal];
//    [emailAccountBtn setImage:[UIImage imageNamed:@"fb_icon.png"] forState:UIControlStateNormal];
//    [emailAccountBtn setTitle:@"acingame login" forState:UIControlStateNormal];
    CGFloat backY = [HGHUIFrame adapterWidth:15];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, backY, 20, 30)];
//    [self.baseView addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"outSea.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageVAC = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 24)];
    imageVAC.image = [UIImage imageNamed:@"outSea.bundle/user.png"];
//    [emailAccountBtn addSubview:imageVAC];
    UILabel *acLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
    acLab.text = [NSString stringWithFormat:@"ACINGAME %@",GuoJiHua(@"登录大写")];
//    [emailAccountBtn addSubview:acLab];
    
    emailAccountBtn.backgroundColor = [UIColor clearColor];
    [orangeView addSubview:emailAccountBtn];
    [emailAccountBtn addTarget:self action:@selector(emailLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *customApple = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-btnWidthnew)/2, emailBtnY, btnWidthnew, 40)];
    [orangeView addSubview:customApple];
    [customApple setImage:[UIImage imageNamed:@"outSea.bundle/hgh_appleLogin.png"] forState:UIControlStateNormal];
    [customApple addTarget:self action:@selector(appleLogin:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (@available(iOS 13.0, *)) {
//        ASAuthorizationAppleIDButton *appleBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
//            appleBtn.frame =CGRectMake((VIEWWIDTH-btnWidthnew)/2, emailBtnY, btnWidthnew, 40);
//        [orangeView addSubview:appleBtn];
//        [appleBtn addTarget:self action:@selector(appleLogin:) forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        UIButton *customApple = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-btnWidthnew)/2, emailBtnY, btnWidthnew, 40)];
//        [orangeView addSubview:customApple];
//        [customApple setImage:[UIImage imageNamed:@"outSea.bundle/hgh_appleLogin.png"] forState:UIControlStateNormal];
//        [customApple addTarget:self action:@selector(appleLogin:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
//    CGFloat facebookBtnY = []
//    CGRectMake(touristsBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX-5, otherBtnY-5, otherBtnWidth+5, 65)
//    UIButton *facebookAccountBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-btnWidth)/2, emailBtnY+56, btnWidth, 40)];
    /*
    UIButton *facebookAccountBtn = [[UIButton alloc]initWithFrame:CGRectMake(touristsBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX-5, otherBtnY-5, otherBtnWidth+5, 65)];
    [facebookAccountBtn setImage:[UIImage imageNamed:@"outSea.bundle/white.png"] forState:UIControlStateNormal];
    [orangeView addSubview:facebookAccountBtn];
    UIImageView *imageVFB = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageVFB.image = [UIImage imageNamed:@"outSea.bundle/fb.png"];
    UILabel *fbLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
    fbLab.text = [NSString stringWithFormat:@"FACEBOOK %@",GuoJiHua(@"登录大写")];
    [facebookAccountBtn addSubview:imageVFB];
    [facebookAccountBtn addSubview:fbLab];
    
  
    [facebookAccountBtn addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    
      */
    
    CGFloat labY = emailBtnY + 96 + [HGHUIFrame adapterHeight:20];
    UILabel *otherLab = [[UILabel alloc]initWithFrame:CGRectMake((VIEWWIDTH-btnWidth)/2, labY, btnWidth, 25)];
//    otherLab.text = @"—————Or login with—————";
    otherLab.text = [NSString stringWithFormat:@"————%@————",GuoJiHua(@"其他方式登录")];
    otherLab.textAlignment = NSTextAlignmentCenter;
    [orangeView addSubview:otherLab];
    
    CGFloat otherBtnWidthall = [HGHUIFrame adapterWidth:280];
    CGFloat otherBtnWidth = [HGHUIFrame adapterWidth:70];
    CGFloat otherBtnY = labY+25+[HGHUIFrame adapterHeight:20];
    CGFloat distanceX = (otherBtnWidthall - 50*3)/2;
    
    CGFloat SecondX = (VIEWWIDTH + [HGHUIFrame adapterWidth:36])/2;
    
    UIButton *touristsBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEWWIDTH-otherBtnWidthall)/2, otherBtnY, 50, 50)];

    

//    UIButton *appleBtn = [[UIButton alloc]init];
//    appleBtn.frame = CGRectMake(touristsBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX-5, otherBtnY-5, otherBtnWidth+5, 65);
//    UIButton *appleBtn = [[UIButton alloc]initWithFrame:CGRectMake(touristsBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX-5, otherBtnY-2, otherBtnWidth, 52)];
//    UIButton *googleBtn = [[UIButton alloc]initWithFrame:CGRectMake(appleBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX, otherBtnY, otherBtnWidth, 50)];
    
    
    touristsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [touristsBtn setImage:[UIImage imageNamed:@"outSea.bundle/guest_icon.png"] forState:UIControlStateNormal];
    [touristsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    touristsBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    
    
    UIButton *facebookAccountBtn = [[UIButton alloc]initWithFrame:CGRectMake(touristsBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX, otherBtnY, 50, 50)];
    [facebookAccountBtn setImage:[UIImage imageNamed:@"outSea.bundle/fb_icon.png"] forState:UIControlStateNormal];
    [orangeView addSubview:facebookAccountBtn];
    UIImageView *imageVFB = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageVFB.image = [UIImage imageNamed:@"outSea.bundle/fb_icon.png"];
    UILabel *fbLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
    fbLab.text = [NSString stringWithFormat:@"FACEBOOK %@",GuoJiHua(@"登录大写")];
//    [facebookAccountBtn addSubview:imageVFB];
//    [facebookAccountBtn addSubview:fbLab];
    
    [facebookAccountBtn addTarget:self action:@selector(facebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *googleBtn = [[UIButton alloc]initWithFrame:CGRectMake(facebookAccountBtn.frame.origin.x+touristsBtn.frame.size.width+distanceX, otherBtnY, 50, 50)];
    [googleBtn setImage:[UIImage imageNamed:@"outSea.bundle/google_icon.png"] forState:UIControlStateNormal];
    googleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    googleBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [googleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    appleBtn.backgroundColor = [UIColor blueColor];
    [orangeView addSubview:touristsBtn];
    [orangeView addSubview:googleBtn];
//    [orangeView addSubview:appleBtn];
    [touristsBtn addTarget:self action:@selector(touristsLogin:) forControlEvents:UIControlEventTouchUpInside];
    [googleBtn addTarget:self action:@selector(googleLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [appleBtn addTarget:self action:@selector(appleLogin:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goback:(UIButton *)sender
{
    [self.baseView removeFromSuperview];
}

-(void)gotoGoogle:(UIButton *)sender
{
    sender.backgroundColor = [UIColor blackColor];
    [sender.superview layoutSubviews];
    
    [[HGHAccount shareinstance] gotoAccount];
    NSLog(@"end");
}

-(void)appleLogin:(UIButton *)sender
{
    NSLog(@"appleLogin");
    if (@available(iOS 13.0, *)) {
        [[HGHAppleLogin shareinstance] HGHsignInWithApple];
    } else {
        [HGHAlertview showAlertViewWithMessage:GuoJiHua(@"仅限ios13以上用户使用")];
    }
}

-(void)facebookLogin:(UIButton *)sender
{
    NSLog(@"facebookLogin");
//    [[HGHAccountManager shareInstance]accountManager];
    [[HGHFacebookLogin shareinstance]facebookLogin:YES];
}

-(void)touristsLogin:(UIButton *)sender
{
    NSLog(@"touristsLogin");
    [HGHTourists touristsLogin];
}

-(void)googleLogin:(UIButton *)sender
{
    NSLog(@"GoogleLogin");
    HGHGoogleLoginViewController *gvc = [[HGHGoogleLoginViewController alloc]init];;
    gvc.islogin = YES;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:gvc];
    
    [[HGHTools getCurrentViewcontronller] presentViewController:navi animated:NO completion:nil];
//    [self.hghimagevc removeFromSuperview];
}

-(void)emailLogin:(UIButton *)sender
{
    NSLog(@"emailLogin");
    [[HGHEmailLogin shareInstance] emailLogin];;
}
@end
