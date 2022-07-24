//
//  HGHEmailBand.h
//  haiwaiSDK
//
//  Created by Lucas on 2019/4/18.
//  Copyright © 2019 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHEmailBand : NSObject
@property(nonatomic,strong)UIImageView *imageView;
+(instancetype)shareInstance;
-(void)emailBand;
@end

NS_ASSUME_NONNULL_END
