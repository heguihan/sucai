//
//  AWMaiResult.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/23.
//

#import "AWMaiResult.h"
#import "AWLocalFile.h"


@implementation AWMaiResult

+(instancetype)factory_maiResultview
{
    AWMaiResult *mairesult = [[AWMaiResult alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [mairesult configUI];
    return mairesult;
}


-(void)configUI
{
//    [self addlogo];
    [self addContent];
}

-(void)addlogo
{
    UIImageView *logoView = [AWSmallControl getLogoView];
    [self addSubview:logoView];
}

-(void)addContent
{

    UILabel *secondRowLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(110), TFWidth, AdaptWidth(17))];

    
    secondRowLab.textColor = RGBA(71, 71, 71, 1);
    secondRowLab.font = FONTSIZE(20);
    secondRowLab.textAlignment = NSTextAlignmentCenter;
    secondRowLab.text = @"是否已支付完成？";

    
    CGFloat btnWidth = ViewWidth/2.0-MarginX*2;
    AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(161), btnWidth, TFHeight)];
    cancelBtn.titleLabel.font = FONTSIZE(14);
    cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
    [cancelBtn setTitle:@"未完成支付" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBA(255, 122, 15, 1) forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = TFHeight/2.0;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    AWOrangeBtn *confirmBtn= [[AWOrangeBtn alloc]initWithFrame:CGRectMake(TFWidth-btnWidth+MarginX, AdaptWidth(161), btnWidth, TFHeight)];
    confirmBtn.titleLabel.font = FONTSIZE(14);
    [confirmBtn setTitle:@"已完成支付" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:secondRowLab];
    [self addSubview:cancelBtn];
    [self addSubview:confirmBtn];
}

-(void)clickCancel
{
    [self closeAllView];
    [AWMaiResult searchOrderIDWithToast:YES];
}

-(void)clickConfirm
{
    [self closeAllView];
    [AWMaiResult searchOrderIDWithToast:YES];
}

+(void)searchOrderIDWithToast:(BOOL)isToast
{
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALORDERINFO];
    if (!dict) {
        return;
    }
    NSInteger request_count = [[dict objectForKey:@"request_count"] integerValue];
    if (request_count<1) {
        [AWLocalFile removeDocumentDataAtPath:LOCALORDERINFO];
        return;
    }
        //查询
        NSString *orderID = dict[@"ORDER_NO"];
        WeakSelf
        [AWHTTPRequest AWSearchOrderRequestwithorderID:orderID IfSuccess:^(id  _Nonnull response) {
            if ([response[@"code"] intValue]==200) {
                NSDictionary *dataDict = response[@"data"];
                if ([dataDict[@"status"] intValue]!=0) {
                    //成功
                    [weakself clearOrder];
                    if (isToast) {
                        [AWTools makeToastWithText:@"支付成功"];
                    }
                    
                }else{
                    [weakself searchNotMai];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            //
        }];
    
}
/*
 [mutableOrder setValue:orderInfo[@"ORDER_NO"] forKey:@"ORDER_NO"];
 [mutableOrder setValue:type forKey:@"mai_type"];
 [mutableOrder setValue:@3 forKey:@"request_count"];
 [mutableOrder setValue:orderInfo[@"AMOUNT"] forKey:@"amount"];
 [mutableOrder setValue:_orderInfo.item_id forKey:@"itemID"];
 [mutableOrder setValue:_orderInfo.item_name forKey:@"itemName"];
 [mutableOrder setValue:_orderInfo.product_type forKey:@"product_type"];
 */
//查询支付状态不成功
+(void)searchNotMai
{
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALORDERINFO];
    if (!dict) {
        return;
    }
    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    NSInteger requestCount = [[mutabDict objectForKey:@"request_count"] integerValue];
    requestCount -= 1;
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",(long)requestCount] forKey:@"request_count"];
    [AWLocalFile saveToLocalWithPath:LOCALORDERINFO withData:mutabDict];
    
}

//查询支付成功
+(void)clearOrder
{
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALORDERINFO];
    if (!dict) {
        return;
    }
    [AWLocalFile removeDocumentDataAtPath:LOCALORDERINFO];
}

@end
