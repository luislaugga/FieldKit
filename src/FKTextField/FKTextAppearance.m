//
//  FKTextAppearance.m
//  FieldKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "FKTextAppearance.h"

@implementation FKTextAppearance

#pragma mark -
#pragma mark Defaults

+ (UIFont *)defaultFont
{
    return [UIFont systemFontOfSize:12];
}

+ (UIColor *)defaultTextColor
{
    return [UIColor blackColor];
}

+ (UIColor *)defaultBackgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)defaultSelectionCaretColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:0.20 green:0.37 blue:0.95 alpha:0.95];
    }
    return color;
}

+ (UIColor *)defaultSelectionRangeColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:0.20 green:0.36 blue:0.65 alpha:0.20];    
    }    
    return color;
}

+ (UIColor *)defaultSelectionGrabberColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:0.20 green:0.36 blue:0.65 alpha:0.20];    
    }    
    return color;
}

#pragma mark -
#pragma mark Frames

#define kFKTextAppearanceCaretWidth 3

+ (CGRect)selectionCaretFrameForTextRect:(CGRect)textRect
{
    return CGRectMake(textRect.origin.x, textRect.origin.y, kFKTextAppearanceCaretWidth, textRect.size.height);
}

@end
