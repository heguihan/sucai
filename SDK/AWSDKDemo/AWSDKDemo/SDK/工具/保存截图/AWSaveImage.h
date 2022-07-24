//
//  AWSaveImage.h
//  AWSDKDemo
//
//  Created by admin on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AWSaveImage : NSObject

//截屏
+(void)saveScreenWithView:(UIView *)view;
+ (void)saveImageToPhotoAlbum:(UIImage*)savedImage;
@end

NS_ASSUME_NONNULL_END
