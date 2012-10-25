/*
 
 FKTextInteractionAssistant_Internal.h
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
