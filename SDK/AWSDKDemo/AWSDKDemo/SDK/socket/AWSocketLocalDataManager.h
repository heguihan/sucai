//
//  AWSocketLocalDataManager.h
//  AWSDKDemo
//
//  Created by admin on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWSocketLocalDataManager : NSObject
+(void)removeDataWithID:(int)msgID;
+(void)removeMsg:(int)msgID datadict:(NSDictionary *)socketData;
//删除多条条数据
+(void)removeMsgArr:(NSArray *)msgIDarr datadict:(NSDictionary *)socketData;
@end

NS_ASSUME_NONNULL_END
