//
//  AWLoginActiveScreen.h
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "AWScreenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWLoginActiveScreen : UIWindow
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)AWHGHALLButton *closeBtn;
@property(nonatomic, strong)AWScreenModel *screenModel;
@property(nonatomic,strong)NSString *jumpURL;
@property(nonatomic, assign) NSInteger jumpType;
-(void)closeScreen;
@end

NS_ASSUME_NONNULL_END
