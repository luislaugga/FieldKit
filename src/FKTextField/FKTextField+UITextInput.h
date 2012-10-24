//
//  FKTextField+UITextInput.h
//  FieldKit
//
//  Created by Luis Laugga on 9/20/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

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