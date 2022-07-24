//
//  HGHUIFrame.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/3/20.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HGHUIFrame : NSObject

+(CGFloat)getViewWIDTH;
+(CGFloat)getViewHEIGTH;
+(CGFloat)getScreenWIDTH;
+(CGFloat)getScreenHEIGHT;
+(CGFloat)getXpoint;
+(CGFloat)getYpoint;
+(CGFloat)adapterHeight:(CGFloat)inputH;
+(CGFloat)adapterWidth:(CGFloat)inputW;
+(CGFloat)alertWidth:(CGFloat)inputW;
+(CGFloat)alertHeight:(CGFloat)inputH;
@end

NS_ASSUME_NONNULL_END
