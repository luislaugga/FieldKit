/*
 
 FKTokenFieldCell.m
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

#import "FKTokenFieldCell.h"

@implementation FKTokenFieldCell

@synthesize font = _font;
@synthesize text = _text;

@synthesize representedObject = _representedObject;

@synthesize scaled = _scaled;
@synthesize size = _size;

#define kTokenFieldCellInsetLeft 5 // token text label left offset in pixels
#define kTokenFieldCellInsetTop 3 // token text label top offset in pixels
#define kTokenFieldCellStretchCapLeft 6
#define kTokenFieldCellStretchCapTop 6
#define kTokenFieldCellOpacity 1.0

#define kTokenFieldCellScaledFactor 1.25
#define kTokenFieldCellScaledInsetLeft 9
#define kTokenFieldCellScaledInsetTop 4
#define kTokenFieldCellScaledStretchCapLeft 6
#define kTokenFieldCellScaledStretchCapTop 6
#define kTokenFieldCellScaledOpacity 0.9

#define kTokenFieldCellScaledAnimationDuration 0.15

#pragma mark -
#pragma mark Initialization

- (id)initWithText:(NSString *)text andFont:(UIFont *)font;
{ 
    self = [super init];
    if (self) 
    {
        CGSize textSize = [text sizeWithFont:font];
        _size = CGSizeMake(kTokenFieldCellInsetLeft + textSize.width + kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop + textSize.height + kTokenFieldCellInsetTop);
        
        self.frame = CGRectMake(0, 0, _size.width, _size.height);
        self.selected = NO;
        
        self.text = text; // copy
        self.font = font; // assign
        
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw; // drawRect: method invoked when the frame rectangle changes (ie. scaled = YES)
        
        self.representedObject = nil;
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    self.text = nil;
    self.font = nil;
    
    self.representedObject = nil; // release
    
    [super dealloc];

}
#endif

#pragma mark -
#pragma mark Properties

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Update drawing
    [self setNeedsDisplay];
}

- (void)setScaled:(BOOL)scaled animated:(BOOL)animated
{
    _scaled = scaled;
    
    if(_scaled)
    {
        self.bounds = CGRectMake(0, 0, floorf(kTokenFieldCellScaledFactor*_size.width), floorf(kTokenFieldCellScaledFactor*_size.height));
        self.alpha = kTokenFieldCellScaledOpacity;
    }
    else
    {
        self.bounds = CGRectMake(0, 0, _size.width, _size.height);
        self.alpha = kTokenFieldCellOpacity;
    }
    
    if(animated)
    {
        if(scaled)
            self.transform = CGAffineTransformMakeScale(1.0f/kTokenFieldCellScaledFactor, 1.0f/kTokenFieldCellScaledFactor);
        else
            self.transform = CGAffineTransformMakeScale(kTokenFieldCellScaledFactor, kTokenFieldCellScaledFactor);
        
        [UIView animateWithDuration:kTokenFieldCellScaledAnimationDuration delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }
                         completion:^(BOOL finished){
                             if(finished)
                                 self.transform = CGAffineTransformIdentity;
                             self.frame = CGRectMake(floorf(self.frame.origin.x), floorf(self.frame.origin.y), floorf(self.frame.size.width), floorf(self.frame.size.height));
                         }];
    }
}

#pragma mark -
#pragma mark UIControl

//- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//{
//    [super sendAction:action to:target forEvent:event];
//}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    UIImage * backgroundImage;
    UIColor * textColor;
    UIFont * textFont;
    CGPoint textPoint;
    
    if(self.scaled)
    {
        NSString * selectedScaledPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom-selected-scaled" ofType:@"png"];
        backgroundImage = [[UIImage imageWithContentsOfFile:selectedScaledPath] stretchableImageWithLeftCapWidth:kTokenFieldCellScaledStretchCapLeft topCapHeight:kTokenFieldCellScaledStretchCapTop];
       
        textColor = [UIColor whiteColor];
        textFont = [UIFont fontWithName:_font.fontName size:floorf(_font.pointSize*kTokenFieldCellScaledFactor)];
        textPoint = CGPointMake(kTokenFieldCellScaledInsetLeft, kTokenFieldCellScaledInsetTop);
    }
    else
    {
        if(self.selected)
        {
            NSString * selectedPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom-selected" ofType:@"png"];
            backgroundImage = [[UIImage imageWithContentsOfFile:selectedPath] stretchableImageWithLeftCapWidth:kTokenFieldCellStretchCapLeft topCapHeight:kTokenFieldCellStretchCapTop];
            
            textColor = [UIColor whiteColor];
        }
        else
        {
            NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom" ofType:@"png"];
            backgroundImage = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:kTokenFieldCellStretchCapLeft topCapHeight:kTokenFieldCellStretchCapTop];
            
            textColor = [UIColor colorWithRed:0.55686274509804 green:0.55686274509804 blue:0.57647058823529 alpha:1.0];
        }
        
        textFont = _font;
        textPoint = CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop);
    }
    
    // Draw background image
    [backgroundImage drawInRect:rect];
    
    // Draw text
    [textColor setFill];
    [_text drawAtPoint:textPoint withFont:textFont];
}

#pragma mark -
#pragma mark Helpers

@end
