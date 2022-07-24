//
//  GGGTextArchiver.h
//  GGGText <https://github.com/ibireme/GGGText>
//
//  Created by ibireme on 15/3/16.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A subclass of `NSKeyedArchiver` which implement `NSKeyedArchiverDelegate` protocol.
 
 The archiver can encode the object which contains
 CGColor/CGImage/CTRunDelegateRef/.. (such as NSAttributedString).
 */
@interface GGGTextArchiver : NSKeyedArchiver <NSKeyedArchiverDelegate>
@end

/**
 A subclass of `NSKeyedUnarchiver` which implement `NSKeyedUnarchiverDelegate` 
 protocol. The unarchiver can decode the data which is encoded by 
 `GGGTextArchiver` or `NSKeyedArchiver`.
 */
@interface GGGTextUnarchiver : NSKeyedUnarchiver <NSKeyedUnarchiverDelegate>
@end

NS_ASSUME_NONNULL_END
