//
//  AWWebview.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWWebview : UIView
@property(nonatomic,strong)NSString *urlStr;
-(void)reloadwebview;

-(void)reSizeWebView;

@end

NS_ASSUME_NONNULL_END
