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
#import "FKTextLoupeMagnifierView.h"

@class FKTextRangeView;

/*!
 @abstract Text Selection View
 @discussion 
 View responsible for rendering selection (caret or range)
 */
@interface FKTextSelectionView : UIView
{
    UIView<FKTextSelectingContainer> * _selectingContainer;
    
    NSRange _selectionRange;
    
    FKTextCaretView * _caretView;
    FKTextRangeView * _rangeView;
    FKTextLoupeMagnifierView * _loupeMagnifierView;
    
    BOOL _visible;
    BOOL _magnify;
}

@property(nonatomic, assign) NSRange selectionRange;

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
 Modify selection: move caret view to index closest to a given point and show or hide magnifier view
 */
- (void)setCaretSelectionForPoint:(CGPoint)point showMagnifier:(BOOL)showMagnifier;

/*!
 Modify selection: set range view to word closest to a given point
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
