/*
 
 FKTokenFieldDelegate.h
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

#import "FKTextFieldDelegate.h"
#import "FKTokenFieldCell.h"

@class FKTokenField;

/*!
 NSDictionary keys for tokenField:completionsForSubstring:indexOfToken: returned completions and
 tokenField:representedObjectForEditingDictionary: editing completion
 */
static const NSString * FKTokenFieldCompletionDictionaryText = @"0";
static const NSString * FKTokenFieldCompletionDictionaryDetailDescription = @"1";
static const NSString * FKTokenFieldCompletionDictionaryDetailText = @"2";

/*!
 @protocol FKTokenFieldDelegate
 @abstract The FKTokenFieldDelegate protocol defines the optional methods implemented by delegates of FKTokenField objects.
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
@protocol FKTokenFieldDelegate <FKTextFieldDelegate>

@optional

/*!
 @group Displaying Token
 */

/*!
 This method allows you to change the style for individual tokens as well as have mixed text and tokens.
 */
- (FKTokenStyle)tokenField:(FKTokenField *)tokenField styleForRepresentedObject:(id)representedObject;

/*!
 Allows the delegate to provide a string to be displayed as a proxy for the given represented object.
 @param tokenField The token field that sent the message.
 @param representedObject A represented object of the token field.
 @return The string to be used as a proxy for representedObject. 
 @discussion If you return nil or do not implement this method, then representedObject is displayed as the string.
 */
- (NSString *)tokenField:(FKTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject;

/*!
 Allows the delegate to provide a FKTokenFieldCell subclass for a specific represented object.
 @param tokenField The token field that sent the message.
 @param representedObject A represented object of the token field.
 @return The FKTokenFieldCell subclass to be used as a proxy for representedObject.
 @discussion If you return nil or do not implement this method, then FKTokenFieldCell will be used.
 */
- (FKTokenFieldCell *)tokenField:(FKTokenField *)tokenField cellForRepresentedObject:(id)representedObject;

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
- (NSArray *)tokenField:(FKTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex;

/*!
 Allows the delegate to provide a represented object for the given editing string.
 @param editingString The editing string picked from the list of completions or typed by the user followed by a tokenizer character.
 @return A represented object that is displayed rather than the editing string.
 */
- (id)tokenField:(FKTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString;

/*!
 Allows the delegate to provide a represented object for the given editing dictionary.
 @param editingDictionary The editing dictionary picked from the list of completions
 @return A represented object for the editing dictionary
 */
- (id)tokenField:(FKTokenField *)tokenField representedObjectForEditingDictionary:(NSDictionary *)editingDictionary;

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
- (BOOL)tokenField:(FKTokenField *)tokenField shouldAddRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 Tells the delegate a token was inserted in a specified index.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object inserted in the receiver at index.
 @param index The index of the receiver in which the token was inserted.
 */
- (void)tokenField:(FKTokenField *)tokenField didAddRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 @return YES if the token field should remove the specified token.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object to be removed in the receiver at index.
 @param index The index of the receiver in which the token to be validated will be removed from.
 @discussion The delegate can return NO to prevent object removal. 
 */
- (BOOL)tokenField:(FKTokenField *)tokenField shouldRemoveRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 Tells the delegate a token was removed from a specified index.
 @param tokenField The token field that sent the message.
 @param representedObject The token represented object remove in the receiver from index.
 @param index The index of the receiver in which the token was removed.
 */
- (void)tokenField:(FKTokenField *)tokenField didRemoveRepresentedObject:(id)representedObject atIndex:(NSUInteger)index;

/*!
 @group Pasteboard
 */

//
///*!
// We put the string on the pasteboard before calling this delegate method. 
// By default, we write the NSStringPboardType as well as an array of NSStrings.
// */
////- (BOOL)tokenField:(FKTokenField *)tokenField writeRepresentedObjects:(NSArray *)objects toPasteboard:(NSPasteboard *)pboard;
//
///*!
// Return an array of represented objects to add to the token field.
// */
////- (NSArray *)tokenField:(FKTokenField *)tokenField readFromPasteboard:(NSPasteboard *)pboard;
//
///*!
// By default the tokens have no menu.
// */
////- (NSMenu *)tokenField:(FKTokenField *)tokenField menuForRepresentedObject:(id)representedObject;
//- (BOOL)tokenField:(FKTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject; 

@end
