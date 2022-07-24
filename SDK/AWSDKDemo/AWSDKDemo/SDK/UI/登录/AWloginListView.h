//
//  AWloginV.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWloginListView : AWBaseView
+(instancetype)factory_loginlistWithArr:(NSArray *)arr;
@property(nonatomic,assign)BOOL isFirstView;
@property(nonatomic,strong)NSArray *arr;
-(void)changeSmallFrame;
@end

NS_ASSUME_NONNULL_END
