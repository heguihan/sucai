//
//  AWHGHALLButton.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/17.
//

#import "AWHGHALLButton.h"

@implementation AWHGHALLButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 获取bounds 实际大小
     CGRect bounds = self.bounds;
     // 若热区小于 44 * 44 则放大热区 否则保持原大小不变
    if (bounds.size.height<40 || bounds.size.width<40) {
        CGFloat widthDelta = MAX(60.f - bounds.size.width, 0.f);
        CGFloat heightDelta = MAX(60.f - bounds.size.height, 0.f);
        // 扩大bounds
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
        AWLog(@"xxxx");
    }

     // 点击的点在新的bounds 中 就会返回YES
     return CGRectContainsPoint(bounds, point);
}
@end
