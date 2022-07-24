//
//  GGGTextAttribute.m
//  GGGText <https://github.com/ibireme/GGGText>
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "GGGTextAttribute.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+GGGText.h"
#import "GGGTextArchiver.h"


static double _GGGDeviceSystemVersion() {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}


NSString *const GGGTextBackedStringAttributeName = @"GGGTextBackedString";
NSString *const GGGTextBindingAttributeName = @"GGGTextBinding";
NSString *const GGGTextShadowAttributeName = @"GGGTextShadow";
NSString *const GGGTextInnerShadowAttributeName = @"GGGTextInnerShadow";
NSString *const GGGTextUnderlineAttributeName = @"GGGTextUnderline";
NSString *const GGGTextStrikethroughAttributeName = @"GGGTextStrikethrough";
NSString *const GGGTextBorderAttributeName = @"GGGTextBorder";
NSString *const GGGTextBackgroundBorderAttributeName = @"GGGTextBackgroundBorder";
NSString *const GGGTextBlockBorderAttributeName = @"GGGTextBlockBorder";
NSString *const GGGTextAttachmentAttributeName = @"GGGTextAttachment";
NSString *const GGGTextHighlightAttributeName = @"GGGTextHighlight";
NSString *const GGGTextGlyphTransformAttributeName = @"GGGTextGlyphTransform";

NSString *const GGGTextAttachmentToken = @"\uFFFC";
NSString *const GGGTextTruncationToken = @"\u2026";


GGGTextAttributeType GGGTextAttributeGetType(NSString *name){
    if (name.length == 0) return GGGTextAttributeTypeNone;
    
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary new];
        NSNumber *All = @(GGGTextAttributeTypeUIKit | GGGTextAttributeTypeCoreText | GGGTextAttributeTypeGGGText);
        NSNumber *CoreText_GGGText = @(GGGTextAttributeTypeCoreText | GGGTextAttributeTypeGGGText);
        NSNumber *UIKit_GGGText = @(GGGTextAttributeTypeUIKit | GGGTextAttributeTypeGGGText);
        NSNumber *UIKit_CoreText = @(GGGTextAttributeTypeUIKit | GGGTextAttributeTypeCoreText);
        NSNumber *UIKit = @(GGGTextAttributeTypeUIKit);
        NSNumber *CoreText = @(GGGTextAttributeTypeCoreText);
        NSNumber *GGGText = @(GGGTextAttributeTypeGGGText);
        
        dic[NSFontAttributeName] = All;
        dic[NSKernAttributeName] = All;
        dic[NSForegroundColorAttributeName] = UIKit;
        dic[(id)kCTForegroundColorAttributeName] = CoreText;
        dic[(id)kCTForegroundColorFromContextAttributeName] = CoreText;
        dic[NSBackgroundColorAttributeName] = UIKit;
        dic[NSStrokeWidthAttributeName] = All;
        dic[NSStrokeColorAttributeName] = UIKit;
        dic[(id)kCTStrokeColorAttributeName] = CoreText_GGGText;
        dic[NSShadowAttributeName] = UIKit_GGGText;
        dic[NSStrikethroughStyleAttributeName] = UIKit;
        dic[NSUnderlineStyleAttributeName] = UIKit_CoreText;
        dic[(id)kCTUnderlineColorAttributeName] = CoreText;
        dic[NSLigatureAttributeName] = All;
        dic[(id)kCTSuperscriptAttributeName] = UIKit; //it's a CoreText attrubite, but only supported by UIKit...
        dic[NSVerticalGlyphFormAttributeName] = All;
        dic[(id)kCTGlyphInfoAttributeName] = CoreText_GGGText;
        dic[(id)kCTCharacterShapeAttributeName] = CoreText_GGGText;
        dic[(id)kCTRunDelegateAttributeName] = CoreText_GGGText;
        dic[(id)kCTBaselineClassAttributeName] = CoreText_GGGText;
        dic[(id)kCTBaselineInfoAttributeName] = CoreText_GGGText;
        dic[(id)kCTBaselineReferenceInfoAttributeName] = CoreText_GGGText;
        dic[(id)kCTWritingDirectionAttributeName] = CoreText_GGGText;
        dic[NSParagraphStyleAttributeName] = All;
        
        if (_GGGDeviceSystemVersion() >= 7) {
            dic[NSStrikethroughColorAttributeName] = UIKit;
            dic[NSUnderlineColorAttributeName] = UIKit;
            dic[NSTextEffectAttributeName] = UIKit;
            dic[NSObliquenessAttributeName] = UIKit;
            dic[NSExpansionAttributeName] = UIKit;
            dic[(id)kCTLanguageAttributeName] = CoreText_GGGText;
            dic[NSBaselineOffsetAttributeName] = UIKit;
            dic[NSWritingDirectionAttributeName] = All;
            dic[NSAttachmentAttributeName] = UIKit;
            dic[NSLinkAttributeName] = UIKit;
        }
        if (_GGGDeviceSystemVersion() >= 8) {
            dic[(id)kCTRubyAnnotationAttributeName] = CoreText;
        }
        
        dic[GGGTextBackedStringAttributeName] = GGGText;
        dic[GGGTextBindingAttributeName] = GGGText;
        dic[GGGTextShadowAttributeName] = GGGText;
        dic[GGGTextInnerShadowAttributeName] = GGGText;
        dic[GGGTextUnderlineAttributeName] = GGGText;
        dic[GGGTextStrikethroughAttributeName] = GGGText;
        dic[GGGTextBorderAttributeName] = GGGText;
        dic[GGGTextBackgroundBorderAttributeName] = GGGText;
        dic[GGGTextBlockBorderAttributeName] = GGGText;
        dic[GGGTextAttachmentAttributeName] = GGGText;
        dic[GGGTextHighlightAttributeName] = GGGText;
        dic[GGGTextGlyphTransformAttributeName] = GGGText;
    });
    NSNumber *num = dic[name];
    if (num) return num.integerValue;
    return GGGTextAttributeTypeNone;
}


