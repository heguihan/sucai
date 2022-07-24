//
//  GGGTextInput.m
//  GGGText <https://github.com/ibireme/GGGText>
//
//  Created by ibireme on 15/4/17.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "GGGTextInput.h"
#import "GGGTextUtilities.h"


@implementation GGGTextPosition

+ (instancetype)positionWithOffset:(NSInteger)offset {
    return [self positionWithOffset:offset affinity:GGGTextAffinityForward];
}

+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(GGGTextAffinity)affinity {
    GGGTextPosition *p = [self new];
    p->_offset = offset;
    p->_affinity = affinity;
    return p;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self.class positionWithOffset:_offset affinity:_affinity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@%@)", self.class, self, @(_offset), _affinity == GGGTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return _offset * 2 + (_affinity == GGGTextAffinityForward ? 1 : 0);
}

- (BOOL)isEqual:(GGGTextPosition *)object {
    if (!object) return NO;
    return _offset == object.offset && _affinity == object.affinity;
}

- (NSComparisonResult)compare:(GGGTextPosition *)otherPosition {
    if (!otherPosition) return NSOrderedAscending;
    if (_offset < otherPosition.offset) return NSOrderedAscending;
    if (_offset > otherPosition.offset) return NSOrderedDescending;
    if (_affinity == GGGTextAffinityBackward && otherPosition.affinity == GGGTextAffinityForward) return NSOrderedAscending;
    if (_affinity == GGGTextAffinityForward && otherPosition.affinity == GGGTextAffinityBackward) return NSOrderedDescending;
    return NSOrderedSame;
}

@end



@implementation GGGTextRange {
    GGGTextPosition *_start;
    GGGTextPosition *_end;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _start = [GGGTextPosition positionWithOffset:0];
    _end = [GGGTextPosition positionWithOffset:0];
    return self;
}

- (GGGTextPosition *)start {
    return _start;
}

- (GGGTextPosition *)end {
    return _end;
}

- (BOOL)isEmpty {
    return _start.offset == _end.offset;
}

- (NSRange)asRange {
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

+ (instancetype)rangeWithRange:(NSRange)range {
    return [self rangeWithRange:range affinity:GGGTextAffinityForward];
}

+ (instancetype)rangeWithRange:(NSRange)range affinity:(GGGTextAffinity)affinity {
    GGGTextPosition *start = [GGGTextPosition positionWithOffset:range.location affinity:affinity];
    GGGTextPosition *end = [GGGTextPosition positionWithOffset:range.location + range.length affinity:affinity];
    return [self rangeWithStart:start end:end];
}

+ (instancetype)rangeWithStart:(GGGTextPosition *)start end:(GGGTextPosition *)end {
    if (!start || !end) return nil;
    if ([start compare:end] == NSOrderedDescending) {
        GGGTEXT_SWAP(start, end);
    }
    GGGTextRange *range = [GGGTextRange new];
    range->_start = start;
    range->_end = end;
    return range;
}

+ (instancetype)defaultRange {
    return [self new];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self.class rangeWithStart:_start end:_end];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@, %@)%@", self.class, self, @(_start.offset), @(_end.offset - _start.offset), _end.affinity == GGGTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return (sizeof(NSUInteger) == 8 ? OSSwapInt64(_start.hash) : OSSwapInt32(_start.hash)) + _end.hash;
}

- (BOOL)isEqual:(GGGTextRange *)object {
    if (!object) return NO;
    return [_start isEqual:object.start] && [_end isEqual:object.end];
}

@end



@implementation GGGTextSelectionRect

@synthesize rect = _rect;
@synthesize writingDirection = _writingDirection;
@synthesize containsStart = _containsStart;
@synthesize containsEnd = _containsEnd;
@synthesize isVertical = _isVertical;

- (id)copyWithZone:(NSZone *)zone {
    GGGTextSelectionRect *one = [self.class new];
    one.rect = _rect;
    one.writingDirection = _writingDirection;
    one.containsStart = _containsStart;
    one.containsEnd = _containsEnd;
    one.isVertical = _isVertical;
    return one;
}

@end
