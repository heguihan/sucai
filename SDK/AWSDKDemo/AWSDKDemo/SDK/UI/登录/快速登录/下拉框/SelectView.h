//
//  SelectView.h
//  testFunction
//
//  Created by admin on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SelectView;
@protocol SelectViewDelegate <NSObject>

-(void)didSelectWithIndex:(NSInteger)index selectedDic:(NSDictionary *)userinfo;

@end

@interface SelectView : UIView
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,weak)id <SelectViewDelegate>delegate;
+(instancetype)factory_SelectviewWithFrame:(CGRect)frame;
-(void)show;
-(void)hidden;
@end

NS_ASSUME_NONNULL_END
