//
//  AWUserInfoManager.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUserInfoManager : NSObject
+(instancetype)shareinstance;
@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)NSString *alias;
@property(nonatomic,assign)BOOL is_bind_mobile;
@property(nonatomic,assign)BOOL is_cert;
@property(nonatomic,assign)BOOL is_adult;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,assign)BOOL new_game_user;
@property(nonatomic,assign)BOOL new_user;
@property(nonatomic,strong)NSString *ne_game_user_regtime;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic, assign) NSInteger online_time;
@property(nonatomic,strong)NSString *open_id;
@property(nonatomic,strong)NSString *pwd;
@property(nonatomic,strong)NSString *show_account;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)BOOL LoginStatus;
@property(nonatomic,assign)int sex;    //0未知  1男  2女
@property(nonatomic,assign)int age;
@property(nonatomic,strong)NSString *bind_phone;
@property(nonatomic,strong)NSString *union_id;


-(void)setUserinfoWithData:(NSDictionary *)userinfo;
-(void)updateUserInfoWithData:(NSDictionary *)userinfo;
@end

NS_ASSUME_NONNULL_END
