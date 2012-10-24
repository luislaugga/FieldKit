//
//  FKTextField_Internal.h
//  FieldKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "FKTextField.h"
#import "FKTextSelecting.h"
#import "FKTextContentView.h"
#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#pragma mark -
#pragma mark FKTextField internal class extension

/*!
 @category FKTextField internal extension
 */
@interface FKTextField () <FKTextSelectingContainer>
{
    @protected
    FKTextContentView * _contentView;
    FKTextSelectionView * _selectionView;
    FKTextInteractionAssistant * _interactionAssistant;    
}

@property(nonatomic, readwrite) BOOL editing;

- (void)showSelectionView:(BOOL)visible;

@end

