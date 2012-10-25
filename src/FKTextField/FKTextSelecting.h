/*
 
 FKTextSelecting.h
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
