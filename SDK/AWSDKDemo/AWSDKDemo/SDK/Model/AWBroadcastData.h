//
//  AWBroadcastData.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWBroadcastData : NSObject
+(instancetype)shareinstance;
@property(nonatomic,strong)NSArray *broadList;
-(void)setbroadlistdataWithArr:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
