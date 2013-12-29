/*
 
 FKTextField+UITextInput.h
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

#pragma mark -
#pragma mark FKTextField (UITextInput)

/*!
 @abstract FKTextField UITextInput protocol addition category
 @discussion 
 Check UITextInput protocol for the required methods and properties
 */
@interface FKTextField (UITextInput) <UITextInput>
@end

#pragma mark -
#pragma mark FKTextPosition

/*!
 @abstract FKTextPosition is UITextPosition custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextPosition objects 
 for representing specific locations within the text managed by the class
 */
@interface FKTextPosition : UITextPosition {
    NSUInteger _index;
    id <UITextInputDelegate> _inputDelegate;
}

@property (nonatomic) NSUInteger index;

/*!
 Class method to create an instance with a given NSUInteger index
 @return Returns FKTextPosition autoreleased instance
 */ 
+ (FKTextPosition *)textPositionWithIndex:(NSUInteger)index;

@end

#pragma mark -
#pragma mark FKTextRange

/*!
 @abstract FKTextRange is UITextRange custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextRange objects 
 for representing specific ranges within the text managed by the class
 */
@interface FKTextRange : UITextRange {
    NSRange _range;
}

@property (nonatomic) NSRange range;

/*!
 Class method to create an instance with a given NSRange range
 @return Returns FKTextRange autoreleased instance
 */ 
+ (FKTextRange *)textRangeWithNSRange:(NSRange)range;

@end