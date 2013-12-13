/*
 
 FKTextAppearance.m
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
