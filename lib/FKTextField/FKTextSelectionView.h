/*
 
 FKTextSelectionView.h
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

#import "FKTextSelecting.h"

#import "FKTextCaretView.h"
#import "FKTextRangeView.h"
#import "FKTextLoupeMagnifierView.h"
#import "FKTextRangeMagnifierView.h"

/*!
 @abstract Text Selection Change Type
 @discussion
 The selection change is an operation initiated by a user interaction. 
 At the beginning of the operation the selection view will test which
 type of selection change should be performed. The type is stored and
 used until the selection change operation ends.
 */
typedef enum {
    FKTextSelectionChangeNone,
    FKTextSelectionChangeCaret, // caret selection change
    FKTextSelectionChangeStartGrabber, // range selection change
    FKTextSelectionChangeEndGrabber // range selection change
} FKTextSelectionChange;

/*!
 @abstract Text Selection View
 @discussion 
 View responsible for rendering selection (caret or range)
 */
@interface FKTextSelectionView : UIView
{
    UIView<FKTextSelectingContainer> * __unsafe_unretained _selectingContainer;
    
    NSRange _markedTextRange; // current marked text range (the selectedTextRange always occurs within the marked text)
    NSRange _selectedTextRange; // current selection range (caret if length is 0)
    
    FKTextSelectionChange _selectionChange; // current selection change type
    CGPoint _selectionChangeBeginPoint; // current selection change begin point
    
    NSInteger _selectionChangeTextLocation; // selection change location for text range when insertTextIntoSelection: or deleteTextFromSelection is called
    NSInteger _selectionChangeTextLength; // selection change length (positive or negative) for text range when insertTextIntoSelection: or deleteTextFromSelection is called
    
    FKTextCaretView * _caretView; // caret view
    FKTextRangeView * _rangeView; // range view
    FKTextLoupeMagnifierView * _loupeMagnifierView; // used with caret
    FKTextRangeMagnifierView * _rangeMagnifierView; // used with range
    
    BOOL _visible; // the selection view is only visible if this flag is set to YES
    BOOL _isSelectionMenuVisible; // when the selection menu is visible this flag is set to YES
}

@property(nonatomic, assign) NSRange markedTextRange;
@property(nonatomic, assign) NSRange selectedTextRange;

@property(nonatomic, assign) NSInteger selectionChangeTextLocation;
@property(nonatomic, assign) NSInteger selectionChangeTextLength; // positive for insert, negative for delete

/*!
 Required initialization method
 Initialize with a given selecting container
 */
- (id)initWithSelectingContainer:(UIView<FKTextSelectingContainer> *)selectingContainer;

/*!
 Updates displayed selection
 */
- (void)updateSelectionIfNeeded;

/*!
 Modify selection: move caret view to index closest to a given point
 */
- (void)setCaretSelectionForPoint:(CGPoint)point;

/*!
 Modify selection: change current selection (caret or range)
 @param point The point to test if a selection change is possible.
 @return YES if the selection change is possible.
 */
- (BOOL)shouldBeginSelectionChangeForPoint:(CGPoint)point;

/*!
 Begins a selection change operation at a given point.
 @param point The point that initiated the selection change.
 */
- (void)beginSelectionChangeForPoint:(CGPoint)point;

/*!
 Changes the selection assuming beginSelectionChangeForPoint: was called
 first with a valid point.
 @param translationPoint A translation CGPoint that represents the translation
 around the point given to beginSelectionChangeForPoint: method.
 */
- (void)changeSelectionForTranslationPoint:(CGPoint)translationPoint;

/*!
 Ends a selection change operation.
 @discussion
 This method will clean up any selection change views or state.
 */
- (void)endSelectionChange;

/*!
 Modify selection: set range view to word closest to a given point
 @param point The point used to find the closest word to select.
 */
- (void)setWordSelectionForPoint:(CGPoint)point;

/*!
 Modify text: append after selection or replace current selection range
 */
- (void)insertTextIntoSelection:(NSString *)insertedText;

/*!
 Modify text: delete all text from current selection range
 */
- (void)deleteTextFromSelection;

/*!
 Modify text: replace text in a given range and change selection range accordingly
 */
- (void)replaceTextInRange:(NSRange)replacementRange withText:(NSString *)replacementText;

@end
