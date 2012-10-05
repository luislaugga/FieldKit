//
//  LATokenField.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextField.h"

#import "LATokenFieldDelegate.h"
#import "LATokenFieldCell.h"

/*!
 @abstract Text Field
 @discussion 
 The text field is a view used for text input.
 It conforms to UITextInput (and UIKeyInput) protocols and also NSCoding
 
 Accessing the 'text' property will return only the current editing string, if any. In order to set the tokens
 the property 'representedObjects' should be used instead.
 */
@interface LATokenField : LATextField
{
    NSCharacterSet * _tokenizingCharacterSet; // default is newline
    
    NSTimeInterval _completionDelay; // delay before display completion view
    UIView * _completionSuperview; // host UIView for completion view
    
    NSMutableArray * _tokenFieldCells;
    LATokenFieldCell * _selectedTokenFieldCell;
    
    LATokenStyle _tokenStyle; // LATokenFieldCell style
}

/*!
 Sets the set of tokenizing characters
 If not set, the default character set will be used
 */
@property(nonatomic, copy) NSCharacterSet * tokenizingCharacterSet;

/*!
 List of objects being represented by tokens
 If these objects are not strings, the token field queries its delegate for the strings to display for the represented objects
 */
@property(nonatomic, copy) NSArray * representedObjects;

/*!
 Sets the auto-completion delay before the list of possible completions automatically pops up.  
 Completions are only offered if the delegate implements the completion delegate API.  
 A negative delay will disable completion while a delay of 0.0 will make completion UI presentation immediate.
 */
@property(nonatomic, assign) NSTimeInterval completionDelay;

/*!
 Sets the auto-completion view where the list of possible completions is placed, together with the input field  
 The view should take as much space in the screen as possible, such as a UIViewController root view
 This value can't be nil.
 */
@property(nonatomic, assign) UIView * completionSuperview;

/*!
 Sets the default token style used for each token
 If the delegate implements tokenField:styleForRepresentedObject:, that return value will be used instead
 */
@property(nonatomic, assign) LATokenStyle tokenStyle;

/*!
 In addition to LATokenFieldDelagate protocol, the delegate must also conform to LATextFieldDelegate
 */
@property(nonatomic, assign) id<LATokenFieldDelegate> delegate;

/*!
 Returns the default completion delay interval in seconds
 */
+ (NSTimeInterval)defaultCompletionDelay;

/*!
 Returns the default set to tokenizing characters
 */
+ (NSCharacterSet *)defaultTokenizingCharacterSet;

@end
