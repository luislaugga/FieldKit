/*
 
 FKTextField+UITextInput.m
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

#import "FKTextField+UITextInput.h"
#import "FKTextField+Spelling.h"

#import "FKTextAppearance.h"

@implementation FKTextField (UITextInput)

#pragma mark -
#pragma mark UIKeyInput

- (BOOL)hasText 
{
    return ([_contentView.text length] > 0);
}

- (void)insertText:(NSString *)text 
{
    Log(@"insert Text '%@'", text);
    
    // Insert text into selection
    [_selectionView insertTextIntoSelection:text];
    
    // Update spelling marked words
    [self updateMisspelledWords]; // TODO refactor
    
    // Check spelling for every word
    if([text isEqualToString:@" "])
    {
        _textCheckerRange = [_contentView textWordRangeForIndex:_selectionView.selectedTextRange.location-1]; // word range for current selection
        [self spellCheck];
    }
}

- (void)deleteBackward
{
    // Delete text from selection
    [_selectionView deleteTextFromSelection];
    
    // Update spelling marked words
    [self updateMisspelledWords]; // TODO refactor
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
    PrettyLog;
    return [FKTextRange textRangeWithNSRange:_selectionView.selectedTextRange];
}

- (void)setSelectedTextRange:(UITextRange *)range
{
    PrettyLog;
    _selectionView.selectedTextRange = ((FKTextRange *)range).range;
}

- (NSDictionary *)markedTextStyle
{
    Log(@"markedTextStyle {..}");
    return @{UITextInputTextBackgroundColorKey:[FKTextAppearance defaultMarkedTextRangeColor]};
}

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
    // do nothing
    Log(@"setMarkedTextStyle %@", markedTextStyle);
}

- (UITextRange *)markedTextRange
{
    Log(@"markedTextRange [%d, %d]", _selectionView.markedTextRange.location, _selectionView.markedTextRange.length);
    return [FKTextRange textRangeWithNSRange:_selectionView.markedTextRange];
}

- (void)setMarkedTextRange:(UITextRange *)range
{
    Log(@"setMarkedTextRange [%d, %d]", ((FKTextRange *)range).range.location, ((FKTextRange *)range).range.length);
    _selectionView.markedTextRange = NSMakeRange(((FKTextRange *)range).range.location, ((FKTextRange *)range).range.length);
}

- (UITextPosition *)beginningOfDocument
{
    return [FKTextPosition textPositionWithIndex:0];
}

- (UITextPosition *)endOfDocument
{
    return [FKTextPosition textPositionWithIndex:_contentView.text.length];
}

#pragma mark -
#pragma mark Text Manipulation (UITextInput)

/*!
 Methods for manipulating text. 
 */

- (NSString *)textInRange:(UITextRange *)range
{
    return [_contentView.text substringWithRange:((FKTextRange *)range).range];
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)textReplacement
{
    [_selectionView replaceTextInRange:((FKTextRange *)range).range withText:textReplacement];
}

/*!
 Insert the provided text and marks it to indicate that it is part of an active input session.
 */
- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange  // selectedRange is a range within the markedText
{
    Log(@"setMarkedText %@ selectedRange [%d, %d]", markedText, selectedRange.location, selectedRange.length);
    
    NSRange selectedTextRange = _selectionView.selectedTextRange;
    NSRange markedTextRange = _selectionView.markedTextRange;
    
    if (markedTextRange.location != NSNotFound)
    {
        if (!markedText)
            markedText = @"";
		
        // Replace characters in text storage and update markedTextRange length
        [_selectionView replaceTextInRange:markedTextRange withText:markedText];
        markedTextRange.length = markedText.length;
    }
    else if (selectedTextRange.length > 0)
    {
		// There currently isn't a marked text range, but there is a selected range,
		// so replace text storage at selected range and update markedTextRange.
        [_selectionView replaceTextInRange:selectedTextRange withText:markedText];
        markedTextRange.location = selectedTextRange.location;
        markedTextRange.length = markedText.length;
    }
    else
    {
		// There currently isn't marked or selected text ranges, so just insert
		// given text into storage and update markedTextRange.
        [_selectionView insertTextIntoSelection:markedText];
        
        markedTextRange.location = selectedTextRange.location;
        markedTextRange.length = markedText.length;
    }
    
	// Updated selected text range and underlying SimpleCoreTextView
    selectedTextRange = NSMakeRange(selectedRange.location + markedTextRange.location, selectedRange.length);
    _selectionView.markedTextRange = markedTextRange;
    _selectionView.selectedTextRange = selectedTextRange;
}

- (void)unmarkText
{
    PrettyLog;
    
    _selectionView.markedTextRange = NSMakeRange(NSNotFound, 0);
    NSRange markedTextRange = _selectionView.markedTextRange;
    
    if (markedTextRange.location == NSNotFound)
        return;
    
	// unmark the underlying selectionView marked text range
    markedTextRange.location = NSNotFound;
    _selectionView.markedTextRange = markedTextRange;
}

#pragma mark -
#pragma mark Ranges and Positions (UITextInput)

