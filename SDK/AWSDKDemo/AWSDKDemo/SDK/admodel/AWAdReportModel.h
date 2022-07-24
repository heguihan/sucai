//
//  AWAdReportModel.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWAdReportModel : NSObject
@property(nonatomic,strong)NSString *ad_id;
@property(nonatomic,assign)NSInteger ad_type; // 广告类型（0-激励视频 / 1-banner广告 / 2-插屏广告）
@property(nonatomic,strong)NSString *ad_platform;   //广告平台  "open_ad_sdk"-穿山甲 / "GDT"-广点通(优量汇) / "KS"-快手 / "SIGMOB"-sigmob
@property(nonatomic,assign)NSInteger status;        //查看状态 0-未看完   1-看完
@property(nonatomic,strong)NSString *ad_place;      //广告展示位置  
//下面为非必传
@property(nonatomic,assign)NSInteger ad_time;       //广告时长（秒）
@property(nonatomic,strong)NSString *action_type;   //动作类型 show-广告展示  click-广告点击
@property(nonatomic,strong)NSString *ad_data;       //附加数据

@end

NS_ASSUME_NONNULL_END
