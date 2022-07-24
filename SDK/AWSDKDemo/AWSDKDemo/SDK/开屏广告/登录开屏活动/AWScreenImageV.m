//
//  AWScreenImageV.m
//  AWSDKDemo
//
//  Created by admin on 2021/6/15.
//

#import "AWScreenImageV.h"

@implementation AWScreenImageV


-(void)configUIWithScreenModel:(AWScreenModel *)model
{
    self.currentModel = model;
    
    CGFloat width = self.frame.size.width -100;
    CGFloat height = self.frame.size.height - 100;
    

    NSInteger orientation = [AWTools DeviceOrientation]; // 12是横屏  3是竖屏
    
    
    //横屏400  竖屏320
    if (orientation == 3) {
        width = AdaptWidth(320);
        height = width / 1.6;
//        height = AdaptWidth(320);
//        width = height * 1.6;
    }else{
//        height = AdaptWidth(320);
//        width = height * 1.6;
        
        width = AdaptWidth(400);
        height = width / 1.6;
    }
    CGFloat x = (SCREENWIDTH - width)/2.0;
    CGFloat y = (SCREENHEIGHT - height)/2.0;
    CGRect imageFrame = CGRectMake(x, y, width, height);
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:imageFrame];
    [self addSubview:imageV];
    imageV.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.img_normal]]];
    imageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActive)];
    [imageV addGestureRecognizer:tap];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-50, 0, 50, 50)];
    [closeBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/close.png"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor orangeColor];
    [imageV addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickClose
{
    [self removeFromSuperview];
    if (self.currentModel.isLastActive) {
        [AWGlobalDataManage shareinstance].isLastActive = YES;
    }
    self.CloseBlock(!self.num);
}

-(void)tapActive
{
    [AWDataReport saveEventWittEvent:@"app_banner_rank" properties:@{}];
    
    NSString *urlStr =self.currentModel.jump_url;
    [AWGlobalDataManage shareinstance].isClickActive = YES;
    [AWLoginViewManager showUsercenterWithUrl:urlStr];
    if (self.currentModel.isLastActive) {
        [AWGlobalDataManage shareinstance].isLastActive = YES;
    }
    
    [self removeFromSuperview];
    self.CloseBlock(YES);
//    [self closeScreen];
}

@end
