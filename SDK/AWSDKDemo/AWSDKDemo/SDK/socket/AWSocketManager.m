//
//  AWSocketManager.m
//  AWSDKDemo
//
//  Created by admin on 2021/1/18.
//

#import "AWSocketManager.h"
#import "AWSocket.h"

@implementation AWSocketManager
+(void)connectSocketWithHost:(NSString *)host andport:(NSString *)port
{
    if (!host) {
        return;
    }
    if (!port) {
        return;
    }
    int intport = [port intValue];
    [[AWSocket shareInstance]connectWithHost:host andport:intport];
    [[AWGlobalDataManage shareinstance] createHeartBeatsTimer]; //开启心跳包定时器
}

+(void)heartbeat
{
    [[AWSocket shareInstance] heartBeat];
}

+(void)sendToken
{
    NSString *token = [AWUserInfoManager shareinstance].token;
    NSString *userid = [AWUserInfoManager shareinstance].account;
    NSDictionary *dict = @{@"token":token,@"openid":userid};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:&error];
    if (!jsonData) {
        AWLog(@"json解析失败");
        return;
    }
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    AWLog(@"jsonStr==%@",jsonStr);
    [[AWSocket shareInstance] sendDataWithMsg:jsonStr type:201 msgID:999 iszip:YES isfirst:YES];
}
+(void)sendMsg:(NSString *)msg Adntype:(short)type
{
//    100心跳检查
//    201 Token， 需要发Token才能执行后续操作，如果没有Token后续发的消息会关掉。
    //202 进入区服/等级 上报
    //203 广告消息上报
    //204 存用户数据
    //205 读取用户数据
    //206 存游戏数据
    //207 读取游戏数据
//   uint msgid = 3333;
    
//    if (type!=202) {
//        if (![AWSDKConfigManager shareinstance].arder_is_arder){
//            return;
//        }
//    }
    
    NSString *token = [AWUserInfoManager shareinstance].token;
    NSString *userid = [AWUserInfoManager shareinstance].account;
    if (!userid) {
        userid = @"0";
    }
    NSString *appID = [AWConfig CurrentAppID];
    if (!token) {
        token = @"";
    }
    
    NSDictionary *resultDict = @{@"token":token,@"app_id":appID,@"openid":userid,@"data":msg};
    
//    NSMutableDictionary *
    NSString *resultJson = [AWTools dicttojsonWithdict:resultDict];
    int msgid = arc4random() % 1000000;
    if (type == 205) {
        msgid = 10086;
    }else if (type == 207){
        msgid = 10087;
    }
    
    if (type == 208) {
        msgid = 10088;
        resultJson = msg;
    }
    NSLog(@"send msg==%@",resultJson);
    [[AWSocket shareInstance] sendDataWithMsg:resultJson type:type msgID:msgid iszip:YES isfirst:YES];
}
+(void)disConnect
{
    [[AWSocket shareInstance] disConnect];
}

//预留
+(void)resendData
{
    [[AWSocket shareInstance] resendData];
}
@end
