//
//  GGGTextSelectionView.h
//  GGGText <https://github.com/ibireme/GGGText>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<GGGText/GGGText.h>)
#import <GGGText/GGGTextAttribute.h>
#import <GGGText/GGGTextInput.h>
#else
#import "GGGTextAttribute.h"
#import "GGGTextInput.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A single dot view. The frame should be foursquare.
 Change the background color for display.
 
 @discussion Typically, you should not use this class directly.
 */
@interface GGGSelectionGrabberDot : UIView
/// Dont't access this property. It was used by `GGGTextEffectWindow`.
@property (nonatomic, strong) UIView *mirror;
@end


/**
 A grabber (stick with a dot).
 
 @discussion Typically, you should not use this class directly.
 */
@interface GGGSelectionGrabber : UIView

@property (nonatomic, readonly) GGGSelectionGrabberDot *dot; ///< the dot view
@property (nonatomic) GGGTextDirection dotDirection;         ///< don't support composite direction
@property (nullable, nonatomic, strong) UIColor *color;     ///< tint color, default is nil

@end


/**
 The selection view for text edit and select.
 
 @discussion Typically, you should not use this class directly.
 */
@interface GGGTextSelectionView : UIView

@property (nullable, nonatomic, weak) UIView *hostView; ///< the holder view
@property (nullable, nonatomic, strong) UIColor *color; ///< the tint color
@property (nonatomic, getter = isCaretBlinks) BOOL caretBlinks; ///< whether the caret is blinks
@property (nonatomic, getter = isCaretVisible) BOOL caretVisible; ///< whether the caret is visible
@property (nonatomic, getter = isVerticalForm) BOOL verticalForm; ///< weather the text view is vertical form

@property (nonatomic) CGRect caretRect; ///< caret rect (width==0 or height==0)
@property (nullable, nonatomic, copy) NSArray<GGGTextSelectionRect *> *selectionRects; ///< default is nil

@property (nonatomic, readonly) UIView *caretView;
@property (nonatomic, readonly) GGGSelectionGrabber *startGrabber;
@property (nonatomic, readonly) GGGSelectionGrabber *endGrabber;

- (BOOL)isGrabberContainsPoint:(CGPoint)point;
- (BOOL)isStartGrabberContainsPoint:(CGPoint)point;
- (BOOL)isEndGrabberContainsPoint:(CGPoint)point;
- (BOOL)isCaretContainsPoint:(CGPoint)point;
- (BOOL)isSelectionRectsContainsPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
