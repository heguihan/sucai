//
//  NSObject+orderAW.m
//  testScene
//
//  Created by admin on 2021/5/11.
//

#import "NSObject+orderAW.h"
#import <objc/runtime.h>

@implementation NSObject (orderAW)
static void * RayliStr;

-(void)setAworder:(NSString *)aworder
{
    objc_setAssociatedObject(self, &RayliStr, aworder, OBJC_ASSOCIATION_COPY);
}

-(NSString *)aworder
{
    return objc_getAssociatedObject(self, &RayliStr);
}
@end
