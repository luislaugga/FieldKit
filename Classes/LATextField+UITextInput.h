//
//  LATextField+UITextInput.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/20/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextField.h"
#import "LATextField_Internal.h"

#pragma mark -
#pragma mark LATextField (UITextInput)

/*!
 @abstract LATextField UITextInput protocol addition category
 @discussion 
 Check UITextInput protocol for the required methods and properties
 */
@interface LATextField (UITextInput) <UITextInput>
@end

#pragma mark -
#pragma mark LATextPosition

/*!
 @abstract LATextPosition is UITextPosition custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextPosition objects 
 for representing specific locations within the text managed by the class
 */
@interface LATextPosition : UITextPosition {
    NSUInteger _index;
    id <UITextInputDelegate> _inputDelegate;
}

@property (nonatomic) NSUInteger index;

/*!
 Class method to create an instance with a given NSUInteger index
 @return Returns LATextPosition autoreleased instance
 */ 
+ (LATextPosition *)textPositionWithIndex:(NSUInteger)index;

@end

#pragma mark -
#pragma mark LATextRange

/*!
 @abstract LATextRange is UITextRange custom subclass required by UITextInput
 @discussion 
 Classes that adopt the UITextInput protocol must create custom UITextRange objects 
 for representing specific ranges within the text managed by the class
 */
@interface LATextRange : UITextRange {
    NSRange _range;
}

@property (nonatomic) NSRange range;

/*!
 Class method to create an instance with a given NSRange range
 @return Returns LATextRange autoreleased instance
 */ 
+ (LATextRange *)textRangeWithRange:(NSRange)range;

@end