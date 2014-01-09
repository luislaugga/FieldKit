/*
 
 FKTextInteractionAssistant.m
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
#import "FKTextInteractionAssistant_Internal.h"

#import "FKTextSelectionView.h"

@implementation FKTextInteractionAssistant

@synthesize selectingContainer = _selectingContainer;
@synthesize singleTapGesture = _singleTapGesture;
@synthesize doubleTapGesture = _doubleTapGesture;
@synthesize dragGesture = _dragGesture;
@synthesize longPressureGesture = _longPressureGesture;

#pragma mark -
#pragma Initialization

- (id)initWithSelectingContainer:(UIView<FKTextSelectingContainer> *)selectingContainer
{
    self = [super init];
    if(self)
    {
        // Assign the FKTextSelectingContainer conforming UIView
        self.selectingContainer = selectingContainer;
        
        // Set up single tap gesture
        UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:singleTapGesture];
        self.singleTapGesture = singleTapGesture;
        
        // Set up double tap gesture
        UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:doubleTapGesture];
        self.doubleTapGesture = doubleTapGesture;

        // Set up drag gesture recognizer
        UIPanGestureRecognizer * dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidDrag:)];
        dragGesture.minimumNumberOfTouches = 1;
        dragGesture.maximumNumberOfTouches = 1;
        dragGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:dragGesture];
        self.dragGesture = dragGesture;
        
        // Set up long press gesture recognizer
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userDidLongPress:)];
        longPressGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:longPressGesture];
        self.longPressureGesture = longPressGesture;
        
#if !__has_feature(objc_arc)
        [singleTapGesture release];
        [doubleTapGesture release];
        [dragGesture release];
        [longPressGesture release];
#endif
    }
    return self;
}

- (void)dealloc
{
    // Clean up
#if !__has_feature(objc_arc)
    self.singleTapGesture = nil;
    self.doubleTapGesture = nil;
    self.dragGesture = nil;
    self.longPressureGesture = nil;
#endif
    self.selectingContainer = nil;
    
}

#pragma mark -
#pragma mark Single Tap

- (void)userDidSingleTap:(UITapGestureRecognizer *)singleTapGesture
{
    // Proceed if responder is editable
    if([_selectingContainer.responder isEditable])
    {
        // Make container's responder the first responder
        [_selectingContainer.responder becomeFirstResponder];
    
        // Send tap to selection view
        [_selectingContainer.textSelectionView setCaretSelectionForPoint:[singleTapGesture locationInView:_selectingContainer.textSelectionView]];
    }
}

#pragma mark -
#pragma mark Double Tap

- (void)userDidDoubleTap:(UITapGestureRecognizer *)doubleTapGesture
{
    // Send tap to selection view
    [_selectingContainer.textSelectionView setWordSelectionForPoint:[doubleTapGesture locationInView:_selectingContainer.textSelectionView]];
}

#pragma mark -
#pragma mark Drag

- (void)userDidDrag:(UIPanGestureRecognizer *)dragGesture
{
    switch (dragGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // Begin selection change, send drag location to selection view
            [_selectingContainer.textSelectionView beginSelectionChangeForPoint:[dragGesture locationInView:_selectingContainer]];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // Send translation point to selection view
            [_selectingContainer.textSelectionView changeSelectionForTranslationPoint:[dragGesture translationInView:_selectingContainer.textSelectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            // End selection change
            [_selectingContainer.textSelectionView endSelectionChange];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Long Press

- (void)userDidLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // Begin selection change, send long press location to selection view
            [_selectingContainer.textSelectionView beginSelectionChangeForPoint:[longPressGesture locationInView:_selectingContainer]];
        }
            break;
        case UIGestureRecognizerStateChanged:
            // ignore (check userDidDrag:)
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            // End selection change
            [_selectingContainer.textSelectionView endSelectionChange];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer == self.singleTapGesture) // Always accept single-tap
        return YES;
    
    if(_selectingContainer.responder.isEditing)
    {
        if(gestureRecognizer == self.doubleTapGesture) // Only accept double-tap while editing
            return YES;

        if(gestureRecognizer == self.longPressureGesture) // Only accept long-press while editing, check with selection view first
            return [_selectingContainer.textSelectionView shouldBeginSelectionChangeForPoint:[gestureRecognizer locationInView:_selectingContainer.textSelectionView]];
    
        if(gestureRecognizer == self.dragGesture) // Only accept dragging while editing, check with selection view first
            return [_selectingContainer.textSelectionView shouldBeginSelectionChangeForPoint:[gestureRecognizer locationInView:_selectingContainer.textSelectionView]];
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([_selectingContainer.textContentView hitTest:[touch locationInView:_selectingContainer.textContentView] withEvent:nil] == nil)
        return NO;
    
    if(gestureRecognizer == self.doubleTapGesture && _selectingContainer.responder.isEditing == NO)
        return NO; // Only accept double-tap while editing
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == self.dragGesture && otherGestureRecognizer == self.longPressureGesture)
        return YES; // Accept both long-press and dragging (selection change state)
    
    return NO;
}

@end
