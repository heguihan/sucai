//
//  AWLoginActiveScreen.m
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import "AWLoginActiveScreen.h"

@implementation AWLoginActiveScreen

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.windowLevel = 30000;
        self.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAd)];
//        [self addGestureRecognizer:tap];
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.backgroundColor = [UIColor clearColor];
}

@end
