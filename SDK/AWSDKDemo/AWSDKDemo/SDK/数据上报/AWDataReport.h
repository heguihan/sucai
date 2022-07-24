//
//  AWDataReport.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWDataReport : NSObject
//从H5过来的埋点上报需要延时
+(void)saveDataDelayReportEvent:(NSDictionary *)event;
//SDK埋点的数据立即上报
+(void)saveSDKDataViewEnent:(NSDictionary *)event;


//需要延时的上报
+(void)saveDataDelayWithEvent:(NSString *)event properties:(NSDictionary *)properties;
//不需要延时的数据上报
+(void)saveEventWittEvent:(NSString *)event properties:(NSDictionary *)properties;
+(void)saveRegisterEventWittEvent:(NSString *)event properties:(NSDictionary *)properties timestamp:(NSString *)timestamp;
+(NSMutableArray *)loadReportData;
+(void)removeAllReportDataWithPath:(NSString *)path;
//上报失败 重新保存回来   没用了
+(void)reSaveDataWithJsonData:(NSArray *)reSaveDataArr withPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
