//
//  LATokenFieldCell.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenFieldCell.h"

@implementation LATokenFieldCell

@synthesize font = _font;
@synthesize text = _text;

@synthesize representedObject = _representedObject;

@synthesize scaled = _scaled;
@synthesize unscaledBounds = _unscaledBounds;

#define kTokenFieldCellInsetLeft 8
#define kTokenFieldCellScaledInsetLeft 10
#define kTokenFieldCellInsetTop 3
#define kTokenFieldCellScaledInsetTop 4

#define kTokenFieldCellScaleAnimationDuration 0.15

#define kTokenFieldCellUnscaledFactor 1.0
#define kTokenFieldCellUnscaledCap 12
#define kTokenFieldCellUnscaledAlpha 1.0
#define kTokenFieldCellScaledFactor 1.2
#define kTokenFieldCellScaledCap 15
#define kTokenFieldCellScaledAlpha 0.9

#pragma mark -
#pragma mark Initialization

- (id)initWithText:(NSString *)text andFont:(UIFont *)font;
{
    CGSize textSize = [text sizeWithFont:font];
    self = [super initWithFrame:CGRectMake(0, 0, kTokenFieldCellInsetLeft + textSize.width + kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop + textSize.height + kTokenFieldCellInsetTop)];
    if (self) 
    {
        self.selected = NO;
        
        self.text = text; // copy
        self.font = font; // assign
        
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw; // drawRect: method invoked when the frame rectangle changes (ie. scaled = YES)
        
        _unscaledBounds = self.bounds;
        _scaledBounds = CGRectApplyAffineTransform(_unscaledBounds, CGAffineTransformMakeScale(kTokenFieldCellScaledFactor, kTokenFieldCellScaledFactor));
        _scaledBounds.size.width = floorf(_scaledBounds.size.width);
        _scaledBounds.size.height = floorf(_scaledBounds.size.height);
        
        _scaledFont = [UIFont fontWithName:font.fontName size:floorf(font.pointSize*kTokenFieldCellScaledFactor)];
        
        self.representedObject = nil;
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
    self.font = nil;
    
    self.representedObject = nil; // release
    
    [super dealloc];
}

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
        self.bounds = _scaledBounds;
        self.alpha = kTokenFieldCellScaledAlpha;
    }
    else
    {
        self.bounds = _unscaledBounds;
        self.alpha = kTokenFieldCellUnscaledAlpha;
    }

//    if(animated)
//    {
//        [UIView animateWithDuration:kTokenFieldCellScaleAnimationDuration animations:^{
//            if(scaled)
//            {
//                _scaled = YES;
//                [self setNeedsDisplay];
//                self.bounds = _scaledBounds;
//                self.alpha = kTokenFieldCellScaledAlpha;
//            }
//            else
//            {
//                self.bounds = _unscaledBounds;
//                self.alpha = kTokenFieldCellUnscaledAlpha;
//            }
//        }
//                         completion:^(BOOL finished){
//            if(finished)
//            {
//                NSLog(@"finished");
//                _scaled = scaled;
//                [self setNeedsDisplay];
//            }
//        }];
//    }
//    else
//    {
}

#pragma mark -
#pragma mark UIControl

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    NSLog(@"rect %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    UIImage * backgroundImage;
    UIColor * textColor;
    UIFont * textFont;
    CGPoint textPoint;
    
    if(self.scaled)
    {
        NSString * selectedScaledPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom-selected-scaled" ofType:@"png"];
        backgroundImage = [[UIImage imageWithContentsOfFile:selectedScaledPath] stretchableImageWithLeftCapWidth:kTokenFieldCellScaledCap topCapHeight:kTokenFieldCellScaledCap];
        textColor = [UIColor whiteColor];
        textFont = _scaledFont;
        textPoint = CGPointMake(kTokenFieldCellScaledInsetLeft, kTokenFieldCellScaledInsetTop);
    }
    else if(self.selected)
    {
        NSString * selectedPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom-selected" ofType:@"png"];
        backgroundImage = [[UIImage imageWithContentsOfFile:selectedPath] stretchableImageWithLeftCapWidth:kTokenFieldCellUnscaledCap topCapHeight:kTokenFieldCellUnscaledCap];
        textColor = [UIColor whiteColor];
        textFont = _font;
        textPoint = CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop);
    }
    else
    {
        NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom" ofType:@"png"];
        backgroundImage = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:kTokenFieldCellUnscaledCap topCapHeight:kTokenFieldCellUnscaledCap];
        textColor = [UIColor blackColor];
        textFont = _font;
        textPoint = CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop);
    }
    
    // Draw background image
    [backgroundImage drawInRect:rect];
    
    // Draw display string
    [textColor setFill];
    [_text drawAtPoint:textPoint withFont:textFont];
}

#pragma mark -
#pragma mark Helpers

@end
