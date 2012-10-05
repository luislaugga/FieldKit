//
//  ScrollField.h
//  ScrollField
//
//  Created by Luis Laugga on 9/11/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LAScrollFieldDelegate.h"

static const NSTimeInterval LAScrollFieldChangeHeightAnimationDuration = 0.1;
static const UIViewAnimationCurve LAScrollFieldChangeHeightAnimationCurve = UIViewAnimationCurveEaseInOut;
static const UIViewAnimationOptions LAScrollFieldChangeHeightAnimationOptions = (UIViewAnimationOptionCurveEaseInOut);

@interface LAScrollField : UIControl
{
    UITextField * _textField;
    UITextView * _textView;
    
    BOOL _editing;
    
    id<LAScrollFieldDelegate> delegate;
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
@property(nonatomic,assign) id<LAScrollFieldDelegate> delegate;   // default is nil. weak reference

@end
