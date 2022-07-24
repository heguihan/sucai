//
//  GGGText.h
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
FOUNDATION_EXPORT double GGGTextVersionNumber;
FOUNDATION_EXPORT const unsigned char GGGTextVersionString[];
#import <GGGText/GGGLabel.h>
#import <GGGText/GGGTextView.h>
#import <GGGText/GGGTextAttribute.h>
#import <GGGText/GGGTextArchiver.h>
#import <GGGText/GGGTextParser.h>
#import <GGGText/GGGTextRunDelegate.h>
#import <GGGText/GGGTextRubyAnnotation.h>
#import <GGGText/GGGTextLayout.h>
#import <GGGText/GGGTextLine.h>
#import <GGGText/GGGTextInput.h>
#import <GGGText/GGGTextDebugOption.h>
#import <GGGText/GGGTextKeyboardManager.h>
#import <GGGText/GGGTextUtilities.h>
#import <GGGText/NSAttributedString+GGGText.h>
#import <GGGText/NSParagraphStyle+GGGText.h>
#import <GGGText/UIPasteboard+GGGText.h>
#else
#import "GGGLabel.h"
#import "GGGTextView.h"
#import "GGGTextAttribute.h"
#import "GGGTextArchiver.h"
#import "GGGTextParser.h"
#import "GGGTextRunDelegate.h"
#import "GGGTextRubyAnnotation.h"
#import "GGGTextLayout.h"
#import "GGGTextLine.h"
#import "GGGTextInput.h"
#import "GGGTextDebugOption.h"
#import "GGGTextKeyboardManager.h"
#import "GGGTextUtilities.h"
#import "NSAttributedString+GGGText.h"
#import "NSParagraphStyle+GGGText.h"
#import "UIPasteboard+GGGText.h"
#endif