@implementation GGGTextBackedString

+ (instancetype)stringWithString:(NSString *)string {
    GGGTextBackedString *one = [self new];
    one.string = string;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.string forKey:@"string"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _string = [aDecoder decodeObjectForKey:@"string"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.string = self.string;
    return one;
}

@end


@implementation GGGTextBinding

+ (instancetype)bindingWithDeleteConfirm:(BOOL)deleteConfirm {
    GGGTextBinding *one = [self new];
    one.deleteConfirm = deleteConfirm;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.deleteConfirm) forKey:@"deleteConfirm"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _deleteConfirm = ((NSNumber *)[aDecoder decodeObjectForKey:@"deleteConfirm"]).boolValue;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.deleteConfirm = self.deleteConfirm;
    return one;
}

@end


@implementation GGGTextShadow

+ (instancetype)shadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    GGGTextShadow *one = [self new];
    one.color = color;
    one.offset = offset;
    one.radius = radius;
    return one;
}

+ (instancetype)shadowWithNSShadow:(NSShadow *)nsShadow {
    if (!nsShadow) return nil;
    GGGTextShadow *shadow = [self new];
    shadow.offset = nsShadow.shadowOffset;
    shadow.radius = nsShadow.shadowBlurRadius;
    id color = nsShadow.shadowColor;
    if (color) {
        if (CGColorGetTypeID() == CFGetTypeID((__bridge CFTypeRef)(color))) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        }
        if ([color isKindOfClass:[UIColor class]]) {
            shadow.color = color;
        }
    }
    return shadow;
}

