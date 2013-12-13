/*
 
 FKTextSelecting.h
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

@class FKTextInteractionAssistant;
@class FKTextSelectionView;

#pragma mark -
#pragma mark FKTextSelectingResponder

@protocol FKTextSelectingResponder <UITextInput>

@property(readonly, nonatomic, getter=isEditing) BOOL editing;
@property(readonly, nonatomic, getter=isEditable) BOOL editable;

@end

#pragma mark -
#pragma mark FKTextSelectingContent

@protocol FKTextSelectingContent
@property(nonatomic, copy) NSString * text;
//- (struct CGRect)visibleBounds;
//- (void)setBaseWritingDirection:(int)arg1;
//- (void)toggleBaseWritingDirection;
//- (int)selectionBaseWritingDirection;
//- (id)textInDOMRange:(id)arg1;
//- (struct CGRect)closestCaretRectInMarkedTextRangeForPoint:(struct CGPoint)arg1;
//- (void)clearSelection;
//- (void)selectAll;
//- (void)setSelectionToEnd;
//- (void)setSelectionToStart;
//- (id)webVisiblePositionForPoint:(struct CGPoint)arg1;
//- (void)scrollSelectionToVisible:(BOOL)arg1;
//- (void)cancelAutoscroll;
//- (void)startAutoscroll:(struct CGPoint)arg1;
//- (struct CGRect)caretRectForVisiblePosition:(id)arg1;
//- (id)selectionRectsForRange:(id)arg1;
//- (void)setSelectedDOMRange:(id)arg1 affinity:(int)arg2;
//- (id)selectedDOMRange;
//- (unsigned int)offsetInMarkedTextForSelection:(id)arg1;
//- (BOOL)hasMarkedText;

/*!
 Returns offset rect with origin and height for a given text index
 */
- (CGRect)textOffsetRectForIndex:(NSUInteger)index;

/*!
 Return first rect (for the first text line) for a given range
 */
- (CGRect)textFirstRectForRange:(NSRange)range;

/*!
 Returns all rects (one for each text line) for a given range
 */
- (NSArray *)textRectsForRange:(NSRange)range;

/*!
 Returns the text index that is closest to a given point
 */
- (NSUInteger)textClosestIndexForPoint:(CGPoint)point;

/*!
 Returns the range for a word in text that is closer (or even includes) to a given index
 */
- (NSRange)textWordRangeForIndex:(NSUInteger)index;

/*!
 Returns the intersection between two given ranges
 */
- (NSRange)textIntersectionRangeBetweenRange:(NSRange)range andOtherRange:(NSRange)otherRange;

@end

#pragma mark -
#pragma mark FKTextSelectingContainer

@protocol FKTextSelectingContainer

@property(readonly, nonatomic) UIResponder<FKTextSelectingResponder> * responder;
@property(readonly, nonatomic) UIView<FKTextSelectingContent> * textContentView;
@property(readonly, nonatomic) FKTextInteractionAssistant * textInteractionAssistant;
@property(readonly, nonatomic) FKTextSelectionView * textSelectionView;

//- (struct CGRect)selectionClipRect;
//- (void)endSelectionChange;
//- (void)beginSelectionChange;
//
//@optional
//- (BOOL)willInteractWithLinkAtPoint:(struct CGPoint)arg1;
//- (void)startLongInteractionWithLinkAtPoint:(struct CGPoint)arg1;
//- (void)cancelInteractionWithLink;
//- (void)validateInteractionWithLinkAtPoint:(struct CGPoint)arg1;
//- (void)updateInteractionWithLinkAtPoint:(struct CGPoint)arg1;
//- (void)startInteractionWithLinkAtPoint:(struct CGPoint)arg1;
//- (BOOL)isInteractingWithLink;
//- (void)tapLinkAtPoint:(struct CGPoint)arg1;
//- (BOOL)mightHaveLinks;
//- (BOOL)playsNicelyWithGestures;
@end
