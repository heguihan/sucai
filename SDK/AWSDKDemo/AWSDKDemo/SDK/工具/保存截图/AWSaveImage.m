//
//  AWSaveImage.m
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import "AWSaveImage.h"
#import <Photos/Photos.h>

@implementation AWSaveImage


//截屏
+(void)saveScreenWithView:(UIView *)view
{
    
    
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        } else {
            UIGraphicsBeginImageContext(view.bounds.size);
        }
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
          
        UIGraphicsEndImageContext();
    [self saveImageToPhotoAlbum:image];

}
#pragma mark - 保存至相册
+ (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//指定回调方法
+ (void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (image == nil) {
        return;
    }
    NSString *msg = @"保存图片成功";
    if(error != NULL){
        msg = @"保存图片失败" ;
    }
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    AWLog(@"openGallery_authorStatus == %ld",(long)authorStatus); //PHAuthorizationStatusAuthorized

    AWLog(@"🌹🌹🌹🌹%@",msg);
}

-(void)settingClick
{
    [self gotoSetting];
}

-(void)gotoSetting
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
