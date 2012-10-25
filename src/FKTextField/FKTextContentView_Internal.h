/*
 
 FKTextContentView_Internal.h
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

#import "FKTextContentView.h"

/*!
 @category FKTextContentView internal extension
 */
@interface FKTextContentView ()

@property (nonatomic, retain) NSMutableDictionary * attributes;

/*!
 Clean up rendering cached objects and other data
 */
- (void)clearPreviouslyCachedInformation;

/*!
 Converts CGRect from internal coordinate system (origin at bottom left) to
 UIView default coordinate system (origin at top left)
 */
- (CGRect)convertRectToUIViewDefaultCoordinateSystem:(CGRect)rect;

/*!
 Converts CGPoint from internal coordinate system (origin at bottom left) to
 UIView default coordinate system (origin at top left)
 */
- (CGPoint)convertPointFromUIViewDefaultCoordinateSystem:(CGPoint)point;

@end
