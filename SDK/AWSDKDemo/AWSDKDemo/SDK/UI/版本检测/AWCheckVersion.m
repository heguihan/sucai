//
//  AWCheckVersion.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/17.
//

#import "AWCheckVersion.h"

@interface AWCheckVersion()
@property(nonatomic, strong)NSString *updateUrl;

@end

@implementation AWCheckVersion

+(instancetype)factory_checkversionWithUpdateType:(NSDictionary *)updateInfo
{
    AWCheckVersion *checkVersion = [[AWCheckVersion alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, SmallViewHeight)];
    [checkVersion configUIWithUpdateType:updateInfo];
    return checkVersion;
}

-(void)configUIWithUpdateType:(NSDictionary *)updateInfo
{
    
    [AWDataReport saveEventWittEvent:@"app_update_show" properties:@{}];
    [AWGlobalDataManage shareinstance].isShowingUpdate = YES;
//    self.backgroundColor = [UIColor blueColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(31), TFWidth, 20)];
    titleLab.font = FONTSIZE(18);
    titleLab.textColor = TEXTBLACKCOLOR;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [NSString stringWithFormat:@"发现新版本:v%@",updateInfo[@"version_name"]];

    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(MarginX, AdaptWidth(67), ViewWidth-MarginX*2, AdaptWidth(100))];
    [textView setEditable:NO];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
     
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc]initWithString:updateInfo[@"update_info"] attributes:attributes];
    
    self.updateUrl = updateInfo[@"update_url"];
    CGFloat btnY = AdaptWidth(167);
    CGFloat smallBtnwidth = AdaptWidth(130);
    [self addSubview:titleLab];
    [self addSubview:textView];
    if ([updateInfo[@"update_type"] intValue]==1) {
        //不强更
        //提示的时间间隔
        

        
        AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(ViewWidth/2.0-smallBtnwidth-16, btnY, smallBtnwidth, TFHeight)];
//        AWHGHALLButton *cancelBtn = [[AWHGHALLButton alloc]initWithFrame:CGRectMake(50, btnY, smallBtnwidth, TFHeight)];
        AWOrangeBtn *updateBtn = [[AWOrangeBtn alloc]initWithFrame:CGRectMake(ViewWidth/2.0+16, btnY, smallBtnwidth, TFHeight)];
        cancelBtn.layer.cornerRadius = TFHeight/2.0;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = RGBA(237, 237, 237, 1);
//        cancelBtn.backgroundColor = [UIColor redColor];
        [cancelBtn setTitle:@"暂不更新" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
        
        [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [updateBtn addTarget:self action:@selector(clickUpdate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        [self addSubview:updateBtn];
        
    }else{
        //强更
        AWOrangeBtn *forcedUpdateBtn = [AWOrangeBtn factoryBtnWithTitle:@"立即更新" marginY:btnY];
        [self addSubview:forcedUpdateBtn];
        [forcedUpdateBtn addTarget:self action:@selector(clickUpdate) forControlEvents:UIControlEventTouchUpInside];
    }
    

//    [self addSubview:againBtn];
}

-(void)clickCancel
{
    [AWGlobalDataManage shareinstance].isShowingUpdate = NO;
    dispatch_semaphore_signal([AWGlobalDataManage shareinstance].notice_semaphore);
    
    [AWDataReport saveEventWittEvent:@"app_update_cancel" properties:@{}];
    [AWGlobalDataManage shareinstance].isShowingUpdate = NO;
    [self closeAllView];  //发通知 继续下面的操作
    [AWGlobalDataManage shareinstance].isCheckVersionSignal = YES;
    [AWLoginViewManager loginCheck];
}

-(void)clickUpdate
{
    [AWDataReport saveEventWittEvent:@"app_update_start" properties:@{}];
//    [self closeAllView];
    AWLog(@"update");
    AWLog(@"url===%@",self.updateUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                //
            }
    }];
    // 不发通知
}

@end
