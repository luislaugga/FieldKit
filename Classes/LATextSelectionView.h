//
//  LATextSelectionView.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LATextSelecting.h"

@class LATextRangeView;

/*!
 @abstract Text Selection View
 @discussion 
 View responsible for rendering selection (caret or range)
 */
@interface LATextSelectionView : UIView
{
    UIView<LATextSelectingContainer> * _selectingContainer;
    
    NSRange _selectionRange;
    NSTimer * _caretTimer;
    UIView * _caretView;
    
    LATextRangeView * _rangeView;
    
    BOOL _caretBlinks;
    BOOL _visible;
}

@property(nonatomic, assign) NSRange selectionRange;

/*!
 Required initialization method
 Initialize with a given selecting container
 */
- (id)initWithSelectingContainer:(UIView<LATextSelectingContainer> *)selectingContainer;


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
