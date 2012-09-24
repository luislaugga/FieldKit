//
//  LATokenFieldDelegate.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LATokenFieldCell.h"
@class LATokenField;

@protocol LATokenFieldDelegate <LATextFieldDelegate>

@optional

/*!
 Each element in the array should be an NSString or an array of NSStrings.
 substring is the partial string that is being completed.  tokenIndex is the index of the token being completed.
 selectedIndex allows you to return by reference an index specifying which of the completions should be selected initially. 
 The default behavior is not to have any completions.
 */
- (NSArray *)tokenField:(LATokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex;

/*!
 return an array of represented objects you want to add.
 If you want to reject the add, return an empty array.
 returning nil will cause an error.
 */
- (NSArray *)tokenField:(LATokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index;

/*!
 If you return nil or don't implement these delegate methods, we will assume
 editing string = display string = represented object
 */
- (NSString *)tokenField:(LATokenField *)tokenField displayStringForRepresentedObject:(id)representedObject;
- (NSString *)tokenField:(LATokenField *)tokenField editingStringForRepresentedObject:(id)representedObject;
- (id)tokenField:(LATokenField *)tokenField representedObjectForEditingString: (NSString *)editingString;

/*!
 We put the string on the pasteboard before calling this delegate method. 
 By default, we write the NSStringPboardType as well as an array of NSStrings.
 */
//- (BOOL)tokenField:(LATokenField *)tokenField writeRepresentedObjects:(NSArray *)objects toPasteboard:(NSPasteboard *)pboard;

/*!
 Return an array of represented objects to add to the token field.
 */
//- (NSArray *)tokenField:(LATokenField *)tokenField readFromPasteboard:(NSPasteboard *)pboard;

/*!
 By default the tokens have no menu.
 */
//- (NSMenu *)tokenField:(LATokenField *)tokenField menuForRepresentedObject:(id)representedObject;
- (BOOL)tokenField:(LATokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject; 

/*!
 This method allows you to change the style for individual tokens as well as have mixed text and tokens.
 */
- (LATokenStyle)tokenField:(LATokenField *)tokenField styleForRepresentedObject:(id)representedObject;

@end
