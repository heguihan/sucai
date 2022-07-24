//
//  AWBaseView.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWBaseView : UIView<UITextFieldDelegate>
+(instancetype)shareInstance;
-(void)show;
-(void)gobackFromSelfView;
-(void)closeAllView;
-(void)showNotCloseView; //指定的几个view 其他视图关闭时  不影响这个view
-(void)closeNotCloseView; //和上面显示的对应
@end

NS_ASSUME_NONNULL_END
