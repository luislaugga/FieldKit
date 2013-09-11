/*
 
 FKTextContentView.h
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

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "FKTextSelecting.h"

/*!
 @abstract Text Content View
 @discussion 
 View responsible for rendering text. Conforms to FKTextSelectingContent and
 is usually inside another view (FKTextSelectingContainer)
 */
@interface FKTextContentView : UIView <FKTextSelectingContent>
{
    // Text Properties
    NSString * _text; // Text content (without attributes)
    UIFont * _font; // Font used for text content
    UIColor * _textColor; // Color used for text content
    
    // Text Rendering
    NSMutableDictionary * _attributes; // Cached string attributes
    CTFramesetterRef _framesetter; // Cached Core Text framesetter
    CTFrameRef _frame; // Cached Core Text frame
}

@property (nonatomic, copy) NSString * text; 
@property (nonatomic, retain) UIColor * textColor;
@property (nonatomic, retain) UIFont * font;

/*!
 Updates text
 */
- (void)updateContentIfNeeded;

@end
