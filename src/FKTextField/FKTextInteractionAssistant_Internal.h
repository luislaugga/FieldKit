//
//  FKTextInteractionAssistant_Internal.h
//  FieldKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "FKTextInteractionAssistant.h"

#pragma mark -
#pragma mark FKTextInteractionAssistant internal class extension

/*!
 @category FKTextInteractionAssistant internal extension
 */
@interface FKTextInteractionAssistant ()

@property(nonatomic, assign) UIView<FKTextSelectingContainer> * selectingContainer;
@property(nonatomic, retain) UITapGestureRecognizer * singleTapGesture; // @synthesize singleTapGesture = _singleTapGesture;
@property(nonatomic, retain) UITapGestureRecognizer * doubleTapGesture; // @synthesize doubleTapGesture = _doubleTapGesture;

/*! 
 Action method for single-tap UITapGestureRecognizer
 */
- (void)userDidSingleTap:(UITapGestureRecognizer *)singleTapGesture;

/*! 
 Action method for double-tap UITapGestureRecognizer
 */
- (void)userDidDoubleTap:(UITapGestureRecognizer *)doubleTapGesture;

@end
