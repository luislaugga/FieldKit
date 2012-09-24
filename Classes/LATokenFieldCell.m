//
//  LATokenFieldCell.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenFieldCell.h"

@implementation LATokenFieldCell

@synthesize representedObject = _representedObject;

@synthesize selected = _selected;
@synthesize font = _font;
@synthesize string = _string;

#define kTokenFieldCellInsetLeft 9
#define kTokenFieldCellInsetTop 2

#pragma mark -
#pragma mark Initialization

- (id)initWithString:(NSString *)string andFont:(UIFont *)font;
{
    CGSize stringSize = [string sizeWithFont:font];
    self = [super initWithFrame:CGRectMake(0, 0, kTokenFieldCellInsetLeft + stringSize.width + kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop + stringSize.height + kTokenFieldCellInsetTop)];
    if (self) 
    {
        _selected = NO;
        self.string = string; // copy
        self.font = font; // assign
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.string = nil;
    self.font = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    // Update drawing
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    UIImage * backgroundImage;
    UIColor * textColor;
    
    if(_selected)
    {
        backgroundImage = [[UIImage imageNamed:@"LAFieldKit.bundle/token-atom-selected.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        textColor = [UIColor whiteColor];
    }
    else
    {
        backgroundImage = [[UIImage imageNamed:@"LAFieldKit.bundle/token-atom.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        textColor = [UIColor blackColor];
    }
    
    // Draw background image
    [backgroundImage drawInRect:rect];
    
    // Draw display string
    [textColor setFill];
    [_string drawAtPoint:CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop) withFont:_font];
}

#pragma mark -
#pragma mark Helpers

+ (CGRect)textRectInsetForRect:(CGRect)rect
{
    return CGRectInset(rect, 0, kTokenFieldCellInsetTop);
}

@end
