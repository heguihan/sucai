//
//  AWBindWechat.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/23.
//

#import "AWBindWechat.h"

@implementation AWBindWechat
+(void)bindWeiChat
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindWebintoaw:) name:NOTIFICATIONWEIXINBIND object:nil];
}



@end
