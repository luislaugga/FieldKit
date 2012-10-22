//
//  LATokenFieldCell.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    LADefaultTokenStyle,      // Style best used for keyword type tokens.  Currently a rounded style, but this may change in future releases.
    LAPlainTextTokenStyle,  // Style to use for data you want represented as plain-text and without any token background.
    LARoundedTokenStyle     // Style best used for address type tokens.
};
typedef NSUInteger LATokenStyle;

@interface LATokenFieldCell : UIControl
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
