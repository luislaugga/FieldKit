//
//  LATextInteractionAssistant.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextInteractionAssistant.h"
#import "LATextInteractionAssistant_Internal.h"

#import "LATextSelectionView.h"

@implementation LATextInteractionAssistant

@synthesize selectingContainer = _selectingContainer;
@synthesize singleTapGesture = _singleTapGesture;
@synthesize doubleTapGesture = _doubleTapGesture;

#pragma mark -
#pragma Initialization

- (id)initWithSelectingContainer:(UIView<LATextSelectingContainer> *)selectingContainer
{
    self = [super init];
    if(self)
    {
        // Assign the LATextSelectingContainer conforming UIView
        self.selectingContainer = selectingContainer;
        
        // Set up single tap gesture
        UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:singleTapGesture];
        self.singleTapGesture = singleTapGesture;
        [singleTapGesture release];
        
        // Set up double tap gesture
        UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delegate = self;
        [_selectingContainer addGestureRecognizer:doubleTapGesture];
        self.doubleTapGesture = doubleTapGesture;
        [doubleTapGesture release];
    }
    return self;
}

- (void)dealloc
{
    // Clean up
    self.singleTapGesture = nil;
    self.doubleTapGesture = nil;
    self.selectingContainer = nil;
    
    [super dealloc];
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
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    if(gestureRecognizer == self.doubleTapGesture && _selectingContainer.responder.isEditing == NO)
        return NO; // Only accept double-tap while editing
        
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    if([_selectingContainer.textContentView hitTest:[touch locationInView:_selectingContainer.textContentView] withEvent:nil] == NO)
        return NO;
    
    if(gestureRecognizer == self.doubleTapGesture && _selectingContainer.responder.isEditing == NO)
        return NO; // Only accept double-tap while editing
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    
    return NO;
}

@end
