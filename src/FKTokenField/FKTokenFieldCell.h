/*
 
 FKTokenFieldCell.h
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

enum {
    FKDefaultTokenStyle,      // Style best used for keyword type tokens.  Currently a rounded style, but this may change in future releases.
    FKPlainTextTokenStyle,  // Style to use for data you want represented as plain-text and without any token background.
    FKRoundedTokenStyle     // Style best used for address type tokens.
};
typedef NSUInteger FKTokenStyle;

@interface FKTokenFieldCell : UIControl
{
    UIFont * _font;
    NSString * _text;
    
    id _representedObject;
    
    BOOL _scaled;
    
    CGSize _size;
}

@property(nonatomic, copy) NSString * text;
@property(nonatomic, assign) UIFont * font;

@property(nonatomic, retain) id representedObject;

@property(nonatomic, readonly, getter = isScaled) BOOL scaled;
@property(nonatomic, readonly) CGSize size;

/*!
 */
- (id)initWithText:(NSString *)string andFont:(UIFont *)font;

/*!
 */
- (void)setScaled:(BOOL)scaled animated:(BOOL)animated;

@end
