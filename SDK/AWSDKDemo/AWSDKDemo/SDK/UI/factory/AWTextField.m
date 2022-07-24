//
//  AWTextField.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/2.
//

#import "AWTextField.h"
#import "AWBaseView.h"

@interface AWTextField()<UITextFieldDelegate>

@end

@implementation AWTextField

+(instancetype)factoryBtnWithLeftWidth:(CGFloat)width marginY:(CGFloat)marginY
{
    AWTextField *textfield = [[AWTextField alloc]initWithFrame:CGRectMake(MarginX, marginY, TFWidth, TFHeight)];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 1)];
    leftView.backgroundColor = [UIColor clearColor];
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.returnKeyType = UIReturnKeyDefault;
    
    
    return textfield;
}

+(instancetype)factoryBtnWithLeftWidth:(CGFloat)width AndRightWidth:(CGFloat)rightwidth marginY:(CGFloat)marginY
{
    AWTextField *textfield = [[AWTextField alloc]initWithFrame:CGRectMake(MarginX, marginY, TFWidth, TFHeight)];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 1)];
    leftView.backgroundColor = [UIColor clearColor];
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    rightwidth = rightwidth +10;
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rightwidth, TFHeight)];
    textfield.rightView = rightView;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    textfield.returnKeyType = UIReturnKeyDefault;
    
    return textfield;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TFCOLOR;
        CGFloat height = frame.size.height;
        self.layer.cornerRadius =height/2.0;
        self.layer.masksToBounds = YES;
        self.delegate = [AWBaseView shareInstance];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
//        self.textColor = [UIColor grayColor];
        [self setdefaultColor];
    }
    return self;
}

-(void)setdefaultColor
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: RGBA(210, 210, 210, 1)}];
    self.textColor = RGBA(151, 151, 151, 1);
}

#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    AWLog(@"self did begin edit");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AWLog(@"self did end edit");
}


@end
