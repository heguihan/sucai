//
//  AWHinMsgView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/14.
//

#import "AWHinMsgView.h"
@interface AWHinMsgView()
@property(nonatomic, strong)NSString *contentStr;
@end

@implementation AWHinMsgView

+(instancetype)factory_hinMsg
{
    AWHinMsgView *hinMsg = [[AWHinMsgView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [hinMsg configUI];
    return hinMsg;
}

-(void)configUI
{
    AWHGHALLButton *closeBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(ViewWidth-34, 15, 17, 17)];
    [closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/close.png"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(MarginX, 40, ViewWidth-MarginX*2, ViewHeight-100)];
    textV.backgroundColor = [UIColor clearColor];
    [self addSubview:textV];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
     
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    
    textV.font = FONTSIZE(14);
    [textV setEditable:NO];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *channelID =[NSString stringWithFormat:@"%@%@",GUOJIHUA(@"channelID"),[AWConfig CUrrentCHannelID]];
    NSString *imei = [NSString stringWithFormat:@"idfa:%@",[AWTools getIdfa]];
    NSString *oaid = [NSString stringWithFormat:@"uuid:%@",[AWTools getUUID]];
//    NSString *gameversion =[NSString stringWithFormat:@"游戏版本:%@",app_Version];
//    NSString *sdkversion = [NSString stringWithFormat:@"SDK版本:%@",[AWConfig SDKversion]];
    NSString *userID = [NSString stringWithFormat:@"%@:%@",GUOJIHUA(@"账号"),[AWUserInfoManager shareinstance].account];
    NSString *packageName = [NSString stringWithFormat:@"%@%@",GUOJIHUA(@"包名"),[AWTools getCurrentBundleID]];
    
    NSString *version = [NSString stringWithFormat:@"%@%@&%@(game&SDK)",GUOJIHUA(@"版本"),app_Version,[AWConfig SDKversion]];
    
    
    NSString *allContentStr = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",userID,channelID,imei,version,packageName];
//    textV.text = allContentStr;
    textV.attributedText =[[NSAttributedString alloc]initWithString:allContentStr attributes:attributes];
    self.contentStr = allContentStr;
    
    CGFloat btnWidth = 140;
    AWOrangeBtn *copyBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake((ViewWidth-btnWidth)/2.0, ViewHeight-TFHeight-15, btnWidth, TFHeight)];
    copyBtn.titleLabel.font = FONTSIZE(15.6);
    copyBtn.layer.cornerRadius = TFHeight/2.0;
    copyBtn.layer.masksToBounds = YES;
    [copyBtn setTitle:GUOJIHUA(@"点击复制") forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(clickCopy) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copyBtn];
    
    
}

-(void)clickCopy
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentStr;
    [AWTools makeToastWithText:GUOJIHUA(@"复制成功")];
}

-(void)clickClose
{
    [self closeAllView];
}

@end
