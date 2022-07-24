//
//  AWPhoneLogin.m
//  AWSDKDemo
//
//  Created by admin on 2021/3/4.
//

#import "AWPhoneLogin.h"
#import "AWChapterLogin.h"
#import "AWPwdLogin.h"

@interface AWPhoneLogin()<UIScrollViewDelegate>
@property(nonatomic, strong)UIButton *chapterLoginBtn;
@property(nonatomic, strong)UIButton *pwdloginBtn;
@property(nonatomic, strong)UIScrollView *scrollview;
@end

@implementation AWPhoneLogin

+(instancetype)factory_phoneLogin
{
    AWPhoneLogin *phoneloginview = [[AWPhoneLogin alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [phoneloginview configUI];
    return phoneloginview;
}

-(void)configUI
{
    [self addbackBtn];
    [self addheaderBtn];
    [self addContentView];
    [self addbottomView];
}

-(void)addbackBtn
{
    AWHGHALLButton *backBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(17, 15, 11, 19)];
    [backBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(phoneGoback) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

-(void)addheaderBtn
{
    CGFloat marginY = 20;
    CGFloat btnHeight = 40;
    CGFloat headerWidth = ViewWidth -60;
//    self.chapterLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, marginY, headerWidth/2.0, btnHeight)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(marginY, marginY, TFWidth, btnHeight)];
    [titleLab setText:GUOJIHUA(@"手机登录")];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = FONTSIZE(20);
    [self addSubview:titleLab];
    
    
    
//    self.pwdloginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+headerWidth/2.0, marginY, headerWidth/2.0, btnHeight)];
//    self.chapterLoginBtn.backgroundColor = [UIColor redColor];
//    [self addSubview:self.chapterLoginBtn];
//    [self addSubview:self.pwdloginBtn];
    [self.chapterLoginBtn setTitle:GUOJIHUA(@"手机登录") forState:UIControlStateNormal];
    [self.chapterLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chapterLoginBtn setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
//    [self.pwdloginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
//    [self.pwdloginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.pwdloginBtn setTitleColor:ORANGECOLOR forState:UIControlStateSelected];
//    self.chapterLoginBtn.selected = YES;
    
//    [self.chapterLoginBtn addTarget:self action:@selector(clickChapterLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.pwdloginBtn addTarget:self action:@selector(clickPwdLogin) forControlEvents:UIControlEventTouchUpInside];
    
}




-(void)addContentView
{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, ViewWidth, ViewHeight-40)];
//    [self addSubview:self.scrollview];
//    self.scrollview.backgroundColor = [UIColor blueColor];
//    self.scrollview.contentSize = CGSizeMake(ViewWidth *2, ViewHeight-40);
//    self.scrollview.delegate = self;
//    self.scrollview.bounces = NO;
//    self.scrollview.pagingEnabled = YES;
//    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, ViewWidth, ViewHeight-40)];
    [self addSubview:contentView];
    
    
    AWChapterLogin *chapterView = [AWChapterLogin factory_chapterLogin];
//    AWPwdLogin *pwdView = [AWPwdLogin factory_pwdlogin];
    
    [contentView addSubview:chapterView];
//    [self.scrollview addSubview:pwdView];
    
    
    
}

-(void)addbottomView
{
    
}

#pragma mark 点击事件
-(void)clickChapterLogin
{
    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    self.pwdloginBtn.selected = NO;
    self.chapterLoginBtn.selected = YES;
}

-(void)clickPwdLogin
{
    [self.scrollview setContentOffset:CGPointMake(ViewWidth, 0) animated:YES];
    self.pwdloginBtn.selected = YES;
    self.chapterLoginBtn.selected = NO;
}

#pragma scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"did scroll ended");
    if (scrollView.contentOffset.x>=ViewWidth) {
        self.pwdloginBtn.selected = YES;
        self.chapterLoginBtn.selected = NO;
    }else{
        self.pwdloginBtn.selected = NO;
        self.chapterLoginBtn.selected = YES;
    }
}


#pragma mark phone back

-(void)phoneGoback
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONLOGINLIST object:self userInfo:nil];
    [self gobackFromSelfView];
}
@end
