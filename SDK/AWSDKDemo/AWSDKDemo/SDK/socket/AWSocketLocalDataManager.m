//
//  AWSocketLocalDataManager.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/21.
//

#import "AWSocketLocalDataManager.h"
#import "AWLocalFile.h"


@implementation AWSocketLocalDataManager
+(void)removeDataWithID:(int)msgID
{
    NSDictionary *socketData = [AWLocalFile loadLocalCache:SOCKETDATA];
    NSMutableDictionary *mutabDatadict = [[NSMutableDictionary alloc]initWithDictionary:socketData];
    if (mutabDatadict) {
        [mutabDatadict removeObjectForKey:[NSString stringWithFormat:@"%d",msgID]];
    }
    if ([mutabDatadict count]<1) {
        [AWLocalFile removeDocumentDataAtPath:SOCKETDATA];
    }else{
        [AWLocalFile saveToLocalWithPath:SOCKETDATA withData:[mutabDatadict copy]];
    }
    
}

//删除单条数据
+(void)removeMsg:(int)msgID datadict:(NSDictionary *)socketData
{
    NSMutableDictionary *mutabDatadict = [[NSMutableDictionary alloc]initWithDictionary:socketData];
    if (mutabDatadict) {
        [mutabDatadict removeObjectForKey:[NSString stringWithFormat:@"%d",msgID]];
    }
    if ([mutabDatadict count]<1) {
        [AWLocalFile removeDocumentDataAtPath:SOCKETDATA];
    }else{
        [AWLocalFile saveToLocalWithPath:SOCKETDATA withData:[mutabDatadict copy]];
    }
}

//删除多条条数据
+(void)removeMsgArr:(NSArray *)msgIDarr datadict:(NSDictionary *)socketData
{
    NSMutableDictionary *mutabDatadict = [[NSMutableDictionary alloc]initWithDictionary:socketData];
    for (NSString *msgIDStr in msgIDarr) {
        int msgID = [msgIDStr intValue];
        if (mutabDatadict) {
            [mutabDatadict removeObjectForKey:[NSString stringWithFormat:@"%d",msgID]];
        }
    }
    if ([mutabDatadict count]<1) {
        [AWLocalFile removeDocumentDataAtPath:SOCKETDATA];
    }else{
        [AWLocalFile saveToLocalWithPath:SOCKETDATA withData:[mutabDatadict copy]];
    }
}

@end
