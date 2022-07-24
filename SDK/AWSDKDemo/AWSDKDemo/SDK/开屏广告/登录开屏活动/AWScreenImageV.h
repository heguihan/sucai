//
//  AWScreenImageV.h
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "AWScreenModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface AWScreenImageV : UIView
@property(nonatomic, assign)int num;
@property(nonatomic, copy)void(^CloseBlock)(BOOL isLast);
@property(nonatomic, strong)AWScreenModel *currentModel;

-(void)configUIWithScreenModel:(AWScreenModel *)model;
@end

NS_ASSUME_NONNULL_END
