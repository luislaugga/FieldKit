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
    NSString * _string;
    BOOL _selected;
    
    id _representedObject;
}

@property(nonatomic, assign) id representedObject;

@property(nonatomic, copy) NSString * string;
@property(nonatomic, assign) UIFont * font;
@property(nonatomic, assign, getter = isSelected) BOOL selected;

- (id)initWithString:(NSString *)string andFont:(UIFont *)font;

@end
