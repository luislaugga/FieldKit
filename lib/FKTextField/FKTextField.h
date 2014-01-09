/*
 
 FKTextField.h
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

#import <UIKit/UIKit.h>
#import "FKTextFieldDelegate.h"

/*!
 @abstract Text Field
 @discussion 
 The text field is a view used for text input.
 It conforms to UITextInput (and UIKeyInput) protocols and also NSCoding
 */

@interface FKTextField : UIControl /*, NSCoding>*/
{
    BOOL _editable;
    BOOL _editing;
    
    NSDictionary * _markedTextStyle; // FIXME
    UITextStorageDirection _selectionAffinity;
    
    id<UITextInputDelegate> _inputDelegate; // __unsafe_unretained id<UITextInputDelegate> _inputDelegate;
    id<UITextInputTokenizer> _tokenizer; //

    id<FKTextFieldDelegate> __unsafe_unretained _delegate;
}

@property(nonatomic, copy) NSString * text; 
@property(nonatomic, strong) UIColor * textColor; 
@property(nonatomic, strong) UIFont * font;
@property(nonatomic, unsafe_unretained) id<FKTextFieldDelegate> delegate;

@property(nonatomic, readonly, getter=isEditing) BOOL editing;
@property(nonatomic, getter=isEditable) BOOL editable;

//@property(nonatomic) NSRange selectedRange;

@end
