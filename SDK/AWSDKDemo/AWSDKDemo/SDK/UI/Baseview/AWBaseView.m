//
//  AWBaseView.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWBaseView.h"

@implementation AWBaseView


+(instancetype)shareInstance
{
    static AWBaseView *baseview = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseview = [[AWBaseView alloc]init];
    });
    return baseview;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 19;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AWLog(@"touches");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)show
{
    [MAINVIEW addSubview:self];
}


//这里针对idfa的引导界面做处理， 后续再看其他view
-(void)showNotCloseView
{
    [[AWViewManager shareInstance].notCloseView addSubview:self];
}

-(void)closeNotCloseView
{
    [AWTools removeViews:[AWViewManager shareInstance].notCloseView];
}

-(void)gobackFromSelfView
{
    if (self.superview.subviews.count<=1) {
        [self closeAllView];
        return;
    }
    [AWTools removeViews:self];
}

-(void)closeAllView
{
    [AWGlobalDataManage shareinstance].isShowingFourceRealName = NO;
    [AWTools removeViews:WHOLEVIEW];
}

#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    AWLog(@"did begin edit");
    CGRect frame = textField.frame;
    CGFloat offset = frame.origin.y + TFHeight - (SCREENHEIGHT - 256.0);//键盘高度216
     
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    AWLog(@"offset=%f",offset);
//    AWLog(@"futherview=%@",textField.superview);
//
//    CGRect selfFrame = textField.superview.frame;
//    if(offset > 0){
//        textField.tag = 888000+offset;
//        selfFrame.origin.y -= offset;
//        textField.superview.frame = selfFrame;
//    }
//    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selfFrame = textField.superview.frame;
        if(offset > 0){
            textField.tag = 888000+offset;
            selfFrame.origin.y -= offset;
            textField.superview.frame = selfFrame;
        }
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AWLog(@"textField tag=%ld",(long)textField.tag);
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    CGFloat offset = textField.tag % 1000;
//    if (textField.tag/1000 == 888) {
//        CGRect superFrame = textField.superview.frame;
//        superFrame.origin.y += offset;
//        textField.superview.frame = superFrame;
//        textField.tag = 0;
//        [UIView commitAnimations];
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat offset = textField.tag % 1000;
        if (textField.tag/1000 == 888) {
            CGRect superFrame = textField.superview.frame;
            superFrame.origin.y += offset;
            textField.superview.frame = superFrame;
            textField.tag = 0;
            [UIView commitAnimations];
        }
    }];
    
    AWLog(@"did end edit");
}
@end
