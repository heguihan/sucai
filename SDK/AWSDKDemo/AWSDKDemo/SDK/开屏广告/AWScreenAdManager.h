//
//  AWScreenAdManager.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/16.
//

#import <Foundation/Foundation.h>
#import "AWADScreen.h"
#import "AWScreenModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AWScreenAdManager : NSObject
@property(nonatomic, strong)AWADScreen *adScreenView;
/*方案：传model数组进来 再进行判断*/
@property(nonatomic,strong)NSArray *ScreenModelArr;

@property(nonatomic,strong)NSString *img_normal;
@property(nonatomic,strong)NSString *img_full;
@property(nonatomic,strong)NSString *jump_url;
@property(nonatomic,strong)NSString *schemeurl;
@property(nonatomic, assign) NSInteger jumpType;  //0是启动开屏   1是登录 充值榜单开屏
+(instancetype)shareInstance;

-(void)showAdScreen;
@end

NS_ASSUME_NONNULL_END
