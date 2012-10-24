//
//  FKTextInteractionAssistant.h
//  FieldKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKTextSelecting.h"

/*!
 @abstract Text Interaction Assistant
 @discussion 
 Object responsible for handling all user interactions and forwarding to the appropriate FKTextSelectingContainer views
 */
@interface FKTextInteractionAssistant : NSObject <UIGestureRecognizerDelegate>
{
    UIView<FKTextSelectingContainer> * _selectingContainer;
    UITapGestureRecognizer * _singleTapGesture;
    UITapGestureRecognizer * _doubleTapGesture;
}

/*!
 Required initialization method
 Initialize with a given selecting container
 */
- (id)initWithSelectingContainer:(UIView<FKTextSelectingContainer> *)selectingContainer;

@end
