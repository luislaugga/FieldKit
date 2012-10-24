//
//  FKTextField.h
//  FieldKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

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
