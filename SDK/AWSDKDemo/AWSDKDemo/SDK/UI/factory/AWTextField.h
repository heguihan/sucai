//
//  AWTextField.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWTextField : UITextField
+(instancetype)factoryBtnWithLeftWidth:(CGFloat)width marginY:(CGFloat)marginY;
+(instancetype)factoryBtnWithLeftWidth:(CGFloat)width AndRightWidth:(CGFloat)rightwidth marginY:(CGFloat)marginY;

@property(nonatomic, strong)UIButton *rightTFSpot;


@end

NS_ASSUME_NONNULL_END
