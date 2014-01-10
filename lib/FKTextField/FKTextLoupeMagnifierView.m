/*
 
 FKTextLoupeMagnifierView.m
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

#import "FKTextLoupeMagnifierView.h"

#define kTextLoupeMagnifierViewHalfWidth 60.0f
#define kTextLoupeMagnifierViewWidth 119.0f
#define kTextLoupeMagnifierViewHalfHeight 60.0f
#define kTextLoupeMagnifierViewHeight 119.0f

#define kTextLoupeMagnifierViewMaskWidth 114.0f
#define kTextLoupeMagnifierViewMaskHeight 114.0f
#define kTextLoupeMagnifierViewMaskOffsetX 2.5f
#define kTextLoupeMagnifierViewMaskOffsetY 0.5f

@implementation FKTextLoupeMagnifierView

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_loupeMask release];
    [_loupeHigh release];
    
    [super dealloc];
}
#endif

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kTextLoupeMagnifierViewWidth, kTextLoupeMagnifierViewHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle * bundle = [NSBundle bundleForClass:[self class]];
#if !__has_feature(objc_arc)
        _loupeMask = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-loupe-mask" ofType:@"png"]] retain];
        _loupeHigh = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-loupe-hi" ofType:@"png"]] retain];
#else
        _loupeMask = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-loupe-mask" ofType:@"png"]];
        _loupeHigh = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-loupe-hi" ofType:@"png"]];
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
    CGRect maskRect = CGRectMake(rect.origin.x+kTextLoupeMagnifierViewMaskOffsetX, rect.origin.y+kTextLoupeMagnifierViewMaskOffsetY, kTextLoupeMagnifierViewMaskWidth, kTextLoupeMagnifierViewMaskHeight);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, maskRect, _loupeMask.CGImage);
    [contentImage drawInRect:maskRect];
    CGContextRestoreGState(context);
    
    [_loupeHigh drawInRect:rect];
    
#if !__has_feature(objc_arc)
    [contentImage release];
#endif
}

- (UIImage *)contentImage
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = CGSizeMake(kTextLoupeMagnifierViewMaskWidth, kTextLoupeMagnifierViewMaskHeight);//[[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    // Current context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Translate context to the loupe magnifier position
    CGContextTranslateCTM(context, -_position.x+kTextLoupeMagnifierViewHalfWidth, -_position.y);
    
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
    self.frame = CGRectMake(position.x-kTextLoupeMagnifierViewHalfWidth, position.y-kTextLoupeMagnifierViewHalfHeight, kTextLoupeMagnifierViewWidth, kTextLoupeMagnifierViewHeight);
    [self setNeedsDisplay];
}

@end