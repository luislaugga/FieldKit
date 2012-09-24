//
//  LATextSelecting.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

@class LATextInteractionAssistant;
@class LATextSelectionView;

#pragma mark -
#pragma mark LATextSelectingContent

@protocol LATextSelection <UITextInput>
//- (id)rectsForRange:(id)arg1;
//
//@optional
//@property(nonatomic) int selectionGranularity;
@end

@protocol LATextSelectingContent
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
#pragma mark LATextSelectingContainer

@protocol LATextSelectingContainer

@property(readonly, nonatomic) UIResponder<UITextInput> * responder;
@property(readonly, nonatomic) UIView<LATextSelectingContent> * contentView;
@property(readonly, nonatomic) LATextInteractionAssistant * interactionAssistant;
@property(readonly, nonatomic) LATextSelectionView * selectionView;

@property(readonly, nonatomic, getter=isEditing) BOOL editing;
@property(readonly, nonatomic, getter=isEditable) BOOL editable;

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
