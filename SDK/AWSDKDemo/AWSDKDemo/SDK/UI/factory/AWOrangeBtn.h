//
//  AWOrangeBtn.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWOrangeBtn : UIButton
@property(nonatomic, assign) NSInteger awTag;
+(instancetype)factoryBtnWithTitle:(NSString *)title marginY:(CGFloat)marginY;

@end

NS_ASSUME_NONNULL_END
