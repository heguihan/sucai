//
//  AWScreenModel.h
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWScreenModel : NSObject
@property(nonatomic,strong)NSString *img_normal;
@property(nonatomic,strong)NSString *img_full;
@property(nonatomic,strong)NSString *jump_url;
@property(nonatomic,strong)NSString *schemeurl;
@property(nonatomic, assign) NSInteger jumpType;  //0是启动开屏   1是登录 充值榜单开屏
@property(nonatomic, assign) int num;
@property(nonatomic, assign) int total;
@property(nonatomic,assign)BOOL isLastActive;

-(void)configWithdict:(NSDictionary *)adv andNum:(int)count andTotal:(int)total;
@end

NS_ASSUME_NONNULL_END
