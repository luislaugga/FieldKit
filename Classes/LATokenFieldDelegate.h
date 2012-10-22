//
//  LATokenFieldDelegate.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LATextFieldDelegate.h"
#import "LATokenFieldCell.h"

@class LATokenField;

/*!
 NSDictionary keys for tokenField:completionsForSubstring:indexOfToken: returned completions and
 tokenField:representedObjectForEditingDictionary: editing completion
 */
static const NSString * LATokenFieldCompletionDictionaryText = @"0";
static const NSString * LATokenFieldCompletionDictionaryDetailDescription = @"1";
static const NSString * LATokenFieldCompletionDictionaryDetailText = @"2";

/*!
 @protocol LATokenFieldDelegate
 @abstract The LATokenFieldDelegate protocol defines the optional methods implemented by delegates of LATokenField objects.
 @discussion
 1. As the user types the delegate can provide a list of completions via tokenField:completionsForSubstring:indexOfToken:
 2. The user can pick a completion from the list or continue typing up until a tokening character
 3. Once an editing string is set (from 2.) the delegate can provide a represented object via representedObjectForEditingString: 
 4. If 3. succeeds the delegate can also provide a display string via tokenField:displayStringForRepresentedObject:
 5. If 3. or 4. fail the editing string is used as display string for token cells.
 
 Notes:
 - If the represented object is an NSString instance the token field uses it directly as display string.
 - It is also possible to provide NSDictionary completions on tokenField:completionsForSubstring:indexOfToken: for
 multi-attribute case scenarios (ie. Person with multiple contacts and a completion for each contact). In this case,
 the editing string picked from a completion list can either be a NSString or NSDictionary instance. The delegate must
 implement tokenField:representedObjectForEditingString: and/or tokenField:representedObjectForEditingDictionary: 
 depending on the type of completions provided.
 */
@protocol LATokenFieldDelegate <LATextFieldDelegate>

@optional

/*!
 @group Displaying Token
 */

/*!
 This method allows you to change the style for individual tokens as well as have mixed text and tokens.
 */
- (LATokenStyle)tokenField:(LATokenField *)tokenField styleForRepresentedObject:(id)representedObject;

/*!
 Allows the delegate to provide a string to be displayed as a proxy for the given represented object.
 @param tokenField The token field that sent the message.
 @param representedObject A represented object of the token field.
 @return The string to be used as a proxy for representedObject. 
 @discussion If you return nil or do not implement this method, then representedObject is displayed as the string.
 */
- (NSString *)tokenField:(LATokenField *)tokenField displayStringForRepresentedObject:(id)representedObject;

/*!
 Allows the delegate to provide a LATokenFieldCell subclass for a specific represented object.
 @param tokenField The token field that sent the message.
 @param representedObject A represented object of the token field.
 @return The LATokenFieldCell subclass to be used as a proxy for representedObject.
 @discussion If you return nil or do not implement this method, then LATokenFieldCell will be used.
 */
- (LATokenFieldCell *)tokenField:(LATokenField *)tokenField cellForRepresentedObject:(id)representedObject;

/*!
 @group Editing Token
 */

/*!
 Allows the delegate to provide an array of appropriate completions for the contents of the receiver.
 @param tokenField The token field where editing is occurring.
 @param substring The partial string that is to be completed.
 @param tokenIndex The index of the token being edited.
 @return An array of editing NSString or NSDictionary that are possible completions. 
 @discussion If the delegate does not implement this method, no completions are provided.
 */
- (NSArray *)tokenField:(LATokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex;

/*!
 Allows the delegate to provide a represented object for the given editing string.
 @param editingString The editing string picked from the list of completions or typed by the user followed by a tokenizer character.
 @return A represented object that is displayed rather than the editing string.
 */
- (id)tokenField:(LATokenField *)tokenField representedObjectForEditingString:(NSString *)editingString;

/*!
 Allows the delegate to provide a represented object for the given editing dictionary.
 @param editingDictionary The editing dictionary picked from the list of completions
 @return A represented object for the editing dictionary
 */
- (id)tokenField:(LATokenField *)tokenField representedObjectForEditingDictionary:(NSDictionary *)editingDictionary;

/*!
 @group Managing Token
 */

/*!
 @return YES if the token field should add the specified token.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object to be inserted in the receiver at index.
 @param index The index of the receiver in which the token to be validated will be inserted.
 @discussion The delegate can return NO to prevent object insertion.
 */
- (BOOL)tokenField:(LATokenField *)tokenField shouldAddRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 Tells the delegate a token was inserted in a specified index.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object inserted in the receiver at index.
 @param index The index of the receiver in which the token was inserted.
 */
- (void)tokenField:(LATokenField *)tokenField didAddRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 @return YES if the token field should remove the specified token.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object to be removed in the receiver at index.
 @param index The index of the receiver in which the token to be validated will be removed from.
 @discussion The delegate can return NO to prevent object removal. 
 */
- (BOOL)tokenField:(LATokenField *)tokenField shouldRemoveRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 Tells the delegate a token was removed from a specified index.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object remove in the receiver from index.
 @param index The index of the receiver in which the token was removed.
 */
- (void)tokenField:(LATokenField *)tokenField didRemoveRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 @group Pasteboard
 */

//
///*!
// We put the string on the pasteboard before calling this delegate method. 
// By default, we write the NSStringPboardType as well as an array of NSStrings.
// */
////- (BOOL)tokenField:(LATokenField *)tokenField writeRepresentedObjects:(NSArray *)objects toPasteboard:(NSPasteboard *)pboard;
//
///*!
// Return an array of represented objects to add to the token field.
// */
////- (NSArray *)tokenField:(LATokenField *)tokenField readFromPasteboard:(NSPasteboard *)pboard;
//
///*!
// By default the tokens have no menu.
// */
////- (NSMenu *)tokenField:(LATokenField *)tokenField menuForRepresentedObject:(id)representedObject;
//- (BOOL)tokenField:(LATokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject; 

@end
