/*
 
 FKTextField.h
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
    
    NSDictionary * _markedTextStyle;
    UITextStorageDirection _selectionAffinity;
    id<UITextInputDelegate> _inputDelegate;
    id<UITextInputTokenizer> _tokenizer;
    
    id<FKTextFieldDelegate> _delegate;
}

@property(nonatomic, copy) NSString * text; 
@property(nonatomic, retain) UIColor * textColor; 
@property(nonatomic, retain) UIFont * font;
@property(nonatomic, assign) id<FKTextFieldDelegate> delegate;

@property(nonatomic, readonly, getter=isEditing) BOOL editing;
@property(nonatomic, getter=isEditable) BOOL editable;

//@property(nonatomic) NSRange selectedRange;

@end
