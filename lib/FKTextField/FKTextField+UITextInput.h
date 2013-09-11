/*
 
 FKTextField+UITextInput.h
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

#import "FKTextField.h"
#import "FKTextField_Internal.h"

#pragma mark -
#pragma mark FKTextField (UITextInput)

/*!
 @abstract FKTextField UITextInput protocol addition category
 @discussion 
 Check UITextInput protocol for the required methods and properties
 */
@interface FKTextField (UITextInput) <UITextInput>
@end

#pragma mark -
#pragma mark FKTextPosition

/*!
 @abstract FKTextPosition is UITextPosition custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextPosition objects 
 for representing specific locations within the text managed by the class
 */
@interface FKTextPosition : UITextPosition {
    NSUInteger _index;
    id <UITextInputDelegate> _inputDelegate;
}

@property (nonatomic) NSUInteger index;

/*!
 Class method to create an instance with a given NSUInteger index
 @return Returns FKTextPosition autoreleased instance
 */ 
+ (FKTextPosition *)textPositionWithIndex:(NSUInteger)index;

@end

#pragma mark -
#pragma mark FKTextRange

/*!
 @abstract FKTextRange is UITextRange custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextRange objects 
 for representing specific ranges within the text managed by the class
 */
@interface FKTextRange : UITextRange {
    NSRange _range;
}

@property (nonatomic) NSRange range;

/*!
 Class method to create an instance with a given NSRange range
 @return Returns FKTextRange autoreleased instance
 */ 
+ (FKTextRange *)textRangeWithRange:(NSRange)range;

@end