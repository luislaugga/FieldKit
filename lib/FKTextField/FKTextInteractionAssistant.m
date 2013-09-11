/*
 
 FKTextInteractionAssistant.m
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

#import "FKTextInteractionAssistant.h"
#import "FKTextInteractionAssistant_Internal.h"

#import "FKTextSelectionView.h"

@implementation FKTextInteractionAssistant

@synthesize selectingContainer = _selectingContainer;
@synthesize singleTapGesture = _singleTapGesture;
@synthesize doubleTapGesture = _doubleTapGesture;

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