- (NSShadow *)nsShadow {
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = self.offset;
    shadow.shadowBlurRadius = self.radius;
    shadow.shadowColor = self.color;
    return shadow;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:@(self.radius) forKey:@"radius"];
    [aCoder encodeObject:[NSValue valueWithCGSize:self.offset] forKey:@"offset"];
    [aCoder encodeObject:self.subShadow forKey:@"subShadow"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _color = [aDecoder decodeObjectForKey:@"color"];
    _radius = ((NSNumber *)[aDecoder decodeObjectForKey:@"radius"]).floatValue;
    _offset = ((NSValue *)[aDecoder decodeObjectForKey:@"offset"]).CGSizeValue;
    _subShadow = [aDecoder decodeObjectForKey:@"subShadow"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.color = self.color;
    one.radius = self.radius;
    one.offset = self.offset;
    one.subShadow = self.subShadow.copy;
    return one;
}

@end


@implementation GGGTextDecoration

- (instancetype)init {
    self = [super init];
    _style = GGGTextLineStyleSingle;
    return self;
}

+ (instancetype)decorationWithStyle:(GGGTextLineStyle)style {
    GGGTextDecoration *one = [self new];
    one.style = style;
    return one;
}
+ (instancetype)decorationWithStyle:(GGGTextLineStyle)style width:(NSNumber *)width color:(UIColor *)color {
    GGGTextDecoration *one = [self new];
    one.style = style;
    one.width = width;
    one.color = color;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.style) forKey:@"style"];
    [aCoder encodeObject:self.width forKey:@"width"];
    [aCoder encodeObject:self.color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.style = ((NSNumber *)[aDecoder decodeObjectForKey:@"style"]).unsignedIntegerValue;
    self.width = [aDecoder decodeObjectForKey:@"width"];
    self.color = [aDecoder decodeObjectForKey:@"color"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.style = self.style;
    one.width = self.width;
    one.color = self.color;
    return one;
}

@end


@implementation GGGTextBorder

+ (instancetype)borderWithLineStyle:(GGGTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(UIColor *)color {
    GGGTextBorder *one = [self new];
    one.lineStyle = lineStyle;
    one.strokeWidth = width;
    one.strokeColor = color;
    return one;
}

+ (instancetype)borderWithFillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    GGGTextBorder *one = [self new];
    one.fillColor = color;
    one.cornerRadius = cornerRadius;
    one.insets = UIEdgeInsetsMake(-2, 0, 0, -2);
    return one;
}

- (instancetype)init {
    self = [super init];
    self.lineStyle = GGGTextLineStyleSingle;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.lineStyle) forKey:@"lineStyle"];
    [aCoder encodeObject:@(self.strokeWidth) forKey:@"strokeWidth"];
    [aCoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [aCoder encodeObject:@(self.lineJoin) forKey:@"lineJoin"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.insets] forKey:@"insets"];
    [aCoder encodeObject:@(self.cornerRadius) forKey:@"cornerRadius"];
    [aCoder encodeObject:self.shadow forKey:@"shadow"];
    [aCoder encodeObject:self.fillColor forKey:@"fillColor"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _lineStyle = ((NSNumber *)[aDecoder decodeObjectForKey:@"lineStyle"]).unsignedIntegerValue;
    _strokeWidth = ((NSNumber *)[aDecoder decodeObjectForKey:@"strokeWidth"]).doubleValue;
    _strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
    _lineJoin = (CGLineJoin)((NSNumber *)[aDecoder decodeObjectForKey:@"join"]).unsignedIntegerValue;
    _insets = ((NSValue *)[aDecoder decodeObjectForKey:@"insets"]).UIEdgeInsetsValue;
    _cornerRadius = ((NSNumber *)[aDecoder decodeObjectForKey:@"cornerRadius"]).doubleValue;
    _shadow = [aDecoder decodeObjectForKey:@"shadow"];
    _fillColor = [aDecoder decodeObjectForKey:@"fillColor"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.lineStyle = self.lineStyle;
    one.strokeWidth = self.strokeWidth;
    one.strokeColor = self.strokeColor;
    one.lineJoin = self.lineJoin;
    one.insets = self.insets;
    one.cornerRadius = self.cornerRadius;
    one.shadow = self.shadow.copy;
    one.fillColor = self.fillColor;
    return one;
}

@end


@implementation GGGTextAttachment

+ (instancetype)attachmentWithContent:(id)content {
    GGGTextAttachment *one = [self new];
    one.content = content;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.contentInsets] forKey:@"contentInsets"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _content = [aDecoder decodeObjectForKey:@"content"];
    _contentInsets = ((NSValue *)[aDecoder decodeObjectForKey:@"contentInsets"]).UIEdgeInsetsValue;
    _userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    if ([self.content respondsToSelector:@selector(copy)]) {
        one.content = [self.content copy];
    } else {
        one.content = self.content;
    }
    one.contentInsets = self.contentInsets;
    one.userInfo = self.userInfo.copy;
    return one;
}

