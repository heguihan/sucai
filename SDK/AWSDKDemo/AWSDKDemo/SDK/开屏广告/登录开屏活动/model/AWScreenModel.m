//
//  AWScreenModel.m
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import "AWScreenModel.h"

@implementation AWScreenModel

-(void)configWithdict:(NSDictionary *)adv andNum:(int)count andTotal:(int)total
{
    self.img_full = adv[@"img_full"];
    self.img_normal = adv[@"img_normal"];
    self.jump_url = adv[@"jump_url"];
    self.schemeurl = adv[@"schemeurl"];
    self.jumpType = 1;
    self.num = count;
    self.total = total;
    self.isLastActive = !(total -count -1);
}
@end
