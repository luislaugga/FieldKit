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

@synthesize lighterColor = _lighterColor, darkerColor = _darkerColor;

- (id)init
{
    self = [super init];
    if(self)
    {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)dealloc
{
    self.lighterColor = nil;
    self.darkerColor = nil;
    [super dealloc];
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
    
    return [NSString stringWithFormat:@"#%0.6x", rgb];
}

- (UIColor *)darkerColor
{
    UIColor * backgroundColor = (UIColor *)self.representedObject;
    
    CGFloat h,s,b,a;
	if ([backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a])
    {
        return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
    }
  
    return [UIColor clearColor];
}

- (UIColor *)lighterColor
{
    UIColor * backgroundColor = (UIColor *)self.representedObject;
    
    CGFloat h,s,b,a;
	if ([backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a])
    {
        return [UIColor colorWithHue:h saturation:s*0.3 brightness:b alpha:a];
    }
    
    return [UIColor clearColor];
}

- (void)setRepresentedObject:(id)representedObject
{
    
    
    super.representedObject = representedObject;
    
    self.lighterColor = [self lighterColor];
    self.darkerColor = [self darkerColor];
    
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
    
    textFont = _font;
    textPoint = CGPointMake(kTokenFieldCellInsetLeft, kTokenFieldCellInsetTop);
    
    CGFloat radius = rect.size.height/2;
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGPathAddArc(thePath, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGPathAddArc(thePath, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGPathAddArc(thePath, NULL, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGPathAddArc(thePath, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    CGPathCloseSubpath(thePath);
    
    // Draw background image
    if(self.selected)
    {
        CGContextSetFillColorWithColor(context, _darkerColor.CGColor);
        CGContextSetStrokeColorWithColor(context, _darkerColor.CGColor);
        textColor = [UIColor whiteColor];
        
    }
    else
    {
        CGContextSetFillColorWithColor(context, _lighterColor.CGColor);
        CGContextSetStrokeColorWithColor(context, _darkerColor.CGColor);
        textColor = [UIColor blackColor];
        
    }
    
    CGContextAddPath(context, thePath);
    CGContextClip(context);
    CGContextFillRect(context, self.bounds);
    CGContextAddPath(context, thePath);
    CGContextStrokePath(context);
    
    // Draw text
    [textColor setFill];
    [_text drawAtPoint:textPoint withFont:textFont];
    
    // Cleanup
    CGPathRelease(thePath);
}

@end
