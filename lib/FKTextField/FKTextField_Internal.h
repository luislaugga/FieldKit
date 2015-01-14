/*
 
 FKTextField_Internal.h
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

#import "FKTextField.h"
#import "FKTextSelecting.h"
#import "FKTextContentView.h"
#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#pragma mark -
#pragma mark FKTextField internal class extension

/*!
 @category FKTextField internal extension
 */
@interface FKTextField () <FKTextSelectingContainer>
{
    @protected
    FKTextContentView * _contentView;
    FKTextSelectionView * _selectionView;
    FKTextInteractionAssistant * _interactionAssistant;
    
    UITextChecker * _textChecker; // FKTextField+Spelling
    NSRange _textCheckerRange; // Range pending for spell checking
    dispatch_queue_t _textCheckerQueue;
    NSMutableArray * _textCheckerMisspelledWords;
    NSRange _textCheckerMisspelledWordsRange;
    UIView * _textCheckerMisspelledWordsView;
}

@property(nonatomic, readwrite) BOOL editing;

- (void)showSelectionView:(BOOL)visible;

@end

