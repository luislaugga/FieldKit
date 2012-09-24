//
//  LATextContentView.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "LATextSelecting.h"

/*!
 @abstract Text Content View
 @discussion 
 View responsible for rendering text. Conforms to LATextSelectingContent and
 is usually inside another view (LATextSelectingContainer)
 */
@interface LATextContentView : UIView <LATextSelectingContent>
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
