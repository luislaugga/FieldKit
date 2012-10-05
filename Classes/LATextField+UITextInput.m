//
//  LATextField+UITextInput.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/20/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextField+UITextInput.h"

@implementation LATextField (UITextInput)

#pragma mark -
#pragma mark UIKeyInput

- (BOOL)hasText 
{
    return ([_contentView.text length] > 0);
}

- (void)insertText:(NSString *)text 
{
    [_selectionView insertTextIntoSelection:text];
}

- (void)deleteBackward 
{
    [_selectionView deleteTextFromSelection];
}


#pragma mark -
#pragma mark Properties (UITextInput)

/*!
 Properties
 */

- (id<UITextInputDelegate>)inputDelegate
{
    return _inputDelegate;
}

- (void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate
{
    _inputDelegate = inputDelegate;
}

- (id<UITextInputTokenizer>)tokenizer
{
    if(_tokenizer == nil)
        _tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
                      
    return _tokenizer;
}

- (UIView *)textInputView
{
    return self;
}

- (UITextStorageDirection)selectionAffinity
{
    return _selectionAffinity;
}

- (void)setSelectionAffinity:(UITextStorageDirection)selectionAffinity
{
    _selectionAffinity = selectionAffinity;
}

- (UITextRange *)selectedTextRange
{
    return [LATextRange textRangeWithRange:_selectionView.selectionRange];
}

- (void)setSelectedTextRange:(UITextRange *)range
{
    _selectionView.selectionRange = ((LATextRange *)range).range;
}

- (NSDictionary *)markedTextStyle
{
    return nil;
}

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
    // do nothing
}

- (UITextRange *)markedTextRange
{
    return [LATextRange textRangeWithRange:NSMakeRange(NSNotFound, 0)];
}

- (void)setMarkedTextRange:(UITextRange *)range
{
    // do nothing
}

- (UITextPosition *)beginningOfDocument
{
    return [LATextPosition textPositionWithIndex:0];
}

- (UITextPosition *)endOfDocument
{
    return [LATextPosition textPositionWithIndex:_contentView.text.length];
}

#pragma mark -
#pragma mark Text Manipulation (UITextInput)

/*!
 Methods for manipulating text. 
 */

- (NSString *)textInRange:(UITextRange *)range
{
    return [_contentView.text substringWithRange:((LATextRange *)range).range];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)textReplacement
{
    [_selectionView replaceTextInRange:((LATextRange *)range).range withText:textReplacement];
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange  // selectedRange is a range within the markedText
{
    // do nothing
}

- (void)unmarkText
{
    // do nothing
}

#pragma mark -
#pragma mark Ranges and Positions (UITextInput)

/*!
 Methods for creating ranges and positions.
 */

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    // Generate LATextPosition instances that wrap the to and from ranges
    LATextPosition * _fromPosition = (LATextPosition *)fromPosition;
    LATextPosition * _toPosition = (LATextPosition *)toPosition;    
    NSRange range = NSMakeRange(MIN(_fromPosition.index, _toPosition.index), ABS(_toPosition.index - _fromPosition.index));
    return [LATextRange textRangeWithRange:range]; 
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    // Generate LATextPosition instance, and increment index by offset
    LATextPosition * _position = (LATextPosition *)position;    
    NSInteger endIndex = _position.index + offset;
	// Verify position is valid in document
    if (endIndex > _contentView.text.length || endIndex < 0)
        return nil;
    
    return [LATextPosition textPositionWithIndex:endIndex];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    // Note that this sample assumes LTR text direction
    LATextPosition * _position = (LATextPosition *)position;
    NSInteger index = _position.index;
    
    switch (direction) {
        case UITextLayoutDirectionRight:
            index += offset;
            break;
        case UITextLayoutDirectionLeft:
            index -= offset;
            break;
        UITextLayoutDirectionUp:
        UITextLayoutDirectionDown:
			// This sample does not support vertical text directions
            break;
    }
    
    // Verify new position valid in document
	
    if (index < 0)
        index = 0;
    
    if (index > _contentView.text.length)
        index = _contentView.text.length;
    
    return [LATextPosition textPositionWithIndex:index];
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)toPosition
{
    LATextPosition * _position = (LATextPosition *)position;
    LATextPosition * _toPosition = (LATextPosition *)toPosition;
    
	// For this sample, we simply compare position index values
    if (_position.index < _toPosition.index)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
    
    return NSOrderedSame; // textPosition.index == otherTextPosition.index
}