/*!
 Methods for creating ranges and positions.
 */

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    // Generate FKTextPosition instances that wrap the to and from ranges
    FKTextPosition * _fromPosition = (FKTextPosition *)fromPosition;
    FKTextPosition * _toPosition = (FKTextPosition *)toPosition;    
    NSRange range = NSMakeRange(MIN(_fromPosition.index, _toPosition.index), ABS(_toPosition.index - _fromPosition.index));
    return [FKTextRange textRangeWithNSRange:range]; 
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    // Generate FKTextPosition instance, and increment index by offset
    FKTextPosition * _position = (FKTextPosition *)position;    
    NSInteger endIndex = _position.index + offset;
	// Verify position is valid in document
    if (endIndex > _contentView.text.length || endIndex < 0)
        return nil;
    
    return [FKTextPosition textPositionWithIndex:endIndex];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    // Note that this sample assumes LTR text direction
    FKTextPosition * _position = (FKTextPosition *)position;
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
    
    return [FKTextPosition textPositionWithIndex:index];
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)toPosition
{
    FKTextPosition * _position = (FKTextPosition *)position;
    FKTextPosition * _toPosition = (FKTextPosition *)toPosition;
    
	// For this sample, we simply compare position index values
    if (_position.index < _toPosition.index)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
    
    return NSOrderedSame; // textPosition.index == otherTextPosition.index
}

- (NSInteger)offsetFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    FKTextPosition * _fromPosition = (FKTextPosition *)fromPosition;
    FKTextPosition * _toPosition = (FKTextPosition *)toPosition;
    
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
    FKTextRange * _range = (FKTextRange *)range;
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
    return [FKTextPosition textPositionWithIndex:index]; 
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    // Note that this sample assumes LTR text direction
    FKTextPosition * _position = (FKTextPosition *)position;
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
    return [FKTextRange textRangeWithNSRange:range];  
}

/*!
 Return the character offset of a position in a document’s text that falls within a given range.
 */
//- (NSInteger)characterOffsetOfPosition:(UITextPosition *)position withinRange:(UITextRange *)range
//{
//    
//}

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
    FKTextRange * _range = (FKTextRange *)range;    
    CGRect textFirstRect = [_contentView textFirstRectForRange:_range.range];
    return [self convertRect:textFirstRect fromView:_contentView];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    FKTextPosition * _position = (FKTextPosition *)position;
    CGRect textOffsetRect = [_contentView textOffsetRectForIndex:_position.index];
    return CGRectOffset(textOffsetRect, _contentView.frame.origin.x, _contentView.frame.origin.y);
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    Log(@"selectionRectsForRange [%d, %d]", ((FKTextPosition *)range.start).index, ((FKTextPosition *)range.end).index);
    return @[];
}

#pragma mark -
#pragma mark Hit Testing (UITextInput)

/*!
 Hit testing. 
 */

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    NSUInteger index = [_contentView textClosestIndexForPoint:point];
    return [FKTextPosition textPositionWithIndex:index];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
	// Not implemented in this sample.  Could utilize underlying 
	// SimpleCoreTextView:closestIndexToPoint:point
    Log(@"closestPositionToPoint (%f,%f) %@", point.x, point.y, range);
    NSUInteger index = [_contentView textClosestIndexForPoint:point];
    return [FKTextPosition textPositionWithIndex:index];
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
	// Not implemented in this sample.  Could utilize underlying 
	// SimpleCoreTextView:closestIndexToPoint:point
    Log(@"characterRangeAtPoint (%f,%f)", point.x, point.y);
    //NSRange range = [_contentView textWordRangeForIndex:_selectionView.selectedTextRange.location]; // word range for closest index
    //return [FKTextRange textRangeWithNSRange:range];
    NSUInteger index = [_contentView textClosestIndexForPoint:point]; // closest index
    NSRange range = [_contentView textWordRangeForIndex:index]; // word range for closest index
    return [FKTextRange textRangeWithNSRange:range];
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
#pragma mark FKTextPosition implementation

@implementation FKTextPosition 

@synthesize index = _index;

+ (FKTextPosition *)textPositionWithIndex:(NSUInteger)index
{
    FKTextPosition * textPosition = [[FKTextPosition alloc] init];
    textPosition.index = index;
    
#if !__has_feature(objc_arc)
    return [textPosition autorelease];
#else
    return textPosition;
#endif
}

@end

#pragma mark -
#pragma mark FKTextRange implementation

@implementation FKTextRange 

@synthesize range = _range;

+ (FKTextRange *)textRangeWithNSRange:(NSRange)range
{
    if (range.location == NSNotFound)
        return nil;
    
    FKTextRange * textRange = [[FKTextRange alloc] init];
    textRange.range = range;
    
#if !__has_feature(objc_arc)
    return [textRange autorelease];
#else
    return textRange;
#endif
}

/*!
 UITextRange readonly property
 @return Returns start index of range
 */ 
- (UITextPosition *)start
{
    return [FKTextPosition textPositionWithIndex:_range.location];
}

/*!
 UITextRange readonly property
 @return Returns end index of range
 */ 
- (UITextPosition *)end
{
	return [FKTextPosition textPositionWithIndex:(_range.location + _range.length)];
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
