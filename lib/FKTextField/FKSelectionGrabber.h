/*
 
 FKSelectionGrabber.h
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

@class FKTextRangeView;

@class FKSelectionGrabberDot; //, UITextRangeView;

/*!
 @abstract Selection Grabber Type
 @discussion
 */
typedef enum {
    FKSelectionStartGrabber,
    FKSelectionEndGrabber
} FKSelectionGrabberType;

@interface FKSelectionGrabber : UIView
{
    int _applicationDeactivationReason;
    BOOL m_activeFlattened;
    BOOL m_alertFlattened;
    BOOL m_animating;
    FKSelectionGrabberDot * _dotView;
    //BOOL m_isDotted;
    BOOL m_navigationTransitionFlattened;
    int m_orientation;
    
    FKSelectionGrabberType _grabberType;
}

@property BOOL activeFlattened;
@property BOOL alertFlattened;
@property BOOL animating;
@property(unsafe_unretained, readonly) FKTextRangeView * hostView;
@property BOOL isDotted;
@property BOOL navigationTransitionFlattened;
@property int orientation;

@property (nonatomic) FKSelectionGrabberType grabberType;

//+ (id)_grabberDot;
//
//- (id)_dotView;
//- (BOOL)activeFlattened;
//- (BOOL)alertFlattened;
//- (BOOL)animating;
//- (BOOL)autoscrolled;
//- (void)canExpandAfterAlert:(id)arg1;
//- (void)canExpandAfterBecomeActive:(id)arg1;
//- (void)canExpandAfterNavigationTransition:(id)arg1;
//- (BOOL)clipDot:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg1;
//- (void)dealloc;
//- (void)didMoveToSuperview;
//- (BOOL)dotIsVisbleInDocument:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg1;
//- (void)drawRect:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg1;
//- (id)hostView;
//- (id)initWithFrame:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg1;
//- (BOOL)inputViewIsChanging;
//- (BOOL)isDotted;
//- (BOOL)isPointedDown;
//- (BOOL)isPointedLeft;
//- (BOOL)isPointedRight;
//- (BOOL)isPointedUp;
//- (BOOL)isRotating;
//- (BOOL)isScaling;
//- (BOOL)isScrolling;
//- (BOOL)isVertical;
//- (void)mustFlattenForAlert:(id)arg1;
//- (void)mustFlattenForNavigationTransition:(id)arg1;
//- (void)mustFlattenForResignActive:(id)arg1;
//- (BOOL)navigationTransitionFlattened;
//- (int)orientation;
//- (void)removeFromSuperview;
//- (void)saveDeactivationReason:(id)arg1;
//- (BOOL)scroller:(id)arg1 fullyContainSelectionRect:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg2;
//- (void)setActiveFlattened:(BOOL)arg1;
//- (void)setAlertFlattened:(BOOL)arg1;
//- (void)setAnimating:(BOOL)arg1;
//- (void)setFrame:(struct CGRect { struct CGPoint { float x_1_1_1; float x_1_1_2; } x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; })arg1;
//- (void)setHidden:(BOOL)arg1;
//- (void)setIsDotted:(BOOL)arg1;
//- (void)setNavigationTransitionFlattened:(BOOL)arg1;
//- (void)setOrientation:(int)arg1;
//- (void)updateDot;

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

@interface FKSelectionGrabberDot : UIView

@end
