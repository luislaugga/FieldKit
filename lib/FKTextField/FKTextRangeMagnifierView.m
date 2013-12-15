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

@implementation FKTextRangeMagnifierView

- (void)dealloc
{
    [_magnifierRangedLow release];
    [_magnifierRangedMask release];
    [_magnifierRangedHigh release];
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 145.0f, 59.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle * bundle = [NSBundle bundleForClass:[self class]];
        _magnifierRangedLow = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-lo" ofType:@"png"]] retain];
        _magnifierRangedMask = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-mask" ofType:@"png"]] retain];
        _magnifierRangedHigh = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"FieldKit.bundle/kb-magnifier-ranged-hi" ofType:@"png"]] retain];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage * contentImage = [[self contentImage] retain];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_magnifierRangedLow drawInRect:rect];
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, _magnifierRangedMask.CGImage);
    [contentImage drawInRect:rect];
    CGContextRestoreGState(context);
    
    [_magnifierRangedHigh drawInRect:rect];
    
    [contentImage release];
}

- (UIImage *)contentImage
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = CGSizeMake(145.0f, 59.0f);//[[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    // Current context reference
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Translate context to the loupe magnifier position
    CGContextTranslateCTM(context, -_position.x+50.0f, -_position.y-10.0f);
    
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
    self.frame = CGRectMake(position.x-73.0f, position.y-40.0f, 145.0f, 59.0f);
    [self setNeedsDisplay];
}

@end