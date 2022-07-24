//
//  AWDataReport.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/15.
//

#import "AWDataReport.h"
#import "AWLocalFile.h"
#import "AWDeviceInfo.h"

@implementation AWDataReport
//需要延时的存数据上报

//需要延时的上报
+(void)saveDataDelayWithEvent:(NSString *)event properties:(NSDictionary *)properties
{
    NSDictionary *dict = @{@"event":event,
                           @"properties":properties,
                           @"timestamp":[AWTools getCurrentTimeString]
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveDataDelayReportEvent:dict];
    });
}

//不需要延时的存数据上报
+(void)saveEventWittEvent:(NSString *)event properties:(NSDictionary *)properties
{
    NSDictionary *dict = @{@"event":event,
                           @"properties":properties,
                           @"timestamp":[AWTools getCurrentTimeString]
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveSDKDataViewEnent:dict];
    });
    
}

+(void)saveRegisterEventWittEvent:(NSString *)event properties:(NSDictionary *)properties timestamp:(NSString *)timestamp
{
    NSDictionary *dict = @{@"event":event,
                           @"properties":properties,
                           @"timestamp":timestamp
    };
    [self saveSDKDataViewEnent:dict];
}

+(void)reSaveDataWithJsonData:(NSArray *)reSaveDataArr withPath:(NSString *)path
{
    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithArray:[self loadReportData]];
    
    for (NSDictionary *dict in reSaveDataArr) {
        [dataArr addObject:dict];
    }
    [AWLocalFile saveToLocalWithPath:path withData:dataArr];
}

//SDK里面的埋点，立即上报
+(void)saveSDKDataViewEnent:(NSDictionary *)event
{
    [self saveDataToLocal:event WithPath:LOCALREPORTINFO];
    //立即上报
    [[AWGlobalDataManage shareinstance] reportLocalRightNow];
}


//从红包页面的埋点
+(void)saveDataDelayReportEvent:(NSDictionary *)event
{
    [self saveDataToLocal:event WithPath:LOCALDELAYREPORTINFO];
}

//这里保存数据到本地
+(void)saveDataToLocal:(NSDictionary *)event WithPath:(NSString *)path
{
    //    NSDictionary *reportInfo = @{};
    //    NSString *currentUid = [[NSUserDefaults standardUserDefaults] objectForKey:SDKUSERACCOUNTFIELD];
        NSString *currentUid = [AWGlobalDataManage shareinstance].currentAccount;
        
        if (!currentUid) {
            currentUid = @"";
        }
        NSMutableArray *dataArr = [[NSMutableArray alloc]initWithArray:[self loadReportData]];
        
        if (dataArr.count<=0) {
            NSDictionary *reportDict = [self getNewUserReportWithEvent:event andUid:currentUid];
            [dataArr addObject:reportDict];
        }else{
            int tagi = 0;
            for (int i =0; i<dataArr.count; i++) {
                NSDictionary *dict = dataArr[i];
                if ([dict[@"unique_id"] isEqualToString:currentUid]){
                    NSMutableArray *eventsArr = [[NSMutableArray alloc]initWithArray:dict[@"events"]];
                    [eventsArr addObject:event];
                    NSMutableDictionary *mutableDict = [dict mutableCopy];
                    [mutableDict setValue:eventsArr forKey:@"events"];
                    [dataArr removeObject:dict];
                    [dataArr addObject:[mutableDict copy]];
                    tagi += 1;
                    break;
                }
            }
            
            if (tagi==0) {
                NSDictionary *newUserDict = [self getNewUserReportWithEvent:event andUid:currentUid];
                [dataArr addObject:newUserDict];
            }
        }
        [AWLocalFile saveToLocalWithPath:path withData:dataArr];
}


+(NSDictionary *)getNewUserReportWithEvent:(NSDictionary *)event andUid:(NSString *)uid
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *reportDict = @{@"device_id":[AWTools getIdfa],
                                 @"app_id":[AWConfig CurrentAppID],
                                 @"app_ver":[NSString stringWithFormat:@"%@&%@",app_Version,[AWConfig SDKversion]],
                                 @"channel_id":[AWConfig CUrrentCHannelID],
                                 @"events":@[event],
                                 @"network_type":[AWDeviceInfo getNetconnType],
                                 @"unique_id":uid
    };
    return reportDict;
}

+(NSMutableArray *)loadReportData
{
    NSMutableArray *mutabArr = [AWLocalFile loadLocalCache:LOCALREPORTINFO];
    if (!mutabArr) {
        AWLog(@"null");
        mutabArr = [NSMutableArray array];
    }
    return mutabArr;
}

+(void)removeAllReportDataWithPath:(NSString *)path
{
    [AWLocalFile removeDocumentDataAtPath:path];
}
@end
