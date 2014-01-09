/*
 
 FKTextField+Spelling.m
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

#import "FKTextField+Spelling.h"
#import "FKTextField+UITextInput.h"

#import "FKTextAppearance.h"

@implementation FKTextField (Spelling)

- (UITextChecker *)textChecker
{
    if(_textChecker == nil)
    {
        _textChecker = [[UITextChecker alloc] init];
        _textCheckerRange = NSMakeRange(NSNotFound, 0);
        _textCheckerMisspelledWords = [[NSMutableArray alloc] init];
        _textCheckerMisspelledWordsRange = NSMakeRange(NSNotFound, 0);
        _textCheckerQueue = dispatch_queue_create("com.laugga.FieldKit.FKTextField_Spelling", DISPATCH_QUEUE_SERIAL);
    }
    
    return _textChecker;
}

- (void)setTextChecker:(UITextChecker *)textChecker
{
    if(textChecker == _textChecker)
    {
        return;
    }
    else if(textChecker == nil)
    {
#if !__has_feature(objc_arc)
        [_textChecker release];
        [_textCheckerMisspelledWords release];
#endif
        _textChecker = nil;
        dispatch_release(_textCheckerQueue);
    }
    else
    {
#if !__has_feature(objc_arc)
        UITextChecker * _previous_textChecker = _textChecker;
        _textChecker = [textChecker retain];
        [_previous_textChecker release];
#else
        _textChecker = textChecker;
#endif
    }
}

/*!
 Spell check the text using UITextChecker
 */
- (void)spellCheck
{
    // Setup
    NSString * text = _contentView.text;
    UITextChecker * textChecker = self.textChecker;
    
    dispatch_async(_textCheckerQueue, ^{
        PrettyLog;
        
        // Update offset
        NSRange textRange = _textCheckerRange;
        if(textRange.location == NSNotFound)
        {
            textRange.location = 0;
            textRange.length = text.length;
        }
        
        // Language
        NSString * language = [[UITextChecker availableLanguages] objectAtIndex:0];
        if (!language)
        {
            language = @"en_US";
        }
        
        // Loop
        NSArray * guesses;
        BOOL done = NO;
        NSRange currentRange = NSMakeRange(NSNotFound, 0);
        NSUInteger currentOffset = 0;
        while (!done)
        {
            currentRange = [textChecker rangeOfMisspelledWordInString:text range:textRange startingAt:currentOffset wrap:NO language:language];
            
            Log(@"currentRange [%d, %d]", currentRange.location, currentRange.length);
            
            if (currentRange.location == NSNotFound || currentOffset >= currentRange.length)
            {
                done = YES;
                continue;
            }
            
            guesses = [self.textChecker guessesForWordRange:currentRange inString:text language:language];
            
            if(_textCheckerMisspelledWordsRange.location == NSNotFound)
                _textCheckerMisspelledWordsRange = NSMakeRange(text.length-1, 0);
            
            _textCheckerMisspelledWordsRange = NSUnionRange(_textCheckerMisspelledWordsRange, currentRange);
            Log(@"_textCheckerMisspelledWordsRange [%d, %d]", _textCheckerMisspelledWordsRange.location, _textCheckerMisspelledWordsRange.length);
            
            [_textCheckerMisspelledWords addObject:[FKTextCheckerMisspelledWord textCheckerMisspelledWordWithNSRange:currentRange andGuesses:guesses]];
            
            currentOffset = currentOffset + (currentRange.length);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView<FKTextSelectingContainer> * selectingContainer = self;
            
            if(_textCheckerMisspelledWordsView == nil)
            {
                _textCheckerMisspelledWordsView = [[UIView alloc] initWithFrame:self.frame];
                [self addSubview:_textCheckerMisspelledWordsView];
            }
            
            if([_textCheckerMisspelledWords count])
            {
                for(FKTextCheckerMisspelledWord * misspelledWord in _textCheckerMisspelledWords)
                {
                    if(misspelledWord.view == nil)
                    {
                        CGRect textFirstRect = [selectingContainer.textContentView textFirstRectForRange:misspelledWord.range];
                        CGRect viewRect = [self convertRect:textFirstRect fromView:_contentView];
                        UIView * misspelledWordView = [[UIView alloc] initWithFrame:viewRect];
                        misspelledWordView.backgroundColor = [FKTextAppearance defaultMarkedTextRangeColor];
                        [_textCheckerMisspelledWordsView addSubview:misspelledWordView];
                        misspelledWord.view = misspelledWordView;
#if !__has_feature(objc_arc)
                        [misspelledWordView release];
#endif
                    }
                    else
                    {
                        CGRect textFirstRect = [selectingContainer.textContentView textFirstRectForRange:misspelledWord.range]; // Update view
                        CGRect viewRect = [self convertRect:textFirstRect fromView:_contentView];
                        misspelledWord.view.frame = viewRect;
                    }
                }
            }
        });
    });
}

- (void)updateMisspelledWords
{
    UIView<FKTextSelectingContainer> * selectingContainer = self;
    
    NSInteger selectionChangeTextLocation = _selectionView.selectionChangeTextLocation;
    NSInteger selectionChangeTextLength = _selectionView.selectionChangeTextLength;
    
    NSRange selectionChangeTextRange;
    if(selectionChangeTextLength > 0)
        selectionChangeTextRange = NSMakeRange(selectionChangeTextLocation, selectionChangeTextLength);
    else
        selectionChangeTextRange = NSMakeRange(selectionChangeTextLocation-selectionChangeTextLength-1, -selectionChangeTextLength);
    
    for(FKTextCheckerMisspelledWord * misspelledWord in _textCheckerMisspelledWords)
    {
        // Check if misspelled words has view
        if(misspelledWord.view != nil)
        {
            // Check if misspelled word intersects change and remove it
            if(NSIntersectionRange(misspelledWord.range, selectionChangeTextRange).length > 0)
            {
                // mark for removal
                dispatch_async(dispatch_get_main_queue(), ^{
                    [misspelledWord.view removeFromSuperview];
                    [_textCheckerMisspelledWords removeObject:misspelledWord];
                });
            }
            // Check if misspelled words was affected by selection change
            else if(misspelledWord.range.location >= selectionChangeTextLocation)
            {
                misspelledWord.range = NSMakeRange(misspelledWord.range.location+selectionChangeTextLength, misspelledWord.range.length);
                CGRect textRect = [selectingContainer.textContentView textFirstRectForRange:misspelledWord.range];
                CGRect markedTextRect = [FKTextAppearance markedTextFrameForTextRect:textRect];
                CGRect viewRect = [self convertRect:markedTextRect fromView:_contentView];
                misspelledWord.view.frame = viewRect;
            }
        }
    }
}

@end

#pragma mark -
#pragma mark FKTextCheckerMisspelledWord

@implementation FKTextCheckerMisspelledWord

@synthesize view=_view;
@synthesize range=_range;
@synthesize guesses=_guesses;

+ (FKTextCheckerMisspelledWord *)textCheckerMisspelledWordWithNSRange:(NSRange)range andGuesses:(NSArray *)guesses
{
    Log(@"FKTextCheckerMisspelledWord [%d, %d] %@", range.location, range.length, guesses);
    
    FKTextCheckerMisspelledWord * textCheckerMisspelledWord = [[FKTextCheckerMisspelledWord alloc] init];
    textCheckerMisspelledWord.range = range;
    textCheckerMisspelledWord.guesses = guesses;
    
#if !__has_feature(objc_arc)
    return [textCheckerMisspelledWord autorelease];
#else
    return textCheckerMisspelledWord;
#endif
}

@end