- (NSInteger)offsetFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    LATextPosition * _fromPosition = (LATextPosition *)fromPosition;
    LATextPosition * _toPosition = (LATextPosition *)toPosition;
    
    return (_toPosition.index - _fromPosition.index);
}

#pragma mark -
#pragma mark Layout (UITextInput)

/*!
 Layout questions. 
 */

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
#warning Note that this sample assumes LTR text direction
    LATextRange * _range = (LATextRange *)range;
    NSInteger index = _range.range.location;
    
	// For this sample, we just return the extent of the given range if the
	// given direction is "forward" in a LTR context (UITextLayoutDirectionRight
	// or UITextLayoutDirectionDown), otherwise we return just the range position
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            index = _range.range.location;
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:            
            index = _range.range.location + _range.range.length;
            break;
    }
    
	// Return text position using our UITextPosition implementation.
	// Note that position is not currently checked against document range.
    return [LATextPosition textPositionWithIndex:index]; 
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    // Note that this sample assumes LTR text direction
    LATextPosition * _position = (LATextPosition *)position;
    NSRange range = NSMakeRange(_position.index, 1);
    
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            range = NSMakeRange(_position.index - 1, 1);
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:            
            range = NSMakeRange(_position.index, 1);
            break;
    }
    
    // Return range using our UITextRange implementation
	// Note that range is not currently checked against document range.
    return [LATextRange textRangeWithRange:range];  
}

#pragma mark -
#pragma mark Writing Direction (UITextInput)

/*!
 Writing direction 
 */

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    // This sample assumes LTR text direction and does not currently support BiDi or RTL.
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
        // This sample assumes LTR text direction and does not currently support BiDi or RTL.
}

#pragma mark -
#pragma mark Geometry (UITextInput)

/*!
 Geometry used to provide, for example, a correction rect.
 */

- (CGRect)firstRectForRange:(UITextRange *)range
{
    LATextRange * _range = (LATextRange *)range;    
    CGRect textFirstRect = [_contentView textFirstRectForRange:_range.range];
    return CGRectOffset(textFirstRect, _contentView.frame.origin.x, _contentView.frame.origin.y);   
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    LATextPosition * _position = (LATextPosition *)position;
    CGRect textOffsetRect = [_contentView textOffsetRectForIndex:_position.index];
    return CGRectOffset(textOffsetRect, _contentView.frame.origin.x, _contentView.frame.origin.y);
}

#pragma mark -
#pragma mark Hit Testing (UITextInput)

/*!
 Hit testing. 
 */

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    NSUInteger index = [_contentView textClosestIndexForPoint:point];
    return [LATextPosition textPositionWithIndex:index];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
	// Not implemented in this sample.  Could utilize underlying 
	// SimpleCoreTextView:closestIndexToPoint:point
    return nil;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
	// Not implemented in this sample.  Could utilize underlying 
	// SimpleCoreTextView:closestIndexToPoint:point
    return nil;
}

#pragma mark -
#pragma mark Optional (UITextInput)

/*!
 Optional
 */

- (NSDictionary *)textStylingAtPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return [NSDictionary dictionaryWithObject:_contentView.font forKey:UITextInputTextFontKey]; // assumes single styled text
}

@end

#pragma mark -
#pragma mark LATextPosition implementation

@implementation LATextPosition 

@synthesize index = _index;

+ (LATextPosition *)textPositionWithIndex:(NSUInteger)index
{
    LATextPosition * textPosition = [[LATextPosition alloc] init];
    textPosition.index = index;
    return [textPosition autorelease];
}

@end

#pragma mark -
#pragma mark LATextRange implementation

@implementation LATextRange 

@synthesize range = _range;

+ (LATextRange *)textRangeWithRange:(NSRange)range
{
    if (range.location == NSNotFound)
        return nil;
    
    LATextRange * textRange = [[LATextRange alloc] init];
    textRange.range = range;
    return [textRange autorelease];
}

/*!
 UITextRange readonly property
 @return Returns start index of range
 */ 
- (UITextPosition *)start
{
    return [LATextPosition textPositionWithIndex:_range.location];
}

/*!
 UITextRange readonly property
 @return Returns end index of range
 */ 
- (UITextPosition *)end
{
	return [LATextPosition textPositionWithIndex:(_range.location + _range.length)];
}

/*!
 UITextRange readonly property
 @return Returns YES if range is zero length
 */ 
-(BOOL)isEmpty
{
    return (_range.length == 0);
}

@end
