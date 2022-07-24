//
//  HGHUIFrame.m
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import "HGHUIFrame.h"
#import "HGHTools.h"
@implementation HGHUIFrame

+(CGFloat)getViewWIDTH
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (SCREEN_IS_LANDSCAPE||BPDevice_is_ipad) {
        return 420;
    }
    return screenWidth-20;
}

+(CGFloat)getViewHEIGTH
{
//    return 262;
    return 310;
}

+(CGFloat)getScreenWIDTH
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat)getScreenHEIGHT
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(CGFloat)getXpoint
{
    return ([HGHUIFrame getScreenWIDTH]-[HGHUIFrame getViewWIDTH])/2;
}

+(CGFloat)getYpoint
{
    return ([HGHUIFrame getScreenHEIGHT]-[HGHUIFrame getViewHEIGTH])/2;
}

+(CGFloat)adapterHeight:(CGFloat)inputH
{
    return 310 * inputH/372;
}

+(CGFloat)adapterWidth:(CGFloat)inputW
{
    return 420 * inputW/477;
}


+(CGFloat)alertWidth:(CGFloat)inputW
{
    return inputW *SCREENWIDTH/810;
}

//+(CGFloat)alertWidth:(CGFloat)inputW
+ (CGFloat)alertHeight:(CGFloat)inputH
{
    return inputH * SCREENHEIGHT/486;
}
@end
