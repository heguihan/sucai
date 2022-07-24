//
//  AWCustomerView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWCustomerView.h"

@interface AWCustomerView()
@property(nonatomic, strong)NSArray *customArr;
@end

@implementation AWCustomerView

+(instancetype)factory_customerview
{
    AWCustomerView *customer = [[AWCustomerView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [customer configUI];
    return customer;
}

-(void)configUI
{
    [self addheaderView];
    [self addcontentView];
}

-(void)addheaderView
{
    AWHGHALLButton *backBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(17, 15, 11, 19)];
    [backBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *customerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptWidth(68), AdaptWidth(9), AdaptWidth(96), AdaptWidth(78))];
    customerImageV.image = [UIImage imageNamed:@"AWSDK.bundle/customer.png"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(AdaptWidth(178), AdaptWidth(20), 120, AdaptWidth(60))];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = FONTSIZE(23.6);
    lab.textColor = BLACKCOLOR;
    lab.text = @"Customer Services";
    lab.numberOfLines = 0;
    
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, AdaptWidth(87))];
    [self addSubview:headerview];
    headerview.backgroundColor = NAVICOLOR;
    
    [headerview addSubview:backBtn];
    [headerview addSubview:customerImageV];
    [headerview addSubview:lab];
    
}

-(void)addcontentView
{
    UIImage *fbImage = [UIImage imageNamed:@"AWSDK.bundle/aw_kefu_fb.png"];
    UIImage *emailImage = [UIImage imageNamed:@"AWSDK.bundle/aw_kefu_email.png"];
    UIImage *telphoneImage = [UIImage imageNamed:@"AWSDK.bundle/aw_kefu_phone.png"];
    
    NSString *fb = [AWSDKConfigManager shareinstance].kefu_fb;
    NSString *email = [AWSDKConfigManager shareinstance].kefu_email;
    NSString *telPhone = [AWSDKConfigManager shareinstance].kefu_phone;
    
    NSMutableArray *allCustomWayArr = [NSMutableArray array];
    if (telPhone) {
        NSDictionary *dict = @{@"name":@"phone",@"content":telPhone,@"image":telphoneImage,@"namekey":@"phone"};
        [allCustomWayArr addObject:dict];
    }
    if (email) {
        NSDictionary *dict = @{@"name":@"email",@"content":email,@"image":emailImage,@"namekey":@"email"};
        [allCustomWayArr addObject:dict];
    }
    if (fb){
        NSDictionary *dict = @{@"name":@"facebook",@"content":fb,@"image":fbImage,@"namekey":@"fb"};
        [allCustomWayArr addObject:dict];
    }
    self.customArr = [allCustomWayArr copy];
    
    CGFloat firstYY = 100;
    if (allCustomWayArr.count==2) {
        firstYY = 120;
    }else if (allCustomWayArr.count == 1){
        firstYY = 155;
    }else if (allCustomWayArr.count==3){
        firstYY = 100;
        CGRect frame = self.frame;
        frame.size.height += 30;
        self.frame = frame;
        
    }else{
        [AWTools makeToastWithText:@"暂无客服信息"];
        [self clickBack];
        return;
    }
    
    
    CGFloat fbW = [AWTools getWidthWithText:fb height:20 font:FONTSIZE(16)];
    CGFloat emailW = [AWTools getWidthWithText:email height:20 font:FONTSIZE(16)];
    CGFloat phoneW = [AWTools getWidthWithText:telPhone height:20 font:FONTSIZE(20)];
    CGFloat mostLength = fbW;
    if (emailW > mostLength) {
        mostLength = emailW;
    }
    if (phoneW > mostLength) {
        mostLength = phoneW;
    }
    
    CGFloat contentLength = ViewWidth-MarginX - 28;
    if (mostLength> contentLength) {
        mostLength = contentLength;
    }
    CGFloat imageX = (ViewWidth-mostLength-28)/2.0;
    CGFloat margincustomYY = 60;

    
    for (int i=0; i<self.customArr.count; i++) {
        NSDictionary *dictContent = self.customArr[i];
        NSString *name = dictContent[@"name"];
        NSString *contentStr = dictContent[@"content"];
        UIImage *image = dictContent[@"image"];
        UIView *customview = [self imageTitleViewWithTitle:name account:contentStr image:image x:imageX y:firstYY+margincustomYY * i];
        [self addSubview:customview];
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview:)];
        customview.tag = 300+i;
        [customview addGestureRecognizer:Tap];
    }
        
}

-(UIView *)imageTitleViewWithTitle:(NSString *)title account:(NSString *)account image:(UIImage *)image x:(CGFloat)x y:(CGFloat)y
{

    
    UIImageView *imageIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 25, 25)];
    imageIconView.image = image;
    
    UILabel *accountLab = [[UILabel alloc]initWithFrame:CGRectMake(28, 20, 240, 25)];
    accountLab.font = FONTSIZE(16);

    accountLab.textAlignment = NSTextAlignmentLeft;
    accountLab.textColor = RGBA(10, 166, 156, 1);
    accountLab.text = account;
    if ([title isEqualToString:@"phone"]) {
        accountLab.font = FONTSIZE(20);
        accountLab.textColor = [UIColor blackColor];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, y, 140, 48)];
    [view addSubview:imageIconView];
    [view addSubview:accountLab];
    return view;
}

-(UIView *)iconAndImageWithimage:(UIImage *)image title:(NSString *)title
{
    CGFloat labWidth = [AWTools getWidthWithText:title height:20 font:FONTSIZE(14)];
    CGFloat vieWidth = labWidth + 24;
    CGFloat viewX = (140 - vieWidth)/2.0;
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(viewX, 0, 17, 17)];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.image = image;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(viewX +24, 0, labWidth, 17)];
    lab.text = title;
    lab.font = FONTSIZE(14);
    lab.textColor = BLACKCOLOR;
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 20)];
    [contentView addSubview:icon];
    [contentView addSubview:lab];
    return contentView;
}

-(void)clickBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONLOGINLIST object:self userInfo:nil];
    [self gobackFromSelfView];
}

-(void)tapview:(UITapGestureRecognizer *)ges
{
    NSLog(@"ges tag===%lu",ges.view.tag);
    NSInteger index = ges.view.tag -300;
    NSDictionary *dict = self.customArr[index];
    
    NSString *methodStr = dict[@"namekey"];
    methodStr = [NSString stringWithFormat:@"tap_%@",methodStr];
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(clickBack)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    SEL selectorx = NSSelectorFromString(methodStr);
    invocation.selector = selectorx;
    [invocation invoke];

}

-(void)tap_fb
{
//    NSLog(@"qq");
    NSString *str =[AWSDKConfigManager shareinstance].kefu_fb;
    if (str) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    //
                }
        }];
    }
}

-(void)tap_email
{
    NSLog(@"email");
    NSString *str =[AWSDKConfigManager shareinstance].kefu_email;
    str = [NSString stringWithFormat:@"mailto:%@",str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        //
    }];
}

-(void)tap_phone
{
    NSLog(@"phone");
    NSString *telPhone = [AWSDKConfigManager shareinstance].kefu_phone;
    if (telPhone) {
        [AWTools telWithPhoneNO:telPhone];
    }
}



@end
