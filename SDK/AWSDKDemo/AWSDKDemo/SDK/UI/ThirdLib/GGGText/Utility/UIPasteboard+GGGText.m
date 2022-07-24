//
//  UIPasteboard+GGGText.m
//  GGGText <https://github.com/ibireme/GGGText>
//
//  Created by ibireme on 15/4/2.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIPasteboard+GGGText.h"
#import "NSAttributedString+GGGText.h"
#import <MobileCoreServices/MobileCoreServices.h>


#if __has_include("GGGImage.h")
#import "GGGImage.h"
#define GGGTextAnimatedImageAvailable 1
#elif __has_include(<GGGImage/GGGImage.h>)
#import <GGGImage/GGGImage.h>
#define GGGTextAnimatedImageAvailable 1
#elif __has_include(<GGGWebImage/GGGImage.h>)
#import <GGGWebImage/GGGImage.h>
#define GGGTextAnimatedImageAvailable 1
#else
#define GGGTextAnimatedImageAvailable 0
#endif


// Dummy class for category
@interface UIPasteboard_GGGText : NSObject @end
@implementation UIPasteboard_GGGText @end


NSString *const GGGTextPasteboardTypeAttributedString = @"com.ibireme.NSAttributedString";
NSString *const GGGTextUTTypeWEBP = @"com.google.webp";

@implementation UIPasteboard (GGGText)


- (void)setYy_PNGData:(NSData *)PNGData {
    [self setData:PNGData forPasteboardType:(id)kUTTypePNG];
}

- (NSData *)yy_PNGData {
    return [self dataForPasteboardType:(id)kUTTypePNG];
}

- (void)setYy_JPEGData:(NSData *)JPEGData {
    [self setData:JPEGData forPasteboardType:(id)kUTTypeJPEG];
}

- (NSData *)yy_JPEGData {
    return [self dataForPasteboardType:(id)kUTTypeJPEG];
}

- (void)setYy_GIFData:(NSData *)GIFData {
    [self setData:GIFData forPasteboardType:(id)kUTTypeGIF];
}

- (NSData *)yy_GIFData {
    return [self dataForPasteboardType:(id)kUTTypeGIF];
}

- (void)setYy_WEBPData:(NSData *)WEBPData {
    [self setData:WEBPData forPasteboardType:GGGTextUTTypeWEBP];
}

- (NSData *)yy_WEBPData {
    return [self dataForPasteboardType:GGGTextUTTypeWEBP];
}

- (void)setYy_ImageData:(NSData *)imageData {
    [self setData:imageData forPasteboardType:(id)kUTTypeImage];
}

- (NSData *)yy_ImageData {
    return [self dataForPasteboardType:(id)kUTTypeImage];
}

- (void)setYy_AttributedString:(NSAttributedString *)attributedString {
    self.string = [attributedString yy_plainTextForRange:NSMakeRange(0, attributedString.length)];
    NSData *data = [attributedString yy_archiveToData];
    if (data) {
        NSDictionary *item = @{GGGTextPasteboardTypeAttributedString : data};
        [self addItems:@[item]];
    }
    [attributedString enumerateAttribute:GGGTextAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(GGGTextAttachment *attachment, NSRange range, BOOL *stop) {
        
        // save image
        UIImage *simpleImage = nil;
        if ([attachment.content isKindOfClass:[UIImage class]]) {
            simpleImage = attachment.content;
        } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
            simpleImage = ((UIImageView *)attachment.content).image;
        }
        if (simpleImage) {
            NSDictionary *item = @{@"com.apple.uikit.image" : simpleImage};
            [self addItems:@[item]];
        }
        
#if GGGTextAnimatedImageAvailable
        // save animated image
        if ([attachment.content isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = attachment.content;
            Class aniImageClass = NSClassFromString(@"GGGImage");
            UIImage *image = imageView.image;
            if (aniImageClass && [image isKindOfClass:aniImageClass]) {
                NSData *data = [image valueForKey:@"animatedImageData"];
                NSNumber *type = [image valueForKey:@"animatedImageType"];
                if (data) {
                    switch (type.unsignedIntegerValue) {
                        case GGGImageTypeGIF: {
                            NSDictionary *item = @{(id)kUTTypeGIF : data};
                            [self addItems:@[item]];
                        } break;
                        case GGGImageTypePNG: { // APNG
                            NSDictionary *item = @{(id)kUTTypePNG : data};
                            [self addItems:@[item]];
                        } break;
                        case GGGImageTypeWebP: {
                            NSDictionary *item = @{(id)GGGTextUTTypeWEBP : data};
                            [self addItems:@[item]];
                        } break;
                        default: break;
                    }
                }
            }
        }
#endif
        
    }];
}

- (NSAttributedString *)yy_AttributedString {
    for (NSDictionary *items in self.items) {
        NSData *data = items[GGGTextPasteboardTypeAttributedString];
        if (data) {
            return [NSAttributedString yy_unarchiveFromData:data];
        }
    }
    return nil;
}

@end
