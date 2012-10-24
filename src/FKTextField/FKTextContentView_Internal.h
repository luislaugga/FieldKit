//
//  FKTextContentView_Internal.h
//  FieldKit
//
//  Created by Luis Laugga on 9/19/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

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
