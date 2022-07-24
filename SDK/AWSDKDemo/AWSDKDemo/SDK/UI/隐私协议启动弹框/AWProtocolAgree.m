//
//  AWProtocolAgree.m
//  AWSDKDemo
//
//  Created by admin on 2021/11/17.
//

#import "AWProtocolAgree.h"
#import "GGGLabel.h"
#import "NSAttributedString+GGGText.h"

@implementation AWProtocolAgree

+(instancetype)factory_protocolAgreeView
{
    AWProtocolAgree *protocolView = [[AWProtocolAgree alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [protocolView configUI];
    return protocolView;
}

-(void)configUI
{
    self.title = @"用户协议和隐私政策";
    self.closeBtn.hidden = YES;
    self.backBtn.hidden = YES;
    [self addContent];
    [self addBtn];
}

-(void)addContent
{
    GGGLabel *lab = [[GGGLabel alloc]initWithFrame:CGRectMake(MarginX, 40, TFWidth, 200)];
    [self addSubview:lab];
    
    NSString *contentStr = @"\u3000\u3000亲爱的玩家，欢迎体验我们的游戏。我们非常重视您的个人信息和隐私保护，在您进入游戏世界之前，请你务必谨慎阅读《用户协议》、《隐私政策》，并充分理解协议条款内容，我们将严格按照您同意的各项条款使用您的个人信息，以便为你提供更好的服务。";
    
    BOOL isprivacy = NO;
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:contentStr];
//    NSArray *linkList = [AWSDKConfigManager shareinstance].link;
//    if (linkList.count>0) {
//        for (NSDictionary *dic in linkList) {
//            if ([dic.allKeys containsObject:@"key"]) {
//                if ([dic[@"key"] isEqualToString:@"Privacy"]) {
//                    [mutableStr appendString:@"和《隐私协议》"];
//                    isprivacy = YES;
//                }
//            }
//        }
//    }

    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: [mutableStr copy]];
     text.yy_lineSpacing = 5;
     text.yy_font = FONTSIZE(14);
     text.yy_color = BLACKCOLOR;
     [text yy_setTextHighlightRange:NSMakeRange(55, 6) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
         AWLog(@"xxx协议被点击了");
         [AWLoginViewManager showUserProtocol];

     }];

    [text yy_setTextHighlightRange:NSMakeRange(62, 6) color:[UIColor orangeColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        AWLog(@"xxx协议被点击了");
        [AWLoginViewManager showPrivacyProtocol];

    }];
    
    lab.numberOfLines = 0;  //设置多行显示
    lab.preferredMaxLayoutWidth = TFWidth; //设置最大的宽度
    lab.attributedText = text;  //设置富文本
    
}

-(void)addBtn
{
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    UIButton *refuseBtn = [[UIButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(220), btnWidth, TFHeight)];
    refuseBtn.titleLabel.font = FONTSIZE(14);
    refuseBtn.backgroundColor = RGBA(204, 204, 204, 1);
    [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refuseBtn.layer.cornerRadius = TFHeight/2.0;
    refuseBtn.layer.masksToBounds = YES;
    [refuseBtn addTarget:self action:@selector(clickRefuse) forControlEvents:UIControlEventTouchUpInside];
    
    
    AWOrangeBtn *agreeBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(220), btnWidth, TFHeight)];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = FONTSIZE(14);
    [agreeBtn addTarget:self action:@selector(clickAgree) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:refuseBtn];
    [self addSubview:agreeBtn];
}

-(void)clickRefuse
{
    //数据立即上报 + 2.5秒退出游戏
    [AWDataReport saveEventWittEvent:@"app_agreement_privacy_click_reject" properties:@{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AWGlobalDataManage shareinstance] reportLocalDataWithTime:0 andPath:LOCALREPORTINFO];
    });
    
    float delay = 2.5;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [AWTools leaveGame];
    });
}

-(void)clickAgree
{
    [AWTools setIDFA];
    [AWGlobalDataManage shareinstance].isSDKFinished = YES;
    [AWLoginViewManager loginCheck];
    [AWDataReport saveEventWittEvent:@"app_agreement_privacy_click_agree" properties:@{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AWGlobalDataManage shareinstance] reportLocalDataWithTime:0 andPath:LOCALREPORTINFO];
    });
    //数据立即上报 + next  记录点击过同意 下次不再显示
    [AWTools saveFlagWithPath:LOCALPROTOCOLAGREEE];
    [AWTools removeViews:[AWViewManager shareInstance].protoclAgreeFutherView];
}


-(void)show
{
    [AWDataReport saveEventWittEvent:@"app_show_agreement_privacy" properties:@{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AWGlobalDataManage shareinstance] reportLocalDataWithTime:0 andPath:LOCALREPORTINFO];
    });
    [[AWViewManager shareInstance].protoclAgreeFutherView addSubview:self];
}

@end
