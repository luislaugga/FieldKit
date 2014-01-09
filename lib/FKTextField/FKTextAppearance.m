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
        color = [[UIColor alloc] initWithRed:0.25882352941176 green:0.41960784313725 blue:0.96470588235294 alpha:1.0]; // rgb = (66,107,246), a = 100%
    }
    return color;
}

+ (UIColor *)defaultSelectionRangeColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:0.0078431372549 green:0.34117647058824 blue:0.65098039215686 alpha:0.2]; // rgb = (2,87,166), a = 20%
    }    
    return color;
}

+ (UIColor *)defaultMarkedTextRangeColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:0.15]; // rgb = (255,0,0), a = 15%
    }
    return color;
}

+ (UIColor *)defaultSelectionGrabberColor
{
    static UIColor *color = nil;
    if (color == nil) {
        color = [[UIColor alloc] initWithRed:0.07843137254902 green:0.43529411764706 blue:0.88235294117647 alpha:1.0]; // rgb = (20,111,225), a = 100%
    }    
    return color;
}

#pragma mark -
#pragma mark Frames

#define kFKTextAppearanceSelectionCaretWidth 2

+ (CGRect)selectionCaretFrameForTextRect:(CGRect)textRect
{
    return CGRectMake(textRect.origin.x, textRect.origin.y, kFKTextAppearanceSelectionCaretWidth, textRect.size.height);
}

#define kFKTextAppearanceMarkedTextWidthOffset 1
#define kFKTextAppearanceMarkedTextHeightOffset 4

+ (CGRect)markedTextFrameForTextRect:(CGRect)textRect
{
    return CGRectMake(textRect.origin.x, textRect.origin.y-kFKTextAppearanceMarkedTextHeightOffset, textRect.size.width+kFKTextAppearanceMarkedTextWidthOffset, textRect.size.height+kFKTextAppearanceMarkedTextHeightOffset);
}

#define kFKTextAppearanceSelectionGrabberWidth 2
#define kFKTextAppearanceSelectionGrabberHeightOffset 4
#define kFKTextAppearanceSelectionGrabberDotWidth 11


+ (CGRect)selectionGrabberDotFrame
{
    return CGRectMake(0, 0, kFKTextAppearanceSelectionGrabberDotWidth, kFKTextAppearanceSelectionGrabberDotWidth);
}

+ (CGRect)startSelectionGrabberFrameForTextRect:(CGRect)textRect
{
    return CGRectMake(textRect.origin.x-kFKTextAppearanceSelectionGrabberWidth, textRect.origin.y-kFKTextAppearanceSelectionGrabberHeightOffset, kFKTextAppearanceSelectionGrabberWidth, textRect.size.height+kFKTextAppearanceSelectionGrabberHeightOffset);
}

+ (CGRect)endSelectionGrabberFrameForTextRect:(CGRect)textRect
{
    return CGRectMake(textRect.origin.x, textRect.origin.y, kFKTextAppearanceSelectionGrabberWidth, textRect.size.height+kFKTextAppearanceSelectionGrabberHeightOffset);
}

@end
