//
//  AWAliasView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/12.
//

#import "AWAliasView.h"

@interface AWAliasView()
@property(nonatomic, strong)AWTextField *AccountNameTF;
@property(nonatomic, strong)AWTextField *AliasNameTF;

@end


@implementation AWAliasView


+(instancetype)factory_aliasview
{
    AWAliasView *aliasview = [[AWAliasView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    [aliasview configUI];
    return aliasview;
}

-(void)configUI
{
    self.title = GUOJIHUA(@"修改账号名");
    self.backBtn.hidden = YES;
    
    [self addScontentView];
}

-(void)addScontentView
{
    self.AccountNameTF =  [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(78)];
    self.AliasNameTF =  [AWTextField factoryBtnWithLeftWidth:TFLEFTWIDTH marginY:AdaptWidth(126)];
    
    self.AliasNameTF.placeholder = GUOJIHUA(@"设置一个好记的账号名，只有一次机会");
    NSString *show_account = [AWUserInfoManager shareinstance].show_account;
    self.AccountNameTF.text = [NSString stringWithFormat:@"alias：%@",show_account];
    
    
    
    AWOrangeBtn *ConfirmBtn = [AWOrangeBtn factoryBtnWithTitle:GUOJIHUA(@"确认修改") marginY:AdaptWidth(186)];
    [ConfirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.AccountNameTF];
    [self addSubview:self.AliasNameTF];
    [self addSubview:ConfirmBtn];
}

-(void)clickConfirm
{
    NSString *aliasStr = self.AliasNameTF.text;
    if (!(aliasStr && aliasStr.length>0)) {
        [AWTools makeToastWithText:@"Set a alias"];
    }
    [AWHTTPRequest AWAliasAccouintRequestwithAlias:aliasStr IfSuccess:^(id  _Nonnull response) {
        //
    } failure:^(NSError * _Nonnull error) {
        //
    }];
}



@end
