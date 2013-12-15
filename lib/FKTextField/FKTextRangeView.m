/*
 
 FKTextRangeView.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FKTextRangeView.h"

#import "FKTextAppearance.h"

#pragma mark -
#pragma mark FKTextRangeView implementation

@implementation FKTextRangeView

@synthesize rects = _rects;
@synthesize rectViews = _rectViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _rects = nil;
        _rectViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.rects = nil;
    self.rectViews = nil;
    
    [super dealloc];
}

- (void)setRects:(NSArray *)rects
{
    if(_rects != nil)
    {
        for(UIView * rectView in _rectViews)
            [rectView removeFromSuperview];
        
        [_rectViews removeAllObjects];
        [_rects release];
        _rects = nil;
    }
    
    _rects = [rects copy];
    
    if(_rects != nil)
    {
        if([_rects count] == 1) // one rect only, draw according to its origin and size
        {
            CGRect rect = [[_rects objectAtIndex:0] CGRectValue];
            [_rectViews addObject:[FKTextRangeView defaultRangeViewForRect:rect]];
        }
        else if([_rects count] > 1) // 2 or more rects, draw first, last and middle rect but align to content view boundaries
        {
            CGRect firstRect = [[_rects objectAtIndex:0] CGRectValue];
            firstRect.size.width = self.bounds.size.width - firstRect.origin.x; // match right edge
            [_rectViews addObject:[FKTextRangeView defaultRangeViewForRect:firstRect]];
            
            CGRect lastRect = [[_rects lastObject] CGRectValue];
            lastRect.size.width += lastRect.origin.x; // match left edge
            lastRect.origin.x = 0; // match left edge
            [_rectViews addObject:[FKTextRangeView defaultRangeViewForRect:lastRect]];
            
            if([_rects count] > 2) // there a middle
            {
                CGRect middleRect = CGRectMake(0, firstRect.origin.y + firstRect.size.height, self.bounds.size.width, lastRect.origin.y - (firstRect.origin.y + firstRect.size.height));
                [_rectViews addObject:[FKTextRangeView defaultRangeViewForRect:middleRect]];
            }
        }
        
        // Add subviews
        for(UIView * rangeView in _rectViews)
        {
            [self addSubview:rangeView];
        }
    }
}

+ (UIView *)defaultRangeViewForRect:(CGRect)rect
{
    UIView * rangeView = [[UIView alloc] initWithFrame:rect];
    [rangeView setBackgroundColor:[FKTextAppearance defaultSelectionRangeColor]];
    return [rangeView autorelease];
}

@end
