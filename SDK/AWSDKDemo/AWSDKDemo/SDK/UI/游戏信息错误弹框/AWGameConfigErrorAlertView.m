//
//  AWGameConfigErrorAlertView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWGameConfigErrorAlertView.h"

@implementation AWGameConfigErrorAlertView

+(instancetype)factory_gameconfigErrorWithContentStr:(NSString *)contentStr
{
    AWGameConfigErrorAlertView *gameErrorv = [[AWGameConfigErrorAlertView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [gameErrorv configUIWithContentStr:contentStr];
    return gameErrorv;
}

-(void)configUIWithContentStr:(NSString *)contentStr
{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(31), TFWidth, 20)];
    titleLab.font = FONTSIZE(18);
    titleLab.textColor = TEXTBLACKCOLOR;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"温馨提示";

    UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(75), TFWidth, AdaptWidth(60))];
    contentLab.textColor = TEXTBLACKCOLOR;
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.font = FONTSIZE(14);
    contentLab.numberOfLines = 0;
    contentLab.text = contentStr;
    
    AWOrangeBtn *againBtn = [AWOrangeBtn factoryBtnWithTitle:@"请重试" marginY:AdaptWidth(161)];
    [againBtn addTarget:self action:@selector(clickAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:titleLab];
    [self addSubview:contentLab];
    [self addSubview:againBtn];
    
}

-(void)clickAgain
{
    [self closeAllView];
    //初始化的时候  重新拉取初始化的数据
    [AWHTTPRequest AWinitRequestifSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}

@end
