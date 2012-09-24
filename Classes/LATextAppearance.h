//
//  LATextAppearance.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LATextAppearance : NSObject

/*!
 Default text font
 */
+ (UIFont *)defaultFont;

/*!
 Default text color
 */
+ (UIColor *)defaultTextColor;

/*!
 Default background color
 */
+ (UIColor *)defaultBackgroundColor;

/*!
 Default selection caret color
 */
+ (UIColor *)defaultSelectionCaretColor;

/*!
 Default selection range color
 */
+ (UIColor *)defaultSelectionRangeColor;

/*!
 Default selection grabber color
 */
+ (UIColor *)defaultSelectionGrabberColor;

/*!
 Default selection caret rect frame
 */
+ (CGRect)selectionCaretFrameForTextRect:(CGRect)textRect;

@end
