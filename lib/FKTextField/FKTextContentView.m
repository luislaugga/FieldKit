/*
 
 FKTextContentView.m
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

#import "FKTextContentView.h"
#import "FKTextContentView_Internal.h"

#import "FKTextAppearance.h"

@implementation FKTextContentView

@synthesize text = _text, font = _font, textColor = _textColor;
@synthesize attributes = _attributes;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Set up view
        self.layer.geometryFlipped = YES;  // For ease of interaction with the CoreText coordinate system.
        self.backgroundColor = [UIColor clearColor];
        
        // Set up default text properties
        self.text = @"";        
        self.font = [FKTextAppearance defaultFont];
        self.textColor = [FKTextAppearance defaultTextColor];
        
        // Set up rendering
        self.attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    // Text properties
    self.text = nil;
    self.font = nil;
    self.textColor = nil;
    
    // Text rendering
    self.attributes = nil;
    
    [super dealloc];
}
#endif

#pragma mark -
#pragma mark Properties

- (void)setText:(NSString *)text
{
    if (_text == text) 
        return;
    
#if !__has_feature(objc_arc)
    NSString * oldValue = _text;
    _text = [text copy];
    [oldValue release];
#else
    _text = [text copy];
#endif
    
    if(_text != nil)
    {
        // Update view
        [self updateContentIfNeeded];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor == textColor) 
        return;
    
#if !__has_feature(objc_arc)
    UIColor * oldValue = _textColor;
    _textColor = [textColor retain];
    [oldValue release];
#else
    _textColor = textColor;
#endif
    
    if(_textColor != nil)
    {    
        // Create CGColor object
        CGColorRef cgTextColor = CGColorCreateCopy(_textColor.CGColor);
        
        // Set CTFont instance in our attributes dictionary, to be set on our attributed string
        [self.attributes setObject:(__bridge id)cgTextColor forKey:(NSString *)kCTForegroundColorAttributeName];
        
        // Release CGColor object
        CGColorRelease(cgTextColor);
        
        // Update view
        [self updateContentIfNeeded];
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font == font)
        return;

#if !__has_feature(objc_arc)
    UIFont *oldValue = _font;
    _font = [font retain];
    [oldValue release];
#else
    _font = font;
#endif

    if(_font != nil)
    {
        // Find matching CTFont via name and size
        CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);        
        
        // Set CTFont instance in our attributes dictionary, to be set on our attributed string
        [self.attributes setObject:(__bridge id)ctFont forKey:(NSString *)kCTFontAttributeName];
        
        // Release CTFont object
        CFRelease(ctFont);       
        
        // Update view
        [self updateContentIfNeeded];
    }
}

#pragma mark -
#pragma mark Update

- (void)updateContentIfNeeded
{
    
      
    [self clearPreviouslyCachedInformation];
    
    // Build the attributed string from our text data and string attribute data
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:self.attributes];    
    
    // Create the Core Text framesetter using the attributed string
    _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    // Create the Core Text frame using our current view rect bounds
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    _frame =  CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), [path CGPath], NULL);

#if !__has_feature(objc_arc)
    // Release attributed string
    [attributedString release];
#endif
    
    // Mark view to be re-drawn
    [self setNeedsDisplay];
}

- (void)clearPreviouslyCachedInformation
{
    if (_framesetter != NULL) {
        CFRelease(_framesetter);
        _framesetter = NULL;
    }
    
    if (_frame != NULL) {
        CFRelease(_frame);
        _frame = NULL;
    }
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect 
{
    CTFrameDraw(_frame, UIGraphicsGetCurrentContext());
}

#pragma mark -
#pragma mark FKTextSelectingContent protocol

- (CGRect)textOffsetRectForIndex:(NSUInteger)index
{    
    // Lines
    NSArray * lines = (NSArray *)CTFrameGetLines(_frame);

    // Metrics
    CGFloat ascent = ceilf(fabs(self.font.ascender)); // Note: using fabs() for typically negative descender from fonts
    CGFloat descent = ceilf(fabs(self.font.descender)); // Note: using ceilf() for rounding up to nearest integer

    // Special case, no text
    if (_text.length == 0 || index == 0) 
    {
        CGPoint origin = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
        return [self convertRectToUIViewDefaultCoordinateSystem:CGRectMake(0, origin.y - ascent - descent , 0, ascent + descent)]; // First line's baseline distance from upper bound is equal to ascent font metrics
    }    

    // Special case, insertion point at final position in text after newline
    if (index == _text.length && [_text characterAtIndex:(index - 1)] == '\n') 
    {
        CTLineRef line = (__bridge CTLineRef)[lines lastObject];
        CFRange range = CTLineGetStringRange(line);
        CGFloat offset = CTLineGetOffsetForStringIndex(line, range.location, NULL);
        CGPoint origin;
        CGPoint * origins = (CGPoint *)malloc(sizeof(CGPoint));
        CTFrameGetLineOrigins(_frame, CFRangeMake([lines count]-1, 0), origins);
        origin = origins[0];
        free(origins);
        origin.y -= self.font.leading;
        return [self convertRectToUIViewDefaultCoordinateSystem:CGRectMake(origin.x + offset, floorf(origin.y - descent), 0, ascent+descent)];
    }

    // Regular case, caret somewhere within our text content range
    index = MAX(index, 0);
    index = MIN(_text.length, index);

    NSInteger linesCount = [lines count];  
    CGPoint origins[linesCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, linesCount), origins);
    
    CGRect textOffsetRect = CGRectZero;

    for (int i = 0; i < linesCount; i++) 
    {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        CFRange cfRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(cfRange.location, cfRange.length);
        
        if (index >= range.location && index <= range.location+range.length)
        {
            CGFloat offset = CTLineGetOffsetForStringIndex((CTLineRef)[lines objectAtIndex:i], index, NULL); 
            CGPoint origin = origins[i];
            textOffsetRect = CGRectMake(origin.x + offset, floorf(origin.y - descent), 0, ascent+descent);
        } 
    }
    
    return [self convertRectToUIViewDefaultCoordinateSystem:textOffsetRect]; // return using UIView default coordinate system
}

- (CGRect)textFirstRectForRange:(NSRange)range
{
    NSInteger index = range.location;

    // Iterate over our CTLines, looking for the line that encompasses the given range
    NSArray * lines = (NSArray *)CTFrameGetLines(_frame);
    NSInteger linesCount = [lines count];  
    for (int i = 0; i < linesCount; i++)
    {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        CFRange lineRange = CTLineGetStringRange(line);
        NSInteger localIndex = index - lineRange.location;
        if (localIndex >= 0 && localIndex < lineRange.length)
        {
			// just the first line that intersects range TODO make it multi-line
            NSInteger finalIndex = MIN(lineRange.location + lineRange.length, range.location + range.length);
            
			// Create a rect for the given range within this line
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, finalIndex, NULL);
            
            // Origin
            CGPoint origin;
            CTFrameGetLineOrigins(_frame, CFRangeMake(i, 1), &origin);
            
            // Metrics
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
    
            return CGRectMake(xStart, origin.y - descent, xEnd - xStart, ascent + descent);
        }
    }
    
    return CGRectNull;
}

- (NSArray *)textRectsForRange:(NSRange)range
{
    // Metrics
    CGFloat ascent = ceilf(fabs(self.font.ascender)); // Note: using fabs() for typically negative descender from fonts
    CGFloat descent = ceilf(fabs(self.font.descender)); // Note: using ceilf() for rounding up to nearest integer
    
	// Iterate over the lines in our CTFrame, looking for lines that intersect
	// with the given selection range, and draw a selection rect for each intersection
    NSArray *lines = (NSArray *) CTFrameGetLines(_frame);
    NSInteger linesCount = [lines count];  
    CGPoint origins[linesCount];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, linesCount), origins);
    
    NSMutableArray * textRects = [[NSMutableArray alloc] initWithCapacity:linesCount];
    
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange cfLineRange = CTLineGetStringRange(line);
        NSRange lineRange = NSMakeRange(cfLineRange.location, cfLineRange.length);
        NSRange intersectionRange = [self textIntersectionRangeBetweenRange:lineRange andOtherRange:range];
        if (intersectionRange.location != NSNotFound && intersectionRange.length > 0) 
        {
			// The text range for this line intersects our selection range
            CGFloat offsetStart = CTLineGetOffsetForStringIndex(line, intersectionRange.location, NULL);
            CGFloat offsetEnd = CTLineGetOffsetForStringIndex(line, intersectionRange.location + intersectionRange.length, NULL);
            CGPoint origin = origins[i];
			// Create a rect for the intersection and draw it with selection color
            CGRect lineSelectionRect = CGRectMake(offsetStart, origin.y - descent, offsetEnd - offsetStart, ascent + descent);
            
            [textRects addObject:[NSValue valueWithCGRect:[self convertRectToUIViewDefaultCoordinateSystem:lineSelectionRect]]];
        }
    }    

#if !__has_feature(objc_arc)
    return [textRects autorelease];
#else
    return textRects;
#endif
}

- (NSUInteger)textClosestIndexForPoint:(CGPoint)point
{	
    // Convert point
    CGPoint _point = [self convertPointFromUIViewDefaultCoordinateSystem:point];
    
	// Use Core Text to find the text index for a given CGPoint by
	// iterating over the y-origin points for each line, finding the closest
	// line, and finding the closest index within that line.
    NSArray *lines = (NSArray *) CTFrameGetLines(_frame);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, lines.count), origins);
    
    for (int i = 0; i < lines.count; i++) 
    {
        if (_point.y > origins[i].y)
        {
			// This line origin is closest to the y-coordinate of our point,
			// now look for the closest string index in this line.
            CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
            return CTLineGetStringIndexForPosition(line, _point);
        }
    }
    
    return _text.length;
}

- (NSRange)textWordRangeForIndex:(NSUInteger)index
{
    __block NSArray * lines = (NSArray *)CTFrameGetLines(_frame);
    __block NSRange wordRange = NSMakeRange(NSNotFound, 0);
    
    for (int i = 0; i < [lines count]; i++) 
    {
        __block CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:i];
        CFRange cfRange = CTLineGetStringRange(line);
        NSRange range = NSMakeRange(cfRange.location == kCFNotFound ? NSNotFound : cfRange.location, cfRange.length == kCFNotFound ? 0 : cfRange.length);
        
        if (index >= range.location && index <= range.location+range.length)
        {
            if (range.length >= 1) 
            {
                [_text enumerateSubstringsInRange:range 
                                          options:NSStringEnumerationByWords 
                                       usingBlock:^(NSString * subString, NSRange subStringRange, NSRange enclosingRange, BOOL * stop) {
                                           NSInteger subStringStart = subStringRange.location;
                                           NSInteger subStringEnd = subStringStart + subStringRange.length;
                                           if (index >= subStringStart && index <= subStringEnd) 
                                           {
                                               wordRange = subStringRange;
                                               *stop = YES;
                                           }
                                       }];
            }
        }
    }
    
    return wordRange;
}

- (NSRange)textIntersectionRangeBetweenRange:(NSRange)range andOtherRange:(NSRange)otherRange
{
    NSRange intersectionRange = NSMakeRange(NSNotFound, 0);
    
	// Ensure first range does not start after second range
    if (range.location > otherRange.location) {
        NSRange tmp = range;
        range = otherRange;
        otherRange = tmp;
    }
    
	// Find the overlap intersection range between first and second
    if (otherRange.location < range.location + range.length) {
        intersectionRange.location = otherRange.location;
        NSUInteger end = MIN(range.location + range.length, otherRange.location + otherRange.length);
        intersectionRange.length = end - intersectionRange.location;
    }
    
    return intersectionRange;    
}

#pragma mark -
#pragma mark Helper methods

- (CGRect)convertRectToUIViewDefaultCoordinateSystem:(CGRect)rect
{
    return CGRectMake((int)(rect.origin.x), (int)(self.bounds.size.height-rect.origin.y-rect.size.height), (int)(rect.size.width), (int)(rect.size.height));
}

- (CGPoint)convertPointFromUIViewDefaultCoordinateSystem:(CGPoint)point
{
#warning assumes the view occupies entire superview or whatever container it is in...
    return CGPointMake(point.x, self.bounds.size.height-point.y);
}

@end
