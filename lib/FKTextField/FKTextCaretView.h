/*
 
 FKTextCaretView.h
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

#import <UIKit/UIKit.h>

/*!
 @abstract Text Caret View
 @discussion 
 View responsible for rendering a caret in
 the text field during editing mode.
 */
@interface FKTextCaretView : UIView
{
    NSTimer * _blinkTimer;
    BOOL _blink;
}
@property (nonatomic, strong) NSTimer * blinkTimer;
@property (nonatomic) BOOL blink;

/*!
 Default caret view factory helper
 @return FKTextCaretView instance, initialized with pre-defined values from FKTextAppearance.
 */
+ (FKTextCaretView *)defaultCaretView;

/*!
 Tests if a given point is inside the caret draggable area
 rectangle
 @discussion
 The draggable rectangle size is an area
 around the caret view frame.
 @param point The point to test.
 @return YES if the draggable rectangle contains the point (CGRectContainsPoint).
 */
- (BOOL)pointCanDrag:(CGPoint)point;

/*!
 Shows the caret view.
 @discussion
 Turns hidden property of UIView to NO.
 */
- (void)show;

/*!
 Hides the caret view.
 @discussion
 Turns hidden property of UIView to YES.
 */
- (void)hide;

/*!
 Updates the caret view position.
 @param textRect The CGRect must contain the position and text line-height information.
 @discussion
 The text caret view frame is updated based on the given textRect and pre-defined caret width.
 */
- (void)update:(CGRect)textRect;

/*!
 Reset the caret blink timer.
 @discussion
 The caret view is shown and after a pre-defined delay it starts blinking again.
 */
- (void)touch;

@end
