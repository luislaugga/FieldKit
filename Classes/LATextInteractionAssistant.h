//
//  LATextInteractionAssistant.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LATextSelecting.h"

/*!
 @abstract Text Interaction Assistant
 @discussion 
 Object responsible for handling all user interactions and forwarding to the appropriate LATextSelectingContainer views
 */
@interface LATextInteractionAssistant : NSObject <UIGestureRecognizerDelegate>
{
    UIView<LATextSelectingContainer> * _selectingContainer;
    UITapGestureRecognizer * _singleTapGesture;
    UITapGestureRecognizer * _doubleTapGesture;
}

/*!
 Required initialization method
 Initialize with a given selecting container
 */
- (id)initWithSelectingContainer:(UIView<LATextSelectingContainer> *)selectingContainer;

@end