@end


@implementation GGGTextHighlight

+ (instancetype)highlightWithAttributes:(NSDictionary *)attributes {
    GGGTextHighlight *one = [self new];
    one.attributes = attributes;
    return one;
}

+ (instancetype)highlightWithBackgroundColor:(UIColor *)color {
    GGGTextBorder *highlightBorder = [GGGTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = color;
    
    GGGTextHighlight *one = [self new];
    [one setBackgroundBorder:highlightBorder];
    return one;
}

- (void)setAttributes:(NSDictionary *)attributes {
    _attributes = attributes.mutableCopy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSData *data = nil;
    @try {
        data = [GGGTextArchiver archivedDataWithRootObject:self.attributes];
    }
    @catch (NSException *exception) {
        AWLog(@"%@",exception);
    }
    [aCoder encodeObject:data forKey:@"attributes"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    NSData *data = [aDecoder decodeObjectForKey:@"attributes"];
    @try {
        _attributes = [GGGTextUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        AWLog(@"%@",exception);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.attributes = self.attributes.mutableCopy;
    return one;
}

- (void)_makeMutableAttributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary new];
    } else if (![_attributes isKindOfClass:[NSMutableDictionary class]]) {
        _attributes = _attributes.mutableCopy;
    }
}

- (void)setFont:(UIFont *)font {
    [self _makeMutableAttributes];
    if (font == (id)[NSNull null] || font == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = [NSNull null];
    } else {
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        if (ctFont) {
            ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = (__bridge id)(ctFont);
            CFRelease(ctFont);
        }
    }
}

- (void)setColor:(UIColor *)color {
    [self _makeMutableAttributes];
    if (color == (id)[NSNull null] || color == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = [NSNull null];
        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = (__bridge id)(color.CGColor);
        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = color;
    }
}

- (void)setStrokeWidth:(NSNumber *)width {
    [self _makeMutableAttributes];
    if (width == (id)[NSNull null] || width == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = width;
    }
}

- (void)setStrokeColor:(UIColor *)color {
    [self _makeMutableAttributes];
    if (color == (id)[NSNull null] || color == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = [NSNull null];
        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = (__bridge id)(color.CGColor);
        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = color;
    }
}

- (void)setTextAttribute:(NSString *)attribute value:(id)value {
    [self _makeMutableAttributes];
    if (value == nil) value = [NSNull null];
    ((NSMutableDictionary *)_attributes)[attribute] = value;
}

- (void)setShadow:(GGGTextShadow *)shadow {
    [self setTextAttribute:GGGTextShadowAttributeName value:shadow];
}

- (void)setInnerShadow:(GGGTextShadow *)shadow {
    [self setTextAttribute:GGGTextInnerShadowAttributeName value:shadow];
}

- (void)setUnderline:(GGGTextDecoration *)underline {
    [self setTextAttribute:GGGTextUnderlineAttributeName value:underline];
}

- (void)setStrikethrough:(GGGTextDecoration *)strikethrough {
    [self setTextAttribute:GGGTextStrikethroughAttributeName value:strikethrough];
}

- (void)setBackgroundBorder:(GGGTextBorder *)border {
    [self setTextAttribute:GGGTextBackgroundBorderAttributeName value:border];
}

- (void)setBorder:(GGGTextBorder *)border {
    [self setTextAttribute:GGGTextBorderAttributeName value:border];
}

- (void)setAttachment:(GGGTextAttachment *)attachment {
    [self setTextAttribute:GGGTextAttachmentAttributeName value:attachment];
}

@end

