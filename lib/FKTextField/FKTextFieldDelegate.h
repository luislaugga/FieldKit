/*
 
 FKTextFieldDelegate.h
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
