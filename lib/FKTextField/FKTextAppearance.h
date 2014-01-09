/*
 
 FKTextAppearance.h
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

#import <Foundation/Foundation.h>

@interface FKTextAppearance : NSObject

/*!
 Default text font
 */
+ (UIFont *)defaultFont;

/*!
 Default text color
 */
+ (UIColor *)defaultTextColor;

/*!
 Default background color
 */
+ (UIColor *)defaultBackgroundColor;

/*!
 Default selection caret color
 */
+ (UIColor *)defaultSelectionCaretColor;

/*!
 Default selection range color
 */
+ (UIColor *)defaultSelectionRangeColor;

/*!
 Default marked selection range color
 */
+ (UIColor *)defaultMarkedTextRangeColor;

/*!
 Default selection grabber color
 */
+ (UIColor *)defaultSelectionGrabberColor;

/*!
 Default selection caret rect frame
 */
+ (CGRect)selectionCaretFrameForTextRect:(CGRect)textRect;

/*!
 Default marked text rect frame
 */
+ (CGRect)markedTextFrameForTextRect:(CGRect)textRect;

/*!
 Default selection grabber dot rect frame
 */
+ (CGRect)selectionGrabberDotFrame;

/*!
 Default start selection grabber rect frame
 */
+ (CGRect)startSelectionGrabberFrameForTextRect:(CGRect)textRect;

/*!
 Default end selection grabber rect frame
 */
+ (CGRect)endSelectionGrabberFrameForTextRect:(CGRect)textRect;

@end
