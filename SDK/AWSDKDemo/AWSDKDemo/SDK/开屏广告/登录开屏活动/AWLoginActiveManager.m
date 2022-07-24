//
//  AWLoginActiveManager.m
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import "AWLoginActiveManager.h"
#import "AWLoginActiveScreen.h"
#import "AWLaunchScreenViewController.h"
#import "AWScreenImageV.h"
#import "AWScreenModel.h"

@interface AWLoginActiveManager()
@property(nonatomic, strong)AWLoginActiveScreen *loginActiveScreen;

@end

@implementation AWLoginActiveManager


+(instancetype)shareInstance
{
    static AWLoginActiveManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AWLoginActiveManager new];
    });
    return manager;
}


-(void)showLoginActive
{
    
    
    if (self.loginActiveScreen) {
        if ([AWGlobalDataManage shareinstance].isLastActive) {
            return;
        }
        self.loginActiveScreen.hidden = NO;
        return;
    }
    

    [AWDataReport saveEventWittEvent:@"app_show_banner_rank" properties:@{}];
    self.loginActiveScreen = [[AWLoginActiveScreen alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AWLaunchScreenViewController *vc = [AWLaunchScreenViewController new];
    [self.loginActiveScreen setRootViewController:vc];
    [self.loginActiveScreen makeKeyAndVisible];
    
    int count = (int)self.ScreenModelArr.count;
    if (count<1) {
        return;
    }
    for (int i=0; i<count; i++) {
        AWScreenImageV *imageV = [[AWScreenImageV alloc]initWithFrame:[UIScreen mainScreen].bounds];
        imageV.num = i;
        AWScreenModel *model = self.ScreenModelArr[i];
        [imageV configUIWithScreenModel:model];
        [self.loginActiveScreen addSubview:imageV];
        [imageV setCloseBlock:^(BOOL isLast) {
            if (isLast) {
                [self closeScreen];
            }
        }];
    }
    
}

-(void)clickClose
{
    NSLog(@"close screen");
    [self closeScreen];
}


-(void)closeScreen
{
    self.loginActiveScreen.hidden = YES;
}

@end
