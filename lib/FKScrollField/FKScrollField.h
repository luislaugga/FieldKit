/*
 
 FKScrollField.h
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

#import "FKScrollFieldDelegate.h"

static const NSTimeInterval FKScrollFieldChangeHeightAnimationDuration = 0.1;
static const UIViewAnimationCurve FKScrollFieldChangeHeightAnimationCurve = UIViewAnimationCurveEaseInOut;
static const UIViewAnimationOptions FKScrollFieldChangeHeightAnimationOptions = (UIViewAnimationOptionCurveEaseInOut);

@interface FKScrollField : UIControl
{
    UITextField * _textField;
    UITextView * _textView;
    
    BOOL _editing;
    
    id<FKScrollFieldDelegate> delegate;
}

@property(nonatomic,copy) NSString * text;                      // default is nil
@property(nonatomic,retain) UIColor * textColor;                // default is nil. use opaque black
@property(nonatomic,retain) UIFont * font;                      // default is nil. use system font 12 pt
@property(nonatomic) CGFloat minimumFontSize;                   // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
@property(nonatomic) UITextAlignment textAlignment;             // default is UITextAlignmentLeft
@property(nonatomic,copy) NSString * placeholder;               // default is nil. string is drawn 70% gray
@property(nonatomic) UITextBorderStyle borderStyle;             // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
@property(nonatomic,retain) UIImage * background;               // default is nil. draw in border rect. image should be stretchable
@property(nonatomic,retain) UIImage * disabledBackground;       // default is nil. ignored if background not set. image should be stretchable
@property(nonatomic) BOOL clearsOnBeginEditing;                 // default is NO which moves cursor to location clicked. if YES, all text cleared
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;            // default is NO. if YES, text will shrink to minFontSize along baseline
@property(nonatomic,readonly,getter=isEditing) BOOL editing;
@property(nonatomic,assign) id<FKScrollFieldDelegate> delegate;   // default is nil. weak reference

@end
