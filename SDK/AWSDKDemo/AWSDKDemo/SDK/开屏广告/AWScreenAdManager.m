//
//  AWScreenAdManager.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/16.
//

#import "AWScreenAdManager.h"
#import "AWLaunchScreenViewController.h"

@implementation AWScreenAdManager
+(instancetype)shareInstance
{
    static AWScreenAdManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AWScreenAdManager new];
    });
    return manager;
}

-(void)showAdScreen
{
    self.adScreenView = [[AWADScreen alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AWLaunchScreenViewController *vc = [AWLaunchScreenViewController new];
    [self.adScreenView setRootViewController:vc];
    [self.adScreenView makeKeyAndVisible];
    self.adScreenView.jimURL = self.jump_url;
    self.adScreenView.scheme = self.schemeurl;
    self.adScreenView.jumpType = self.jumpType;
    self.adScreenView.userInteractionEnabled = YES;
    
    [self.adScreenView.jumpBtn addTarget:self action:@selector(clickJump) forControlEvents:UIControlEventTouchUpInside];
    self.adScreenView.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.img_normal]]];
    
    AWHGHALLButton *jumpBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 10, 100, 80)];
//    jumpBtn.backgroundColor = [UIColor yellowColor];
//    [jumpBtn setTitle:@"点击跳过" forState:UIControlStateNormal];
    [self.adScreenView addSubview:jumpBtn];
    [jumpBtn addTarget:self action:@selector(clickJump) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)clickJump
{
    AWLog(@"click out btn");
    self.adScreenView.hidden = YES;
    [self.adScreenView destoryTimer];
}

@end
