//
//  AWWholeView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/3.
//

#import "AWWholeView.h"


@implementation AWWholeView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AWLog(@"wholeview toches");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    
}


@end
