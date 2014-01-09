/*
 
 FKTextInteractionAssistant_Internal.h
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

#import "FKTextInteractionAssistant.h"

#pragma mark -
#pragma mark FKTextInteractionAssistant internal class extension

/*!
 @category FKTextInteractionAssistant internal extension
 */
@interface FKTextInteractionAssistant ()

@property(nonatomic, unsafe_unretained) UIView<FKTextSelectingContainer> * selectingContainer;
@property(nonatomic, strong) UITapGestureRecognizer * singleTapGesture; // @synthesize singleTapGesture = _singleTapGesture;
@property(nonatomic, strong) UITapGestureRecognizer * doubleTapGesture; // @synthesize doubleTapGesture = _doubleTapGesture;
@property(nonatomic, strong) UIPanGestureRecognizer * dragGesture; // @synthesize dragGesture = _dragGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer * longPressureGesture; // @synthesize longPressureGesture = _longPressureGesture;

/*! 
 Action method for single-tap UITapGestureRecognizer
 */
- (void)userDidSingleTap:(UITapGestureRecognizer *)singleTapGesture;

/*! 
 Action method for double-tap UITapGestureRecognizer
 */
- (void)userDidDoubleTap:(UITapGestureRecognizer *)doubleTapGesture;

@end
