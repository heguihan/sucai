//
//  AWMaiSuccessResult.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/23.
//

#import "AWMaiSuccessResult.h"
#import "AWLocalFile.h"


@implementation AWMaiSuccessResult
+(void)maiResultWithType:(NSString *)type
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awmairesultnotice" object:nil userInfo:@{@"payType":@"alipay",@"status":@"success"}];
    NSDictionary *dict = [AWLocalFile loadLocalCache:LOCALORDERINFO];
    if (!dict) {
        return;
    }
    
    double amountdouble = [dict[@"amount"] doubleValue] *1;
    NSInteger amountInt = amountdouble/1;
    
    [AWLocalFile removeDocumentDataAtPath:LOCALORDERINFO];
    
}
@end
