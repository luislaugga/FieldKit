/*
 
 FKTextSelectionView_Internal.h
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

#import "FKTextSelectionView.h"

#pragma mark -
#pragma mark FKTextSelectionView internal class extension

/*!
 @category FKTextSelectionView internal extension
 */
@interface FKTextSelectionView ()

@property(nonatomic, assign) UIView<FKTextSelectingContainer> * selectingContainer;
@property(nonatomic, retain) UIView * caretView;

/*!
 Default caret view factory helper
 */
+ (UIView *)defaultCaretView;

/*!
 Start caret blinking
 */
- (void)startCaretBlinkIfNeeded; // setup caret timer
- (void)touchCaretBlinkTimer; // reset caret timer fire date
- (void)clearCaretBlinkTimer; // invalidate caret timer
- (void)showCaret; // show
- (void)hideCaret; // hide
- (void)updateCaret; // release caret

/*!
 Caret NSTimer action method
 */
- (void)caretBlinkTimerFired:(id)info;

/*!
 Shows caret view
 */
- (void)showCaret;

/*!
 Hides caret view
 */
- (void)hideCaret;

/*!
 Shows range view
 */
- (void)showRange;

/*!
 Hides range view
 */
- (void)hideRange;

/*!
 Show loupe magnifier view
 */
- (void)showLoupeMagnifier;
- (void)hideLoupeMagnifier;
- (void)updateLoupeMagnifier;

@end

#pragma mark -
#pragma mark FKTextRangeView

/*!
 @abstract FKTextRangeView is used to represent selection range, where length > 0
 @discussion
 */
@interface FKTextRangeView : UIView
{
//    UITextSelectionView *m_selectionView;
//    UIView<UITextSelectingContainer> *m_container;
//    int m_mode;
    NSArray * _rects;
    NSMutableArray * _rectViews;
//    UITouch *m_activeTouch;
//    struct CGRect m_startEdge;
//    struct CGRect m_endEdge;
//    struct CGPoint m_basePoint;
//    struct CGPoint m_extentPoint;
//    struct CGPoint m_initialBasePoint;
//    struct CGPoint m_initialExtentPoint;
//    float m_initialDistance;
//    struct CGPoint m_touchOffset;
//    double m_firstMovedTime;
//    UISelectionGrabber *m_startGrabber;
//    UISelectionGrabber *m_endGrabber;
//    BOOL m_animateUpdate;
//    BOOL m_baseIsStart;
//    BOOL m_commandsWereShowing;
//    BOOL m_inGesture;
//    BOOL m_magnifying;
//    BOOL m_scrolling;
//    BOOL m_scaling;
//    BOOL m_rotating;
//    BOOL m_inputViewIsChanging;
}
@property(nonatomic, copy) NSArray * rects;
@property(nonatomic, retain) NSMutableArray * rectViews;

/*!
 Default range view for CGRect factory helper
 */
+ (UIView *)defaultRangeViewForRect:(CGRect)rect;

@end

#pragma mark -
#pragma mark FKSelectionGrabber

@interface FKSelectionGrabber : UIView
{
//    UISelectionGrabberDot *m_dotView;
//    BOOL m_isDotted;
//    BOOL m_isStart;
//    BOOL m_activeFlattened;
//    BOOL m_alertFlattened;
//    BOOL m_navigationTransitionFlattened;
//    BOOL m_animating;
}
@end

