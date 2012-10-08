//
//  LATextFieldDelegate.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LATextField;

/*!
 @protocol LATextFieldDelegate
 @abstract The LATextFieldDelegate protocol defines the optional methods implemented by delegates of LATextField objects.
 @discussion
 */
@protocol LATextFieldDelegate <NSObject>

@optional

/*!
 @group Responding to Editing Notifications
 */

 /*!
 Allows the delegate to allow editing on becomeFirstResponder.
 @param textField The text field that sent the message.
 @return  return NO to disallow editing 
 */
- (BOOL)textFieldShouldBeginEditing:(LATextField *)textField;

/*!
 became first responder
 */
- (void)textFieldDidBeginEditing:(LATextField *)textField;

/*!
 return YES to allow editing to stop and to resign first responder status
 return NO to disallow the editing 
 */
- (BOOL)textFieldShouldEndEditing:(LATextField *)textField;

/*!
 may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
 */
- (void)textFieldDidEndEditing:(LATextField *)textField;            

/*!
 @group Responding to Text Changes
 */

/*!
 return NO to not change text
 */
- (BOOL)textField:(LATextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


/*!
 Tells the delegate that the text or attributes in the specified text field were changed by the user.
 @param textField The text field containing the changes.
 @discussion
 Implementation of this method is optional. 
 You can use the selectedRange property of the text field to get the new selection.
 */
- (void)textFieldDidChange:(LATextField *)textField;

/*!
 @group Responding to Selection Changes
 */

/*!
 Tells the delegate that the text selection changed in the specified text field.
 @param textField The text view containing the changes.
 @discussion
 The text view calls this method in response to user-initiated changes to the text. 
 This method is not called in response to programmatically initiated changes.
 Implementation of this method is optional.
 */
- (void)textFieldDidChangeSelection:(LATextField *)textField;

/*!
 @group Responding to User Actions
 */

/*!
 called when clear button pressed. return NO to ignore (no notifications)
 */
- (BOOL)textFieldShouldClear:(LATextField *)textField;

/*!
 called when 'return' key pressed. return NO to ignore.
 */
- (BOOL)textFieldShouldReturn:(LATextField *)textField;




@end
