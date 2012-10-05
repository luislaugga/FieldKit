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

/*!
 @protocol LATokenFieldDelegate
 @abstract The LATokenFieldDelegate protocol defines the optional methods implemented by delegates of LATokenField objects.
 @discussion
 1. As the user types the delegate receives tokenField:completionsForSubstring:indexOfToken: and returns a list of editing strings
 2. If the user picks a completion from the list or types the tokening character, the editing string is set
 3. The delegate receives tokenField:representedObjectForEditing(String/Dictionary): and may return an object that represents the editing string
 4. If 3. succeeds then the delegate receives tokenField:displayStringForRepresentedObject: and may return a display string for the represented object
 
 The editing string can be anything and is set when a tokening character is inserted or a completion is picked from the list.
 The editing string picked from a completion list can either be a NSString or NSDictionary instance.
 The NSDictionary may contain detailed information about the completion. 
 Detail is displayed in the completion list as a sub-label ('Description' 'Text'). 
 It helps solving ambiguous situations, when there are more than one possible completions all related to the same entity.
 */
@protocol LATokenFieldDelegate <LATextFieldDelegate>

@optional

/*!
 @group Displaying Tokenized Strings
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
 @group Editing a Tokenized Strings
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
- (id)tokenField:(LATokenField *)tokenField representedObjectForEditingDictionary:(NSDictionary *)editingDictionary;

/*!
 @return An array of validated token represented objects.
 @param tokenField The token field that sent the message.
 @param tokens An array of token represented objects to be inserted in the receiver at index.
 @param index The index of the receiver in which the array of tokens to be validated (tokens) will be inserted.
 @discussion The delegate can return the array unchanged or return a modified array of tokens. 
 To reject the add completely, return an empty array. Returning nil causes an error.
 */
- (NSArray *)tokenField:(LATokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index;

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
