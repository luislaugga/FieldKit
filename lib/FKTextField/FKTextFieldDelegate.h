/*
 
 FKTextFieldDelegate.h
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

#import <Foundation/Foundation.h>

@class FKTextField;

/*!
 @protocol FKTextFieldDelegate
 @abstract The FKTextFieldDelegate protocol defines the optional methods implemented by delegates of FKTextField objects.
 @discussion
 */
@protocol FKTextFieldDelegate <NSObject>

@optional

/*!
 @group Responding to Editing Notifications
 */

 /*!
 Allows the delegate to allow editing on becomeFirstResponder.
 @param textField The text field that sent the message.
 @return  return NO to disallow editing 
 */
- (BOOL)textFieldShouldBeginEditing:(FKTextField *)textField;

/*!
 became first responder
 */
- (void)textFieldDidBeginEditing:(FKTextField *)textField;

/*!
 return YES to allow editing to stop and to resign first responder status
 return NO to disallow the editing 
 */
- (BOOL)textFieldShouldEndEditing:(FKTextField *)textField;

/*!
 may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
 */
- (void)textFieldDidEndEditing:(FKTextField *)textField;            

/*!
 @group Responding to Text Changes
 */

/*!
 return NO to not change text
 */
- (BOOL)textField:(FKTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


/*!
 Tells the delegate that the text or attributes in the specified text field were changed by the user.
 @param textField The text field containing the changes.
 @discussion
 Implementation of this method is optional. 
 You can use the selectedRange property of the text field to get the new selection.
 */
- (void)textFieldDidChange:(FKTextField *)textField;

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
- (void)textFieldDidChangeSelection:(FKTextField *)textField;

/*!
 @group Responding to User Actions
 */

/*!
 called when clear button pressed. return NO to ignore (no notifications)
 */
- (BOOL)textFieldShouldClear:(FKTextField *)textField;

/*!
 called when 'return' key pressed. return NO to ignore.
 */
- (BOOL)textFieldShouldReturn:(FKTextField *)textField;




@end
