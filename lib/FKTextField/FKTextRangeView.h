/*
 
 FKTextRangeView.h
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

#import "FKSelectionGrabber.h"

/*!
 @abstract Text Range View
 @discussion 
 View responsible for rendering a range selection 
 of text in the text field during editing mode.
 */
@interface FKTextRangeView : UIView
{
    //    UITextSelectionView *m_selectionView;
    //    UIView<UITextSelectingContainer> *m_container;
    //    int m_mode;
    NSArray * _rects;
    NSMutableArray * _rectViews;
    //    UITouch *m_activeTouch;
    CGRect _startEdge;
    CGRect _endEdge;
    //    struct CGPoint m_basePoint;
    //    struct CGPoint m_extentPoint;
    //    struct CGPoint m_initialBasePoint;
    //    struct CGPoint m_initialExtentPoint;
    //    float m_initialDistance;
    //    struct CGPoint m_touchOffset;
    //    double m_firstMovedTime;
    FKSelectionGrabber * _startGrabber;
    FKSelectionGrabber * _endGrabber;
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
@property(readonly) CGRect startEdge;
@property(strong) FKSelectionGrabber * startGrabber;
@property(readonly) CGRect endEdge;
@property(strong) FKSelectionGrabber * endGrabber;
@property(nonatomic, copy) NSArray * rects;
@property(nonatomic, strong) NSMutableArray * rectViews;

/*!
 Default range view for CGRect factory helper
 */
+ (UIView *)defaultRangeViewForRect:(CGRect)rect;

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

@end

