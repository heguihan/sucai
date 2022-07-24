//
//  AWMaiType.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/14.
//

#import "AWMaiType.h"

@interface AWMaiType()
@property(nonatomic, strong)AWOrderModel *orderInfo;

@end

@implementation AWMaiType

+(instancetype)factory_maitypeWithOrderInfo:(AWOrderModel *)orderInfo
{
    AWMaiType *maiType = [[AWMaiType alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    maiType.orderInfo = orderInfo;
    [maiType configUI];
    return maiType;
}

-(void)configUI
{
    self.backBtn.hidden = YES;
    self.title = @"支付";
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(75), ViewWidth-MarginX*2, 15)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = FONTSIZE(13.3);
    titleLab.text = @"请选择支付方式";
    [self addSubview:titleLab];
    
    [self addMaimaimaiBtn];
}

-(void)addMaimaimaiBtn
{
    NSArray *maitypeArr = [AWSDKConfigManager shareinstance].pay_type;
    if (maitypeArr.count<1) {
        return;
    }
    
    NSDictionary *iconDict = @{@"PAY_WEIXIN":@"AWSDK.bundle/weixinmai.png",@"PAY_ALIPAY":@"AWSDK.bundle/zhifubao.png"};
    
    CGFloat btnWidth = AdaptWidth(70);
    CGFloat btnHeigt = AdaptWidth(70);
    CGFloat btnY = AdaptWidth(118);
    CGFloat btnMarginX = (ViewWidth-btnWidth*2)/3.0;
    
    if (maitypeArr.count<2) {
        AWHGHALLButton *maiBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake((ViewWidth-btnWidth)/2.0, btnY, btnWidth, btnHeigt)];
        NSString *maiStr = maitypeArr[0];
        [maiBtn setImage:[UIImage imageNamed:[iconDict objectForKey:maiStr]] forState:UIControlStateNormal];
        UILabel *maiLab = [[UILabel alloc]initWithFrame:CGRectMake((ViewWidth-btnWidth)/2.0, btnY+btnHeigt+10, btnWidth, AdaptWidth(17))];
        maiLab.textAlignment = NSTextAlignmentCenter;
        maiLab.font = FONTSIZE(16.67);
        maiLab.textColor = RGBA(49, 49, 49, 1);
        
        [self addSubview:maiLab];
        [self addSubview:maiBtn];
        if ([maiStr isEqualToString:@"PAY_WEIXIN"]) {
            maiLab.text = @"微信支付";
            [maiBtn addTarget:self action:@selector(clickMaiWeixin) forControlEvents:UIControlEventTouchUpInside];
        }else{
            maiLab.text = @"支付宝";
            [maiBtn addTarget:self action:@selector(clickMaiZhifubao) forControlEvents:UIControlEventTouchUpInside];
        }
        return;
    }
    
    for (int i =0; i<maitypeArr.count; i++) {
        AWHGHALLButton *maiBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(btnMarginX+(btnMarginX+btnWidth)*i, btnY, btnWidth, btnHeigt)];
        NSString *maiStr = maitypeArr[i];
        [maiBtn setImage:[UIImage imageNamed:[iconDict objectForKey:maiStr]] forState:UIControlStateNormal];
        
        UILabel *maiLab = [[UILabel alloc]initWithFrame:CGRectMake(btnMarginX+(btnMarginX+btnWidth)*i, btnY+btnHeigt+10, btnWidth, AdaptWidth(17))];
        maiLab.textAlignment = NSTextAlignmentCenter;
        maiLab.font = FONTSIZE(16.67);
        maiLab.textColor = RGBA(49, 49, 49, 1);
//        maiLab.backgroundColor = [UIColor redColor];
        [self addSubview:maiLab];
        [self addSubview:maiBtn];
        if ([maiStr isEqualToString:@"PAY_WEIXIN"]) {
            maiLab.text = @"微信支付";
            [maiBtn addTarget:self action:@selector(clickMaiWeixin) forControlEvents:UIControlEventTouchUpInside];
        }else{
            maiLab.text = @"支付宝";
            [maiBtn addTarget:self action:@selector(clickMaiZhifubao) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}


-(void)clickMaiZhifubao
{
    [AWDataReport saveEventWittEvent:@"app_click_alipay_pay" properties:@{}];
    [self closeAllView];
//    NSString *type = @"265";
//    NSString *alipayType = [AWSDKConfigManager shareinstance].alipay_pay_no;
//    if (alipayType && alipayType.length>0 && !![alipayType intValue]) {
//        type = alipayType;
//    }
//    AWLog(@"alipayType==%@",type);
//
//    [self.delegate selectType:type andOrderInfo:self.orderInfo];
}

-(void)clickMaiWeixin
{
    [AWDataReport saveEventWittEvent:@"app_click_wechat_pay" properties:@{}];
    [self closeAllView];
//    NSString *type = [AWConfig WeixinPayChannel];
//    NSString *weixinType = [AWSDKConfigManager shareinstance].weixin_pay_no;
//    if (weixinType && weixinType.length >0 && !![weixinType intValue]) {
//        type = weixinType;
//    }
//    [self.delegate selectType:type andOrderInfo:self.orderInfo];
}


@end
