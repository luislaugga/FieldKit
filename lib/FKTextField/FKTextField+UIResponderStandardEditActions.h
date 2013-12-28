/*
 
 FKTextField+UIResponderStandardEditActions.h
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

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark FKTextField (UIResponderStandardEditActions)

/*!
 @abstract FKTextField UIResponderStandardEditActions informal protocol addition category
 @discussion 
 The UIResponderStandardEditActions informal protocol declares methods that responder classes 
 should override to handle common editing commands invoked in the user interface, such as Copy, Paste, and Select.
 */
@interface FKTextField (UIResponderStandardEditActions) // UIResponderStandardEditActions is an informal protocol

#pragma mark -
#pragma mark Handling Copy, Cut, Delete, and Paste Commands

/*!
 Copy the selection to the pasteboard.
 */
- (void)copy:(id)sender;

/*!
 Remove the selection from the user interface and write it to the pasteboard.
 */
- (void)cut:(id)sender;

/*!
 Read data from the pasteboard and copy into the current text selection.
 */
- (void)paste:(id)sender;

#pragma mark -
#pragma mark Handling Selection Commands

/*!
 Select the next object the user taps.
 */
- (void)select:(id)sender;

/*!
 Select all objects in the current view.
 */
- (void)selectAll:(id)sender;

@end