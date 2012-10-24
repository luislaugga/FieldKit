//
//  FKScrollField_Internal.h
//  FieldKit
//
//  Created by Luis Laugga on 9/11/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "FKScrollField.h"

@interface FKScrollField () <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, readwrite,getter=isEditing) BOOL editing;

- (void)showTextView:(NSString *)text;
- (void)showTextField:(NSString *)text;

- (void)changeHeight:(CGFloat)height;
- (void)didChangeHeight:(CGFloat)height;

@end
