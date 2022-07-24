//
//  AWBroadcastData.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import "AWBroadcastData.h"

@implementation AWBroadcastData
+(instancetype)shareinstance
{
    static AWBroadcastData *broadcast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        broadcast = [[AWBroadcastData alloc]init];
    });
    return broadcast;
}

-(void)setbroadlistdataWithArr:(NSArray *)arr
{
    NSMutableArray *resultArr = [NSMutableArray array];
    if (arr.count<=0) {
        return;
    }
    NSDictionary *actionDic = @{@"EXCHANGE":GUOJIHUA(@"兑换了"),@"GET":GUOJIHUA(@"领取了")};
//    int xx = 0;
    NSLog(@"兑换=====%@",GUOJIHUA(@"兑换了"));
    for (NSDictionary *dic in arr) {
//        xx +=1;
        NSString *actionStr =GUOJIHUA(@"领取了");
        if ([actionDic.allKeys containsObject:dic[@"type"]]) {
            actionStr = [actionDic objectForKey:dic[@"type"]];
        }
        NSString *amountSTr = dic[@"amount"];
        NSString *preStr = [NSString stringWithFormat:@"%@ %@",dic[@"account"],actionStr];
        NSString *showTitle = [NSString stringWithFormat:@"%@ %@ %@",preStr,amountSTr,GUOJIHUA(@"红包")];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:showTitle];
        NSInteger index = preStr.length+1;
        NSInteger lengthx = amountSTr.length;
    
        NSRange range = NSMakeRange(index, lengthx);
        // 改变字体大小及类型
        [noteStr addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:range];
        [resultArr addObject:noteStr];
    }
    self.broadList = [resultArr copy];
    
}

-(void)setBroadList:(NSArray *)broadList
{
    _broadList = broadList;
    //这里去更新滚动消息
}

@end
