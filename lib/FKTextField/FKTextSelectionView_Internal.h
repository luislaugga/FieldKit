/*
 
 FKTextSelectionView_Internal.h
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

#import "FKTextSelectionView.h"

#pragma mark -
#pragma mark FKTextSelectionView internal class extension

/*!
 @category FKTextSelectionView internal extension
 */
@interface FKTextSelectionView ()

@property(nonatomic, unsafe_unretained) UIView<FKTextSelectingContainer> * selectingContainer;
@property(nonatomic, strong) UIView * caretView;

/*!
 Shows range view
 */
- (void)showRange;

/*!
 Hides range view
 */
- (void)hideRange;

/*!
 Show loupe magnifier view
 */
- (void)showMagnifier;
- (void)hideMagnifier;
- (void)updateMagnifier:(CGPoint)position;

/*!
 Toggle the visibility of the selection menu.
 */
- (void)toggleSelectionMenu;
- (void)hideSelectionMenu;

@end
