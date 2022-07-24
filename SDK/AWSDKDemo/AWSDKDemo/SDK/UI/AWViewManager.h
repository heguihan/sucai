//
//  AWViewManager.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import "AWMainView.h"
#import "AWWholeView.h"
#import "AWWebBackView.h"
#import "AWNotCloseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AWViewManager : NSObject
+(instancetype)shareInstance;
@property(nonatomic,strong)AWMainView *mainView;
@property(nonatomic, strong)AWWholeView *wholeView;
@property(nonatomic, strong)AWNotCloseView *notCloseView;
@property(nonatomic, strong)AWWebBackView *webbackView;
@property(nonatomic, strong)UIView *protoclFutherview; //隐私协议的父视图
@property(nonatomic, strong)UIView *protoclAgreeFutherView; //启动授权弹同意是否授权

@property(nonatomic, assign)BOOL iswebviewShow;   //webview是否打开 控制悬浮球的隐藏和显示
@property(nonatomic, strong)UIView *adView;
-(void)showAdLabWithArr:(NSArray *)titleArr;
-(void)CloseBrotcast; //关闭滚动消息
-(void)showredEnvelopeViewWithTitle:(NSDictionary *)title; //显示领取红包消息
-(void)clickCloseRedNevelope; //关闭红包领取消息
@end

NS_ASSUME_NONNULL_END
