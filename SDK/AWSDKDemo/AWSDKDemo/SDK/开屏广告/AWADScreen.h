//
//  AWADScreen.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWADScreen : UIWindow
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)AWHGHALLButton *jumpBtn;
@property(nonatomic,strong)NSString *jimURL;
@property(nonatomic,strong)NSString *scheme;
@property(nonatomic, assign) NSInteger jumpType;
-(void)destoryTimer;
-(void)closeScreen;
@end

NS_ASSUME_NONNULL_END
