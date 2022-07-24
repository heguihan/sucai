//
//  AWLoginSubListView.h
//  AWSDKDemo
//
//  Created by admin on 2021/11/23.
//

#import "AWBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWLoginSubListView : AWBaseView
+(instancetype)factory_loginSublistWithArr:(NSArray *)arr;
@property(nonatomic,assign)BOOL isFirstView;
@property(nonatomic,strong)NSArray *arr;
-(void)changeSmallFrame;
@end

NS_ASSUME_NONNULL_END
