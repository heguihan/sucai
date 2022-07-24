//
//  AWUserInfoManager.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/8.
//

#import "AWUserInfoManager.h"
#import "AWConfig.h"

@implementation AWUserInfoManager
+(instancetype)shareinstance
{
    static AWUserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AWUserInfoManager alloc]init];
    });
    return manager;
}

-(void)setUserinfoWithData:(NSDictionary *)userinfo
{
    self.account = userinfo[@"account"];
    self.alias = userinfo[@"alias"];
    self.is_bind_mobile = [userinfo[@"is_bind_mobile"] intValue];
    self.is_cert = [userinfo[@"is_cert"] intValue];
    self.is_adult = [userinfo[@"is_adult"] intValue];
    self.mobile = userinfo[@"mobile"];
    self.ne_game_user_regtime = userinfo[@"new_game_user_regtime"];
    self.new_game_user = [userinfo[@"new_game_user"] intValue];
    self.new_user = [userinfo[@"new_user"] intValue];
    self.nick_name = userinfo[@"nick_name"];
    self.pwd = userinfo[@"pwd"];
    self.show_account = userinfo[@"show_account"];
    self.token = userinfo[@"token"];
    self.type = userinfo[@"type"];
    self.LoginStatus = [userinfo[@"loginstatus"] intValue];
    self.open_id = [userinfo objectForKey:@"open_id"];
    self.online_time = [userinfo[@"online_time"] integerValue];
    self.sex = [userinfo[@"sex"] intValue];
    self.age = [userinfo[@"age"] intValue];
    self.bind_phone = userinfo[@"bind_phone"];
    self.union_id = userinfo[@"union_id"];
}

-(void)updateUserInfoWithData:(NSDictionary *)userinfo
{
    [self setValuesForKeysWithDictionary:userinfo];
}

//冗错处理，如果有未定义的字段的话就会走到这里，不重写的话会引起崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:%@,undefineKey:%@",value,key);
}

-(BOOL)LoginStatus
{
    NSDictionary *loginInfo = [AWConfig loadUserinfoFromLocal];
    if ([loginInfo.allKeys containsObject:@"loginstatus"]) {
        BOOL loginstatus = [loginInfo[@"loginstatus"] intValue];
        return loginstatus;
    }
    return NO;
}
@end
