//
//  AWRoleInfoModel.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWRoleInfoModel : NSObject
//注：单机类游戏接入  非单机游戏数据由服务端上报
@property(nonatomic,strong)NSString *reportType;        //上报类型（（"entersvr"‐进入游戏上报 / "levelup"‐升级闯关上报）
@property(nonatomic,strong)NSString *nickName;          //角色名
@property(nonatomic,assign)NSInteger level;             //当前关卡
@property(nonatomic,strong)NSString *serverId;          //区服ID
@property(nonatomic,strong)NSString *roleId;            //角色ID
@property(nonatomic,strong)NSString *time;              //当前时间
@property(nonatomic,strong)NSString *regTime;    //创建角色时间，没有的话传当前时间
@property(nonatomic, strong)NSDictionary *ext;          //扩展字段
@end

NS_ASSUME_NONNULL_END
