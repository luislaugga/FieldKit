/*
 
 FKTextSelectionView.h
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

#import <UIKit/UIKit.h>

#import "FKTextSelecting.h"

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
    NSTimer * _caretTimer;
    UIView * _caretView;
    
    FKTextRangeView * _rangeView;
    
    BOOL _caretBlinks;
    BOOL _visible;
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
