//
//  AWLoginActiveManager.h
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import <Foundation/Foundation.h>
#import "AWScreenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWLoginActiveManager : NSObject
@property(nonatomic,strong)NSArray *ScreenModelArr;

+(instancetype)shareInstance;

-(void)showLoginActive;


@end

NS_ASSUME_NONNULL_END
