/*
 
 FKScrollField.h
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
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
    
    id<FKScrollFieldDelegate> __unsafe_unretained delegate;
}

@property(nonatomic,copy) NSString * text;                      // default is nil
@property(nonatomic,strong) UIColor * textColor;                // default is nil. use opaque black
@property(nonatomic,strong) UIFont * font;                      // default is nil. use system font 12 pt
@property(nonatomic) CGFloat minimumFontSize;                   // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
@property(nonatomic) UITextAlignment textAlignment;             // default is UITextAlignmentLeft
@property(nonatomic,copy) NSString * placeholder;               // default is nil. string is drawn 70% gray
@property(nonatomic) UITextBorderStyle borderStyle;             // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
@property(nonatomic,strong) UIImage * background;               // default is nil. draw in border rect. image should be stretchable
@property(nonatomic,strong) UIImage * disabledBackground;       // default is nil. ignored if background not set. image should be stretchable
@property(nonatomic) BOOL clearsOnBeginEditing;                 // default is NO which moves cursor to location clicked. if YES, all text cleared
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;            // default is NO. if YES, text will shrink to minFontSize along baseline
@property(nonatomic,readonly,getter=isEditing) BOOL editing;
@property(nonatomic,unsafe_unretained) id<FKScrollFieldDelegate> delegate;   // default is nil. weak reference

@end
