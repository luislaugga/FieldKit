//
//  UIColorTokenFieldCell.m
//  FieldKitOverview
//
//  Created by luis on 10/22/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "UIColorTokenFieldCell.h"

#define kTokenFieldCellInsetLeft 8
#define kTokenFieldCellInsetTop 3
#define kTokenFieldCellStretchCap 12
#define kTokenFieldCellOpacity 1.0

@implementation UIColorTokenFieldCell

- (id)init
{
    self = [super init];
    if(self)
    {
        PrettyLog;
    }
    
    return self;
}

- (NSString *)displayString
{
    UIColor * color = (UIColor *)self.representedObject;
    
	CGFloat r,g,b,a;
	if (![color getRed:&r green:&g blue:&b alpha:&a])
        return 0;
    
	r = MIN(MAX(r, 0.0f), 1.0f);
	g = MIN(MAX(g, 0.0f), 1.0f);
	b = MIN(MAX(b, 0.0f), 1.0f);
    
	uint32_t rgb = (((int)roundf(r * 255)) << 16) | (((int)roundf(g * 255)) << 8) | (((int)roundf(b * 255)));
    
    return [NSString stringWithFormat:@"%0.6x%0.2x", rgb, ((int)(a*255))];
}

- (UIColor *)selectedBackgroundColor
{
    UIColor * backgroundColor = (UIColor *)self.representedObject;
    
    CGFloat h,s,b,a;
	if ([backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a])
    {
        return [UIColor colorWithHue:h saturation:s brightness:b*0.8 alpha:a];
    }
  
    return [UIColor clearColor];
}

- (void)setRepresentedObject:(id)representedObject
{
    PrettyLog;
    
    super.representedObject = representedObject;
    
    NSString * displayString = [self displayString];
    
    Log(@"displayString %@", displayString);
    
    CGSize textSize = [displayString sizeWithFont:self.font];
    _size = CGSizeMake(kTokenFieldCellInsetLeft + textSize.width + kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop + textSize.height + kTokenFieldCellInsetTop);
    
    self.frame = CGRectMake(0, 0, _size.width, _size.height);
    self.text = displayString; // copy
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * textColor;
    UIFont * textFont;
    CGPoint textPoint;
    
    textColor = [UIColor blackColor];
    textFont = _font;
    textPoint = CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop);
    
    // Draw background image
    if(self.selected)
        CGContextSetFillColorWithColor(context, [self selectedBackgroundColor].CGColor);
    else
        CGContextSetFillColorWithColor(context, ((UIColor *)self.representedObject).CGColor);

    CGContextFillRect(context, self.bounds);
    
    // Draw text
    [textColor setFill];
    [_text drawAtPoint:textPoint withFont:textFont];
}

@end
