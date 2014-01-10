/*
 
 FKTextRangeMagnifierView.m
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

#import "FKTextRangeMagnifierView.h"

#define kTextRangeMagnifierViewHalfWidth 70
#define kTextRangeMagnifierViewWidth 139
#define kTextRangeMagnifierViewHalfHeight 28
#define kTextRangeMagnifierViewHeight 55

#define kTextRangeMagnifierViewMaskWidth 129.0f
#define kTextRangeMagnifierViewMaskHeight 32.0f
#define kTextRangeMagnifierViewMaskOffsetX 5.0f
#define kTextRangeMagnifierViewMaskOffsetY 3.0f

@implementation FKTextRangeMagnifierView

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_magnifierRangedMask release];
    [_magnifierRangedHigh release];
    
    [super dealloc];
}
#endif

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kTextRangeMagnifierViewWidth, kTextRangeMagnifierViewHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle * bundle = [NSBundle bundleForClass:[self class]];
        
#if !__has_feature(objc_arc)
        _magnifierRangedMask = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-mask" ofType:@"png"]] retain];
        _magnifierRangedHigh = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-hi" ofType:@"png"]] retain];
#else
        _magnifierRangedMask = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-mask" ofType:@"png"]];
        _magnifierRangedHigh = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-hi" ofType:@"png"]];
#endif
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
#if !__has_feature(objc_arc)
    UIImage * contentImage = [[self contentImage] retain];
#else
    UIImage * contentImage = [self contentImage];
#endif
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[_magnifierRangedMask drawInRect:rect];
    CGRect maskRect = CGRectMake(rect.origin.x+kTextRangeMagnifierViewMaskOffsetX, rect.origin.y+kTextRangeMagnifierViewMaskOffsetY, kTextRangeMagnifierViewMaskWidth, kTextRangeMagnifierViewMaskHeight);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, maskRect, _magnifierRangedMask.CGImage);
    [contentImage drawInRect:maskRect];
    CGContextRestoreGState(context);
    
    [_magnifierRangedHigh drawInRect:rect];
    
#if !__has_feature(objc_arc)
    [contentImage release];
#endif
}

- (UIImage *)contentImage
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = CGSizeMake(kTextRangeMagnifierViewMaskWidth, kTextRangeMagnifierViewMaskHeight);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    // Current context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Translate context to the loupe magnifier position
    CGContextTranslateCTM(context, -_position.x+kTextRangeMagnifierViewHalfWidth, -_position.y-kTextRangeMagnifierViewHeight);
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
        }
    }

    // Retrieve the clipped image
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.frame = CGRectMake(position.x-kTextRangeMagnifierViewHalfWidth, position.y, kTextRangeMagnifierViewWidth, kTextRangeMagnifierViewHeight);
    [self setNeedsDisplay];
}

@end