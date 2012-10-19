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
@synthesize size = _size;

#define kTokenFieldCellInsetLeft 8
#define kTokenFieldCellInsetTop 3
#define kTokenFieldCellStretchCap 12
#define kTokenFieldCellOpacity 1.0

#define kTokenFieldCellScaledFactor 1.2
#define kTokenFieldCellScaledInsetLeft 10
#define kTokenFieldCellScaledInsetTop 4
#define kTokenFieldCellScaledStretchCap 15
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
        backgroundImage = [[UIImage imageWithContentsOfFile:selectedScaledPath] stretchableImageWithLeftCapWidth:kTokenFieldCellScaledStretchCap topCapHeight:kTokenFieldCellScaledStretchCap];
       
        textColor = [UIColor whiteColor];
        textFont = [UIFont fontWithName:_font.fontName size:floorf(_font.pointSize*kTokenFieldCellScaledFactor)];
        textPoint = CGPointMake(kTokenFieldCellScaledInsetLeft, kTokenFieldCellScaledInsetTop);
    }
    else
    {
        if(self.selected)
        {
            NSString * selectedPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom-selected" ofType:@"png"];
            backgroundImage = [[UIImage imageWithContentsOfFile:selectedPath] stretchableImageWithLeftCapWidth:kTokenFieldCellStretchCap topCapHeight:kTokenFieldCellStretchCap];
            
            textColor = [UIColor whiteColor];
        }
        else
        {
            NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"FieldKit.bundle/token-atom" ofType:@"png"];
            backgroundImage = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:kTokenFieldCellStretchCap topCapHeight:kTokenFieldCellStretchCap];
            
            textColor = [UIColor blackColor];
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
