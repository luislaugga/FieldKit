/*
 
 FKTextAppearance.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Licensed under a Creative Commons Attribution-ShareAlike 3.0 License;
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://creativecommons.org/licenses/by-sa/3.0/
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
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
