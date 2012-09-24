//
//  LATextFieldDelegate.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LATextField;

@protocol LATextFieldDelegate <NSObject>

@optional

/*!
 return NO to disallow editing
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
 return NO to not change text
 */
- (BOOL)textField:(LATextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/*!
 called when clear button pressed. return NO to ignore (no notifications)
 */
- (BOOL)textFieldShouldClear:(LATextField *)textField;

/*!
 called when 'return' key pressed. return NO to ignore.
 */
- (BOOL)textFieldShouldReturn:(LATextField *)textField;

@end
