//
//  LATextInteractionAssistant_Internal.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextInteractionAssistant.h"

#pragma mark -
#pragma mark LATextInteractionAssistant internal class extension

/*!
 @category LATextInteractionAssistant internal extension
 */
@interface LATextInteractionAssistant ()

@property(nonatomic, assign) UIView<LATextSelectingContainer> * selectingContainer;
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
