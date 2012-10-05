//
//  ScrollFieldDelegate.h
//  ScrollField
//
//  Created by Luis Laugga on 9/11/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAScrollField;

@protocol LAScrollFieldDelegate <NSObject>

@optional
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)scrollFieldDidBeginEditing:(LAScrollField *)scrollField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)scrollFieldDidEndEditing:(LAScrollField *)scrollField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
//
- (BOOL)scrollField:(LAScrollField *)scrollField shouldChangeHeight:(CGFloat)height;
- (void)scrollField:(LAScrollField *)scrollField willChangeHeight:(CGFloat)height;
- (void)scrollField:(LAScrollField *)scrollField didChangeHeight:(CGFloat)height;

@end
