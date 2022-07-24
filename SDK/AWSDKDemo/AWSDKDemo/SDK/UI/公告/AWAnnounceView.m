//
//  AWAnnounceView.m
//  AWSDKDemo
//
//  Created by admin on 2021/9/26.
//

#import "AWAnnounceView.h"

@implementation AWAnnounceView


static BOOL _notNoticeAgain = NO;
static NSString *_jumpUrl = @"";
static NSString *_freq = @"";   //显示频率 当前（EVERY_TIME    ONCE_PER_DAY）

+(instancetype)factory_AnnounceViewWithTitle:(NSString *)title andContent:(NSString *)content isCloseServer:(int)isCloseServer btnText:(NSString *)btnStr urlstr:(NSString *)urlStr freq:(NSString *)freq
{
    AWAnnounceView *announceView = [[AWAnnounceView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    _freq = freq;
    [announceView configUIWithTitle:title content:content isClose:isCloseServer btnText:btnStr urlstr:urlStr];
    return announceView;
}

-(void)configUIWithTitle:(NSString *)title content:(NSString *)content isClose:(int)isCloseServer btnText:(NSString *)btnStr urlstr:(NSString *)urlStr
{
    [self addContentWithContent:content];
    [self addHeadAndBottomWithTitle:title isClose:isCloseServer btnText:btnStr urlstr:urlStr];
}

-(void)addContentWithContent:(NSString *)content
{
    UITextView *contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, AdaptWidth(40), ViewWidth, 170)];
    contentTextView.text = content;
    contentTextView.font = FONTSIZE(15);
    contentTextView.textColor = RGBA(89, 81, 86, 1);
    [self addSubview:contentTextView];
}

-(void)addHeadAndBottomWithTitle:(NSString *)title isClose:(int)isCloseServer btnText:(NSString *)btnStr urlstr:(NSString *)urlStr
{
    _jumpUrl = urlStr;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40)];
    titleLab.backgroundColor = RGBA(242, 242, 242, 1);
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    NSString *btnTitle = @"知道了";
    if (isCloseServer) {
        btnTitle = @"退出游戏";
    }
    if (btnStr && btnStr.length >0) {
        btnTitle = btnStr;
    }
    
    
    AWOrangeBtn *confirmBtn = [AWOrangeBtn factoryBtnWithTitle:btnTitle marginY:AdaptWidth(220)];
    confirmBtn.awTag = isCloseServer;
    [confirmBtn addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    AWHGHALLButton *checkBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(250), 15, 15)];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_is_select.png"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"AWSDK.bundle/aw_icon_not_select.png"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *notNoticeLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX+20, AdaptWidth(250), 200, 15)];
    notNoticeLab.text = @"今日不再提示";
    notNoticeLab.textAlignment = NSTextAlignmentLeft;
    notNoticeLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    notNoticeLab.textColor = RGBA(71, 143, 247, 1);
    
    
    
    [self addSubview:titleLab];
    [self addSubview:confirmBtn];
    
    //普通公告 且 每次显示才会有
    if ([_freq isEqualToString:@"EVERY_TIME"] && isCloseServer == 0) {
        [self addSubview:checkBtn];
        [self addSubview:notNoticeLab];
    }

    
}

-(void)clickConfirm:(AWOrangeBtn *)sender
{
    if (sender.awTag == 1) {
        //退出游戏
        [AWTools leaveGame];
        return;
    }
    if (sender.awTag == 0) {
        //
        //先看复选框是否提醒
        BOOL isOnceDay = [_freq isEqualToString:@"ONCE_PER_DAY"];
        if (_notNoticeAgain || isOnceDay) {
            [AWTools saveCurrentTimeWithPath:LOCALNOTICETIMESTR];
        }
        [self gobackFromSelfView];
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        return;
    }

    if (sender.awTag == 2) {
        //
        //先看复选框是否提醒
//        BOOL isOnceDay = [_freq isEqualToString:@"ONCE_PER_DAY"];
//        if (_notNoticeAgain || isOnceDay) {
//            [AWTools saveCurrentTimeWithPath:LOCALNOTICETIMESTR];
//        }
        [self gobackFromSelfView];
        
        
        [AWDataReport saveEventWittEvent:@"app_banner_notice" properties:@{}];
        NSString *urlStr = _jumpUrl;
        [AWGlobalDataManage shareinstance].isClickActive = NO;
        [AWLoginViewManager showUsercenterWithUrl:urlStr];
        
        dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
        return;
    }
//    //先看复选框是否提醒
//    if (_notNoticeAgain) {
//        [AWTools saveCurrentTimeWithPath:LOCALNOTICETIMESTR];
//    }
//    [self gobackFromSelfView];
//    dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);


//    [self closeAllView];
    
}

-(void)clickCheck:(UIButton *)sender
{
    _notNoticeAgain = sender.selected;
    sender.selected = !sender.selected;
}

@end
