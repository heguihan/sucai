//
//  AWWelcomeView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/9.
//

#import "AWWelcomeView.h"
@interface AWWelcomeView()

@end

@implementation AWWelcomeView

+(instancetype)factory_welcomeViewWithAccount:(NSString *)account andType:(NSString *)type
{
    CGFloat width = 300;
    CGFloat height = 50;
    AWWelcomeView *welcomeView = [[AWWelcomeView alloc]initWithFrame:CGRectMake((SCREENWIDTH-width)/2.0, (SCREENHEIGHT-50)/2.0, width, height)];
    [welcomeView configUIWithAccount:account andType:type];
    return welcomeView;
}

-(void)configUIWithAccount:(NSString *)account andType:(NSString *)type
{
    self.backgroundColor = RGBA(255, 255, 255, 0.9);
    NSDictionary *iconDict =  @{LOGIN_GOOGLE:@"AWSDK.bundle/google.png",LOGIN_PHONE:@"AWSDK.bundle/shouji.png",LOGIN_VISITOR:@"AWSDK.bundle/huojian.png",LOGIN_FACEBOOK:@"AWSDK.bundle/facebook.png"};
    self.layer.cornerRadius = 25.0;
    self.layer.masksToBounds = YES;
    
    CGFloat marginWelcomeX = 40;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(13+marginWelcomeX, 15, 20, 20)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    NSString *imageName = @"AWSDK.bundle/touxiang.png";
    if ([iconDict.allKeys containsObject:type]) {
        imageName = [iconDict objectForKey:type];
    }
    
    
    
    imageV.image = [UIImage imageNamed:imageName];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(57+marginWelcomeX, 15, 170, 20)];
    titleLab.textColor = RGBA(157, 159, 161, 1);
    NSString *allStr = [NSString stringWithFormat:@"%@ %@！",account,GUOJIHUA(@"欢迎回来")];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSInteger lengthx = account.length;
    titleLab.font = FONTSIZE(13);

    NSRange range = NSMakeRange(0, lengthx);
    // 改变字体大小及类型
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGBA(49, 49, 49, 1) range:range];
    [titleLab setAttributedText:noteStr];
    [self addSubview:titleLab];
    
    CGFloat btnWidth = 50;
    CGFloat btnheight = 20;
    AWHGHALLButton *btn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(230, 15, btnWidth, btnheight)];
    
    
    UIImageView *qiehuanIcon = [[UIImageView alloc]initWithFrame:CGRectMake(2, 3, 15, 15)];
    qiehuanIcon.image = [UIImage imageNamed:@"AWSDK.bundle/qiehuan.png"];
    
    UILabel *qiehuanLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 3, 25, 14)];
    qiehuanLab.font = [UIFont systemFontOfSize:12];
    qiehuanLab.textColor = RGBA(157, 159, 161, 1);
    qiehuanLab.text = @"switch";
    
    [btn addSubview:qiehuanLab];
    [btn addSubview:qiehuanIcon];
//    [self addSubview:btn];
    
    [btn addTarget:self action:@selector(clickQiehuan) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)clickQiehuan
{
    //中断定时器 关闭
    [AWGlobalDataManage shareinstance].isClickQiehuanBtn = YES;
    [AWLoginViewManager switchAccount];
}

-(void)show
{
    [AWGlobalDataManage shareinstance].isClickQiehuanBtn = NO;
    UIViewController *currentVC = [AWTools getCurrentVC];
    [currentVC.view addSubview:self];
    //开启定时器 1.5秒关闭 并通知
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AWLog(@"after---%@",[NSThread currentThread]);
        [self removeFromSuperview];
    });
}

@end
