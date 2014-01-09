/*
 
 FKTextField+Spelling.h
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
#import "FKTextField_Internal.h"

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark FKTextField (Spelling)

/*!
 @abstract FKTextField Spelling category
 @discussion 
 Responsible for spell checking the text.
 */
@interface FKTextField (Spelling) // UIResponderStandardEditActions is an informal protocol

@property (nonatomic, retain) UITextChecker * textChecker;

/*!
 Update the misspelled words's view position
 */
- (void)updateMisspelledWords;

/*!
 Spell-Check the text
 */
- (void)spellCheck;

@end

#pragma mark -
#pragma mark FKTextCheckerMisspelledWord

/*!
 @abstract FKTextCheckerMisspelledWord is a custom class to store misspelled words
 @discussion
 The misspelled word is returned by the UITextChecker.
 */
@interface FKTextCheckerMisspelledWord : NSObject
{
    UIView * __unsafe_unretained _view;
    NSRange _range;
    NSArray * _guesses;
}

@property (nonatomic, unsafe_unretained) UIView * view;
@property (nonatomic) NSRange range;
@property (nonatomic, strong) NSArray * guesses;

/*!
 Class method to create an instance with a given NSRange range and NSArray of word guesses
 @param range The NSRange in the FKTextContentView text NSString
 @param guesses The NSArray of NSStrings with possible word substitutions or nil if none.
 @return Returns FKTextCheckerMisspelledWord autoreleased instance
 */
+ (FKTextCheckerMisspelledWord *)textCheckerMisspelledWordWithNSRange:(NSRange)range andGuesses:(NSArray *)guesses;

@end
