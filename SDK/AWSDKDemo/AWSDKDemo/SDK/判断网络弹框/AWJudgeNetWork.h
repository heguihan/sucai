//
//  AWJudgeNetWork.h
//  AWSDKDemo
//
//  Created by admin on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWJudgeNetWork : NSObject
+(instancetype)shareInstance;
-(void)noNetNetWork;  //无网络
-(void)getNetWork;      //有网络
@end

NS_ASSUME_NONNULL_END
